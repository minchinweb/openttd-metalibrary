/*	Lakes Check v.3 [2014-03-05],
 *		part of Minchinweb's MetaLibrary v.7,
 *		replacement for WaterBody Check
 *	Copyright © 2011-14 by W. Minchin. For more info,
 *		please visit https://github.com/MinchinWeb/openttd-metalibrary
 *
 *	Permission is granted to you to use, copy, modify, merge, publish,
 *	distribute, sublicense, and/or sell this software, and provide these
 *	rights to others, provided:
 *
 *	+ The above copyright notice and this permission notice shall be included
 *		in all copies or substantial portions of the software.
 *	+ Attribution is provided in the normal place for recognition of 3rd party
 *		contributions.
 *	+ You accept that this software is provided to you "as is", without warranty.
 */

/**	\brief		Lakes
 *	\version	v.3 (2012-03-05)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.7
 *
 *	Lakes is a replacement for WaterBody Check (\_MinchinWeb\_WBC\_). Lakes
 *		serves to determine if two water tiles are connected by water (i.e. if a
 *		ship could sail between them). It trades memory usage for speed by
 *		caching results. Like WaterBody Check, it will keep trying to find a
 *		connections until there is no possible connection left.
 *
 *	Approximate program flow:
 *
 *	\dot
	digraph G {
		Start -> {B; A};
		A -> AreaA;
		B -> AreaB;
		AreaA -> AddPtA [label="unknown"];
		{AreaA; AreaB} -> Match [label="known"];
		AreaB -> AddPtB [label="unknown"];
		Match -> Yes1 [label="yes"];
		Match -> StillEdges [label="no"];
		{AddPtA; AddPtB} -> StillEdges;
		StillEdges -> StillEdgeA [label="yes"];
		StillEdgeA -> StillEdgeB [label="no"];
		StillEdgeB -> StillEdges [label="no"]
		StillEdgeA -> PickEdgeA -> AMatchB;
		AMatchB -> FoundMatch [label="yes"];
		AMatchB -> AddA [label="no"];
		AddA -> AddEdgeA -> StillEdgeB -> PickEdgeB;
		PickEdgeB -> BMatchA;
		BMatchA -> FoundMatch [label="yes"];
		BMatchA -> AddB [label="no"];
		AddB -> AddEdgeB -> StillEdges;
		FoundMatch -> Yes2;
		StillEdges -> No1 [label="no"];

		Start [shape=box];
		A [label="Point A"];
		B [label="Point B"];
		AreaA [shape=diamond, label="Area?"];
		AreaB [shape=diamond, label="Area?"];
		AddPtA [label="Add Point"];
		AddPtB [label="Add Point"];
		Match [shape=diamond, label="Areas\nmatch?"];
		Yes1 [shape=box, label="return\n'true'"];
		Yes2 [shape=box, label="return\n'true'"];
		No1 [shape=box, label="return\n'null'"];
		StillEdges [shape=diamond, label="Still\nedges?"];
		StillEdgeA [shape=diamond, label="Edge left\non A?"];
		StillEdgeB [shape=diamond, label="Edge left\non B?"];
		PickEdgeA [label="Pick past-edge\nclosest to B"];
		PickEdgeB [label="Pick past-edge\nclosest to A"];
		AMatchB [shape=diamond, label="In B's\n area?"];
		BMatchA [shape=diamond, label="In A's\n area?"];
		AddA [label="Add tile\nto\nArea A"];
		AddB [label="Add tile\nto\nArea B"];
		AddEdgeA [label="Add new\npast-edges"];
		AddEdgeB [label="Add new\npast-edges"];
		FoundMatch [label="Match\nfound!"];

		{ rank=same; A -> B [color=white]; }
		{ rank=same; StillEdgeA; StillEdgeB; }
	}
 *	\enddot
 *
 *	\requires	\_MinchinWeb\_DLS\_
 *	\requires	Fibonacci Heap v.3
 *	\see		\_MinchinWeb\_ShipPathfinder\_
 *	\see		\_MinchinWeb\_WBC\_
 *	\note		Although _map and _group_tiles keep the same information (which
 *				tiles are in which group), there are independently created and
 *				maintained. If for some reason they become de-synced, Lakes
 *				will not work as expected. However, the previous approach of
 *				effectively creating _group_tiles from _map on the fly twice a
 *				loop was deemed too time demanding.
 */

class _MinchinWeb_Lakes_ {
	_heap_class = import("queue.fibonacci_heap", "", 3);

	/**	\brief	AIList that tells which group each tile belongs in
	 *
	 *	`item` is TileIndex, `value` is Group. `value == -2` means the value
	 *	remains unset, `value == -1` means the tile is land.
	 */
	_map = null;

	/**	\brief	Array that shows the connections to each tile group
	 *
	 *	`index` is TileGroup.
	 */
	_connections = null;

	/**	\brief	Array of the defined tile groups
	 *
	 *	`index` is TileGroup.
	 */
	_areas = null;

	/**	\brief	Array of tiles that are open from each tile group
	 *
	 *	`index` is TileGroup; form is [Edge_Tile, Past_Edge_Tile]
	 */
	_open_neighbours = null;

	/**	\brief	Array of AIList's of the tiles that are in each group
	 *
	 *	`index` is TileGroup
	 *	\note	Does not contain land tiles (i.e. group `-1`)
	 */
	_group_tiles = null;
	_AGroup = null;				///< array of groups containing source tiles
	_BGroup = null;				///< array of groups containing goal tiles
	_A = null;					///< array of source tiles
	_B = null;					///< array of goal tiles

	_running = null;			///< is Lakes currently running?

	constructor() {
		this._map = AIList();
		for (local i = 0; i < AIMap.GetMapSize(); i++) {
			this._map.AddItem(i, -2);
		}
		this._connections = array(0);
		this._areas = array(0);
		this._open_neighbours = array(0);
		this._group_tiles = array(0);
		this._running = false;
	};

	/**	\publicsection
	 * Initialize a path search between sources and goals.
	 * \param	sources	The source tiles. Assumed to be an array.
	 * \param	goals	The target tiles. Assumed to be an array.
	 */
	function InitializePath(sources, goals) {
		this._AGroup = array(0);
		this._BGroup = array(0);
		this._A = sources;
		this._B = goals;

		foreach (node in sources) {
			this._AGroup.push(this.AddPoint(node));
		}
		foreach (node in goals) {
			this._BGroup.push(this.AddPoint(node));
		}

		this._AGroup = _MinchinWeb_Array_.RemoveDuplicates(this._AGroup);
		this._BGroup = _MinchinWeb_Array_.RemoveDuplicates(this._BGroup);
		this._running = true;
	};

	/**
	 * Try to find if the source and goal tiles are within the same waterbody.
	 * \param	iterations	After how many iterations it should abort for a
	 *						moment. This value should either be -1 for infinite,
	 *						or > 0. Any other value aborts immediately and will
	 *						never find a path.
	 * \return	'true' if within the same waterbody, or 'false' if the amount of
	 *			iterations was reached, or 'null' if no path was found.
	 *  You can call this function over and over as long as it returns false,
	 *  which is an indication it is not yet done looking for a route.
	 */
	function FindPath(iterations);

	/**	\private
	 *	\brief	Seeds the grid points to Lakes.
	 *
	 *	Called by the class initialization function.
	 *	\see	PreSeed()
	 */
	function _AddGridPoints();

	/**	\public
	 *	\brief	Seeds a point into Lakes.
	 *	\param	myTileID	Assumed to be a tile index.
	 *	\return	Area the tile is in. -1 if the tile is on land.
	 */
	function AddPoint(myTileID);

	/** \private
	  *	\brief	Given a starting group, return all groups attached to it
	  *	\param	StartGroupArray	assumed to be an array
	  *	\return	An array listing all the attached tile groups
	  */
	function _AllGroups(StartGroupArray);

	/**	\public
	 *	\brief	Get the minimum distance between the source and destination
	 *			tiles.
	 *	\note	Distance is calculated as Manhattan Distance
	 */
	function GetPathLength();

	/**	\privatesection
	 *	\brief	Processes `NextTile`s neighbours
	 *	\param	NextTile	Tile we consider the neighbours of
	 *	\return	`[null]` if no neighbours are added.
	 *	\return	An array of the neighbours added otherwise.
	 */
	function _AddNeighbour(NextTile);

	/**	\public
	 *	\brief	Adds 'starter' tile groups across the map.
	 *
	 *	This inserts any tile that is water that falls on an 8x8 grid. This is
	 *	not required to be run before using the class.
	 */
	function Preseed() {	this._AddGridPoints();	}
};


function _MinchinWeb_Lakes_::FindPath(iterations) {
	//	This is where the meat and potatoes is!
	//	See the diagram in the docs for how this works
	if (iterations < 0) {
		iterations = _MinchinWeb_C_.Infinity();
	}
	for (local i = 0; i < iterations; i++) {
		local tick = AIController.GetTick();
		if (_MinchinWeb_Array_.Compare1D(this._AGroup, [-1]) || _MinchinWeb_Array_.Compare1D(this._BGroup, [-1])) {
			//	one end is all on land
			//	no path is possible
			_MinchinWeb_Log_.Note("Lakes failed to find a path. One end is all on land.", 5);
			this._running = false;
			return null;
		}

		//	Get not only the groups the tiles are in, but all the tile groups
		//		that are connected
		local AAllGroups = _AllGroups(this._AGroup);
		_MinchinWeb_Log_.Note("AGroup: " + _MinchinWeb_Array_.ToString1D(this._AGroup, false) + " All A:" + _MinchinWeb_Array_.ToString1D(AAllGroups, false), 6);

		foreach (Group in AAllGroups) {
			if (_MinchinWeb_Array_.ContainedIn1D(this._BGroup, Group)) {
				//	If we have a connection, return 'true'
				_MinchinWeb_Log_.Note("B Group (" + this._BGroup[0] + ")found in A All Groups!", 6);
				this._running = false;
				return true;
			}
		}

		//	No match (yet anyway...)
		//	Get all the open neighbours of A
		local ANeighbours = array(0);
		local AEdge = array(0);
		local BAllGroups = array(0);
		AAllGroups = _AllGroups(this._AGroup);
		BAllGroups = _AllGroups(this._BGroup);

		foreach (Group in AAllGroups){
			ANeighbours = _MinchinWeb_Array_.Append(ANeighbours, this._open_neighbours[Group]);
		}
		foreach (neighbour in ANeighbours) {
			AEdge.append(neighbour[0]);
		}

		//	remove duplicates
		AEdge = _MinchinWeb_Array_.RemoveDuplicates(AEdge);
		_MinchinWeb_Log_.Note("A -- Edge: " + AEdge.len() + "  Neighbours: " + ANeighbours.len(), 6);
		_MinchinWeb_Log_.Note("A -- Edge: " + _MinchinWeb_Array_.ToStringTiles1D(AEdge), 7);

		if (ANeighbours.len() > 0) {
			//	Get the tile from AEdge that is closest to B's
			local BTileList = AIList();
			foreach (group in BAllGroups) {
				BTileList.AddList(this._group_tiles[group]);
			}
			local AEdgeHeap = this._heap_class();
			foreach (edge in AEdge) {
				AEdgeHeap.Insert(edge, _MinchinWeb_Extras_.MinDistance(edge, BTileList));
			}

			//_MinchinWeb_Log_.Note("    B -- Tiles: " + _MinchinWeb_Array_.ToStringTiles1D(BTileArray), 7);

			//	Process the tile's 4 neighbours x12
			for (local j=0; j < 12; j++) {
				if (AEdgeHeap.Count() > 0) {
					local NextNeighbour = AEdgeHeap.Pop();
					local AddedNeighbours = _AddNeighbour(NextNeighbour);
					foreach (Tile in AddedNeighbours) {
						if (Tile != null) {
							AEdgeHeap.Insert(Tile, _MinchinWeb_Extras_.MinDistance(Tile, BTileList));
						}
					}
				}
			}
		} else {
			//	With no 'open neighbours', there can be no more connections
			this._running = false;
			return null;
		}

		local BNeighbours = array(0);
		local BEdge = array(0);
		AAllGroups = _AllGroups(this._AGroup);
		BAllGroups = _AllGroups(this._BGroup);

		//	Check to see if we have a connection (and can go home!)
		_MinchinWeb_Log_.Note("BGroup: " + _MinchinWeb_Array_.ToString1D(this._AGroup, false) + " All B:" + _MinchinWeb_Array_.ToString1D(AAllGroups, false), 6);
		foreach (Group in BAllGroups) {
			if (_MinchinWeb_Array_.ContainedIn1D(this._AGroup, Group)) {
				//	If we have a connection, return 'true'
				_MinchinWeb_Log_.Note("A Group (" + this._AGroup[0] + ") found in B All Groups!", 6);
				this._running = false;
				return true;
			}
		}

		foreach (Group in BAllGroups) {
			BNeighbours = _MinchinWeb_Array_.Append(BNeighbours, this._open_neighbours[Group]);
		}
		foreach (neighbour in BNeighbours) {
			BEdge.append(neighbour[0]);
		}
		//	remove duplicates
		BEdge = _MinchinWeb_Array_.RemoveDuplicates(BEdge);
		_MinchinWeb_Log_.Note("B -- Edge: " + BEdge.len() + "  Neighbours: " + BNeighbours.len(), 6);
		_MinchinWeb_Log_.Note("B -- Edge: " + _MinchinWeb_Array_.ToStringTiles1D(BEdge), 7);

		if (BNeighbours.len() > 0) {
			//	Get the tile from AEdge that is closest to BEdge
			local ATileList = AIList();
			foreach (group in AAllGroups) {
				ATileList.AddList(this._group_tiles[group]);
			}
			local BEdgeHeap = this._heap_class();
			foreach (edge in BEdge) {
				BEdgeHeap.Insert(edge, _MinchinWeb_Extras_.MinDistance(edge, ATileList));
			}

			//_MinchinWeb_Log_.Note("    A -- Tiles: " + _MinchinWeb_Array_.ToStringTiles1D(ATileArray), 7);

			//	Process the tile's 4 neighbours x12
			for (local j=0; j < 12; j++) {
				if (BEdgeHeap.Count() > 0) {
					local NextNeighbour = BEdgeHeap.Pop();
					local AddedNeighbours = _AddNeighbour(NextNeighbour);
					foreach (Tile in AddedNeighbours) {
						if (Tile != null) {
							BEdgeHeap.Insert(Tile, _MinchinWeb_Extras_.MinDistance(Tile, ATileList));
						}
					}
				}
			}
		} else {
			//	With no 'open neighbours', there can be no more connections
			this._running = false;
			return null;
		}
		_MinchinWeb_Log_.Note("B -- " + (AIController.GetTick() - tick) + " ticks.", 8);
	}

	//	ran out of loops, we're still running
	return false;

}

function _MinchinWeb_Lakes_::GetPathLength() {
	local BList = _MinchinWeb_Array_.ToAIList(this._B);
	local MinDist = _MinchinWeb_C_.Infinity();
	BList.Valuate(_MinchinWeb_Extras_.MinDistance, this._A);
	return BList.GetValue(BList.Begin()); // value of first item
}

//	== Functions not related to the pathfinder ===============================

function _MinchinWeb_Lakes_::_AddGridPoints() {
	local myDLS = _MinchinWeb_DLS_();
	local Grid = myDLS.AllGridPoints()

	foreach (point in Grid) {
		AddPoint(point)
	}
}

function _MinchinWeb_Lakes_::AddPoint(myTileID) {
	// _MinchinWeb_Log_.Note("Tile Area " + this._map.GetValue(myTileID) + " : " + this._map.Count() + " / " + this._areas.len(), 6);

	switch (this._map.GetValue(myTileID)) {
		case -2:
			//	tile is unset (i.e. in no group)
			if (AITile.IsWaterTile(myTileID) == true) {
				//	add to _map if a water tile
				local myArea = this._areas.len();
				this._areas.append(myTileID);
				this._open_neighbours.append([]);
				this._connections.append([]);
				this._map.SetValue(myTileID, myArea);
				this._group_tiles.append(AIList());
				this._group_tiles[myArea].AddItem(myTileID, myTileID);

				local offsets = [AIMap.GetTileIndex(0, 1), AIMap.GetTileIndex(0, -1),
							 	 AIMap.GetTileIndex(1, 0), AIMap.GetTileIndex(-1, 0)];

				foreach (offset in offsets) {
					local next_tile = myTileID + offset;
					if (AIMarine.AreWaterTilesConnected(myTileID, next_tile)) {
						if (this._map.GetValue(next_tile) == -2) {
							this._open_neighbours[myArea].append([myTileID, next_tile]);
						} else if (this._map.GetValue(next_tile) == -1) {
							//	the tile has ceased to be land (somehow...)
							this._map.SetValue(next_tile, -2);
							this._open_neighbours[myArea].append([myTileID, next_tile]);
						} else {
							//	register connection right now
							local ConnectedArea = this._map.GetValue(next_tile);

							this._connections[myArea].append(ConnectedArea);
							this._connections[ConnectedArea].append(myArea);

							local AllConnectedAreas = _AllGroups([ConnectedArea]);

							//	remove open neighbour from AllConnectedAreas to next_tile
							foreach (ThisArea in AllConnectedAreas) {
								for (local i=0; i < this._open_neighbours[ThisArea].len(); i++) {
									if (this._open_neighbours[ThisArea][i][1] == myTileID) {
										//	we're looking for the reverse tile pair to the one we just tried to add
										this._open_neighbours[ThisArea] = _MinchinWeb_Array_.RemoveValueAt(this._open_neighbours[ThisArea], i);
										i--;
									}
								}
							}
						}
					}
				}

				_MinchinWeb_Log_.Note(myArea + " : " + _MinchinWeb_Array_.ToStringTiles2D(this._open_neighbours[myArea], false), 7);
				_MinchinWeb_Log_.Sign(myTileID, "L" + myArea, 8);
				return myArea;
			} else {
				//	land tile
				this._map.SetValue(myTileID, -1);
				//	not added to _group_tiles
				return -1;
			}
		case -1:
			//	land tile
			return -1;
		default:
			//	already in _map
			return this._map.GetValue(myTileID);
	}
}

function _MinchinWeb_Lakes_::_AllGroups(StartGroupArray) {
	//	this function starts with an array of starting groups
	//	starts at the beginning and for the first group, appends all connected
	//		groups to the end of the array
	//	does the same for the second and so on until the original end of the
	//		array
	//	next it compacts the resulting array by removing duplicates
	//	then it picks up where it left off in the (now larger) array and starts
	//		adding connections again
	//	this cycle keeps going until no more connections are added that aren't
	//		duplicates

	local loops = 0;
	local StartIndex = 0;
	local ReturnGroup = StartGroupArray;
	local NextStartIndex = 0;
	local MoreAdded = true;

	do {
		//_MinchinWeb_Log_.Note("In AllGroups(), loop " + loops + ". start: " + StartIndex + " // " + _MinchinWeb_Array_.ToString1D(ReturnGroup, false), 6);
		MoreAdded = false;
		NextStartIndex = ReturnGroup.len();
		for (local i = StartIndex; i < NextStartIndex; i++) {
			if ((ReturnGroup[i] >= 0) && (this._connections[ReturnGroup[i]].len() > 0)) {
				ReturnGroup = _MinchinWeb_Array_.Append(ReturnGroup, this._connections[ReturnGroup[i]]);
				ReturnGroup = _MinchinWeb_Array_.RemoveDuplicates(ReturnGroup);
				MoreAdded = true;
			}
		}
		StartIndex = NextStartIndex;
		loops++;
	} while (MoreAdded == true)

	return ReturnGroup;
}

function _MinchinWeb_Lakes_::_AddNeighbour(NextTile) {
	//	Start by finding out what area we're expanding
	local ReturnTiles = array(0);
	local OnwardTiles = array(0);
	for (local i = 0; i < this._open_neighbours.len(); i++) {
		for (local j = 0; j < this._open_neighbours[i].len(); j++) {
			if (this._open_neighbours[i][j][0] == NextTile) {
				OnwardTiles.append(this._open_neighbours[i][j][1]);
				this._open_neighbours[i] = _MinchinWeb_Array_.RemoveValueAt(this._open_neighbours[i], j);
				j--;
			}
		}
	}
	//	remove duplicates
	OnwardTiles = _MinchinWeb_Array_.RemoveDuplicates(OnwardTiles);
	//	remove onward tiles that are already in a tile group
	local ConnectedGroups = _AllGroups([this._map[NextTile]]);
	for (local i = 0; i < OnwardTiles.len(); i++) {
		if (this._map[OnwardTiles[i]] != -2) {
			//	But only if we've already registered the connection
			if (_MinchinWeb_Array_.ContainedIn1D(ConnectedGroups, this._map[OnwardTiles[i]])) {
				OnwardTiles = _MinchinWeb_Array_.RemoveValueAt(OnwardTiles, i);
				//	Add remove from open neighbours
				i--;
			}
		}

	}
	_MinchinWeb_Log_.Note("NextTile: " + _MinchinWeb_Array_.ToStringTiles1D([NextTile]) + "  //  Onward Tiles: " + _MinchinWeb_Array_.ToStringTiles1D(OnwardTiles), 8);

	if (OnwardTiles.len() == 0) {
		//	if something broke, spit out useful debug information
		_MinchinWeb_Log_.Note("     MinchinWeb.Lakes._AddNeighbour(): No source for " + _MinchinWeb_Array_.ToStringTiles1D([NextTile]), 8);
		/*_MinchinWeb_Log_.Note("    this._open_neighbours");
		for (local i = 0; i < this._open_neighbours.len(); i++) {
			_MinchinWeb_Log_.Note("    [" + i + "] " + _MinchinWeb_Array_.ToString2D(this._open_neighbours[i]), 0);
		}*/

		return [null];
	} else {
		local FromGroup = this._map.GetValue(NextTile);
		local offsets = [AIMap.GetTileIndex(0, 1), AIMap.GetTileIndex(0, -1),
						 AIMap.GetTileIndex(1, 0), AIMap.GetTileIndex(-1, 0)];

		//	Check that each neighbour is still attached by water to our from tile,
		//		and then add it to the FromGroup
		//		Then add possible neighbours to the open_neighbours list
		foreach (OnwardTile in OnwardTiles) {
			if (AIMarine.AreWaterTilesConnected(NextTile, OnwardTile)) {
				this._map.SetValue(OnwardTile, FromGroup);
				this._group_tiles[FromGroup].AddItem(OnwardTile, OnwardTile);
				ReturnTiles.append(OnwardTile);
				_MinchinWeb_Log_.Sign(OnwardTile, "L" + FromGroup, 8);
				foreach (offset in offsets) {
					local next_tile = OnwardTile + offset;
					if (AIMarine.AreWaterTilesConnected(OnwardTile, next_tile) && (this._map.GetValue(next_tile) != this._map.GetValue(OnwardTile))) {
						this._open_neighbours[FromGroup].append([OnwardTile, next_tile]);
					}
				}
			}

			//	If more than one groups list this tile as an open neighbour,
			//		register the two groups are now linked
			for (local i = 0; i < this._open_neighbours.len(); i++) {
				for (local j = 0; j < this._open_neighbours[i].len(); j++) {
					if (this._open_neighbours[i][j][1] == OnwardTile) {
						local ActiveFromGroup = this._map.GetValue(this._open_neighbours[i][j][0]);
						this._connections[FromGroup].append(ActiveFromGroup);
						this._connections[ActiveFromGroup].append(FromGroup);
						this._open_neighbours[i] = _MinchinWeb_Array_.RemoveValueAt(this._open_neighbours[i], j);
						j--;

						//	remove duplicates
						local oldActiveFromGroup = this._connections[ActiveFromGroup];
						local oldFromGroup = this._connections[FromGroup];
						this._connections[ActiveFromGroup] = _MinchinWeb_Array_.RemoveDuplicates(this._connections[ActiveFromGroup]);
						this._connections[FromGroup] = _MinchinWeb_Array_.RemoveDuplicates(this._connections[FromGroup]);
						//_MinchinWeb_Log_.Note("    Connections: " + FromGroup + " : " + _MinchinWeb_Array_.ToString1D(oldFromGroup, false) + "-> " + _MinchinWeb_Array_.ToString1D(this._connections[FromGroup], false), 7);
						//_MinchinWeb_Log_.Note("    Connections: " + ActiveFromGroup + " : " + _MinchinWeb_Array_.ToString1D(oldActiveFromGroup, false) + "-> " + _MinchinWeb_Array_.ToString1D(this._connections[ActiveFromGroup], false), 7);
					}
				}
			}
		}
	}
	return ReturnTiles;
}
//	EOF
