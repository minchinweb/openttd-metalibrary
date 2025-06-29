/*	ShipPathfinder v.5, [2014-02-28],
 *		part of Minchinweb's MetaLibrary v.7,
 *		originally part of WmDOT v.7
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

/**	\brief		A Ship Pathfinder.
 *	\version	v.5 (2014-02-28)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.2
 *
 *	I decided to create a pathfinder based on geometry rather than using the A*
 *	approach I used for roads. My pathfinder works like this:
 *	-	To initialize, a path with two points (the start and end) is added to
 *		the pathfinder. For each following loop:
 *		1.	The shortest (unfinished) path is pulled from the pathfinder.
 *		2.	The path is walked, point-to-point, until land is reached.
 *			-	If land is reached, two lines are drawn at right angles starting
 *				the midpoint (of the land). If water if reached, that point is
 *				then added to the path, and the path is added to the
 *				'unfinished' list.
 *		3.	If the shortest path is on the 'finished' list (i.e. all water),
 *			then that path is returned. Otherwise, the loop restarts.
 *
 *	With simple geometries, it works fast and well. However, on complex
 *	geometries, it doesn't work as well as I would like. The other problem I
 *	have is that the geometry only works on the basis that the start and end
 *	points are in the same waterbody, and so I created \_MinchinWeb\_Lakes\_
 *	(Lakes) to confirm this is the case; however it adds running time
 *	to the whole pathfinder. One the plus side, building the path is very
 *	simple: just build buoys at each point along the path!
 *
 *	\note		\_MinchinWeb\_WBC\_ has been depreciated in favour of
 *				\_MinchinWeb\_Lakes\_.
 *
 *	\requires	Fibonacci Heap v.3
 *	\see		\_MinchinWeb\_WBC\_
 *	\see		\_MinchinWeb\_Lakes\_
 *	\see		\_MinchinWeb\_RoadPathfinder\_
 *	\todo		Add image showing how the Ship Pathfinder works
 */


class _MinchinWeb_ShipPathfinder_
{
	_heap_class = import("queue.fibonacci_heap", "", 3);
	_WBC_class = _MinchinWeb_Lakes_;		///< Class used to check if the two points are within the same waterbody
	_WBC = null;					///< actual instance of class used to check if the points are within the same waterbody
	_max_cost = null;              ///< The maximum (pathfinder) cost for a route.
	_cost_tile = null;             ///< The (pathfinder) cost for a single tile.
	_cost_turn = null;             ///< The (pathfinder) cost that is added to _cost_tile if the direction changes.
	cost = null;                   ///< Used to change the (pathfinder) costs.

	_max_buoy_spacing = null;	   ///< The maximum spacing between buoys

//	_infinity = null;
	_first_run = null;
	_first_run2 = null;
	_waterbody_check = null;
	_points = null;					///< Used to store points considered by the pathfinder. Stored as TileIndexes
	_paths = null;					///< Used to store the paths the pathfinder is working with. Stored as indexes to _points
	_clearedpaths = null;			///< Used to store paths that have already been cleared (i.e. all water).
	_UnfinishedPaths = null;		///< Used to sort in-progress paths
	_FinishedPaths = null;			///< Used to store finished paths
	_testedpaths = null;
	_my_path = null;				///< Used to store the path after it's been found for Building functions
	_running = null;				///< Is the pathfinder running?
	info = null;

	constructor()
	{
		this._max_cost = 10000;
		this._cost_tile = 1;
		this._cost_turn = 1;
		this._max_buoy_spacing = 50;

//		this._infinity = _MinchinWeb_C_Infinity();
//		this._infinity = 10;	//	For Testing
		this._points = [];
		this._paths = [];
		this._clearedpaths = [];
		this._testedpaths = [];
		this._UnfinishedPaths = this._heap_class();
		this._FinishedPaths = this._heap_class();
		this._WBC = this._WBC_class();

		this._my_path = null;
		this._running = false;

		this.cost = this.Cost(this);
		this.info = this.Info(this);
	}

	/**	\publicsection
	 *	\brief	Initializes the pathfinder.
	 *	\param	source	Starting tile, as a TileID as the first element of an
	 *					array.
	 *	\param	goal	Ending tile, as a TileID as the first element of an
	 *					array.
	 *	\note	Assumes only one source and goal tile.
	 */
	function InitializePath(source, goal) {
		//	Assumes only one source and goal tile...
		this._points = [];
		this._paths = [];
		this._clearedpaths = [];
		this._UnfinishedPaths = this._heap_class();
		this._FinishedPaths = this._heap_class();
		this._my_path = null;
		this._first_run = true;
		this._first_run2 = true;
		this._running = true;

		this._points.push(source[0]);
		this._points.push(goal[0]);
		this._paths.push([0,1]);
		this._UnfinishedPaths.Insert(0, _MinchinWeb_ShipPathfinder_._PathLength(0));
	}

	/**	\brief	Runs the pathfinder.
	 *	\param	iterations		Number of cycles to run the pathfinder before
	 *							returning. If set to `-1`, will run until a path
	 *							is found.
	 *	\note	One of the first things the pathfinder will do is confirm the
	 *			start and end points are in the same waterbody. If `iterations`
	 *			is not set to `-1`, it will return after completing this.
	 *			Therefore, if `iterations` is set to a finite amount, this
	 *			function will need to be called at least twice to return a path.
	 *	\return	`null` if a path cannot be found.
	 *	\return	the path, if a path is found.
	 *	\return	`false` if the pathfinder is unfinished.
	 */
	function FindPath(iterations);

	/**	\brief	Find land!
	 *
	 *	Starting one two water tiles, this function will walk the line between
	 *	them, starting at the outside ends, and return the tiles where it hits
	 *	land.
	 *	\param	TileA	A water tile
	 *	\param	TileB	Another water tile
	 *	\return	A two element, one dimensional array of the tile indexes of the
	 *			first land tiles hit after starting at TileA and TileB.
	 *	\return	`[-1, -1]` if the path is all water (no land).
	 *	\static
	 */
	function LandHo(TileA, TileB);

	/**	\brief	To the sea! (Find water)
	 *
	 *	Starts at a given tile and then walks out at the given slope until it
	 *	hits water.
	 *	\param	StartTile	A land tile.
	 *	\param	Slope		The slope of the line to follow out.
	 *	\param	ThirdQuadrant	Whether to follow the slope in the third or
	 *							fourth quadrant.
	 *	\return	The first water tile hit.
	 *	\todo	Add image showing the Cartesian quadrants.
	 *	\todo	Move to \_MinchinWeb\_Marine\_
	 *
	 *	\static
	 */
	function WaterHo(StartTile, Slope, ThirdQuadrant = false);

	/**	\brief	Runs over the path to determine its length.
	 *	\return	Path length in tiles
	 */
	function GetPathLength();

	/**	\brief	Returns the number of potential buoys that may need to be built.
	 */
	function CountPathBuoys();

	/**	\brief	Build the buoys along the path.
	 *
	 *	Build the buoys that may need to be built.
	 *	Changes `this._my_path` to be the list of these buoys.
	 */
	function BuildPathBuoys();

	/**	\brief	Get the current path.
	 *	\return	The path, as currently held by the pathfinder.
	 */
	function GetPath();

	/**	\brief	Skip Waterbody Check
	 *
	 *	This function skips the Waterbody Check at the beginning of the Ship
	 *	Pathfinder run. This is intended for if you have already run Waterbody
	 *	Check or otherwise know that the two points are in the same waterbody.
	 *	\warning	The Ship Pathfinder's behaviour without this check in place
	 *				is not tested, as the Ship Pathfinder assumes the two points
	 *				are in the same waterbody.... Use at your own risk.
	 *	\note		This is less of an issue with the introduction of Lakes.
	 *				While Lakes may take a long time on the first run,
	 *				by reusing the pathfinder, subsequent checks of the same
	 *				path are very fast (in the order of 4 ticks).
	 */
	function OverrideWBC();

	/**	\privatesection
	 *	\brief	Turns a path into an index to tiles.
	 *
	 *	Just the start, end, and turning points.
	 */
	function _PathToTilesArray(PathIndex);

	/**	\private
	 *	\brief	Inserts a point into the point list.
	 *
	 *	Does a check to insure that the same point does not show up twice at
	 *		different indexes.
	 *	\return	The index of the (added) point.
	 */
	function _InsertPoint(TileIndex);

	/**	\privatesection
	 */
	function _PathLength(PathIndex);
};

class _MinchinWeb_ShipPathfinder_.Info {
	_main = null;

	function GetVersion()       { return 5; }
//	function GetMinorVersion()	{ return 0; }
	function GetRevision()		{ return 140228; }
	function GetDate()          { return "2014-02-28"; }
	function GetName()          { return "Ship Pathfinder (Wm)"; }

	constructor(main)
	{
		this._main = main;
	}
};

class _MinchinWeb_ShipPathfinder_.Cost {
	_main = null;

	function _set(idx, val) {
		if (this._main._running) throw("You are not allowed to change parameters of a running pathfinder.");

		switch (idx) {
			case "max_cost":          this._main._max_cost = val; break;
			case "tile":              this._main._cost_tile = val; break;
			case "turn":              this._main._cost_turn = val; break;
			case "max_buoy_spacing":  this._main._max_buoy_spacing = val; break;
			default: throw("the index '" + idx + "' does not exist");
		}
		return val;
	}

	function _get(idx) {
		switch (idx) {
			case "max_cost":          return this._main._max_cost;
			case "tile":              return this._main._cost_tile;
			case "turn":              return this._main._cost_turn;
			case "max_buoy_spacing":  return this._main._max_buoy_spacing;
			default: throw("the index '" + idx + "' does not exist");
		}
	}

	constructor(main) {
		this._main = main;
	}
};

//	== Function definitions ================================================


function _MinchinWeb_ShipPathfinder_::FindPath(iterations) {
	//	Waterbody Check
	if (this._first_run == true) {
		_MinchinWeb_Log_.Note("Ship Pathfinder running WaterBody Check... (at tick " + AIController.GetTick() + ")", 6);
		if (this._first_run2 == true) {
			this._WBC.InitializePath([this._points[this._paths[0][0]]], [this._points[this._paths[0][1]]]);
			this._first_run2 = false;
		}
		local SameWaterBody = this._WBC.FindPath(iterations);
		if ((SameWaterBody == false) || (SameWaterBody == null)) {
			return SameWaterBody;
		} else {
			this._first_run = false;
		}
		if (iterations != -1) { return false; }
	}

	_MinchinWeb_Log_.Note("Starting Ship Pathfinder (at tick " + AIController.GetTick() + ")", 7);

	if (iterations == -1) { iterations = _MinchinWeb_C_.Infinity() }	//  = 10000; close enough to infinity but able to avoid infinite loops?

	for (local j = 0; j < iterations; j++) {
		_MinchinWeb_Log_.Note("UnfinishedPaths count " + this._UnfinishedPaths.Count() + " : " + j + " of " + iterations + " iterations.", 6);
		//	Pop the shortest path from the UnfinishedPath Heap
		local WorkingPath = this._UnfinishedPaths.Pop();	//	WorkingPath is the Index to the path in question
		_MinchinWeb_Log_.Note("     UnfinishedPath count after Pop... " + this._UnfinishedPaths.Count(), 7);
		_MinchinWeb_Log_.Note("     Path " + WorkingPath + " popped: " + _MinchinWeb_Array_.ToString1D(this._paths[WorkingPath]) + " l=" + _PathLength(WorkingPath), 6);
		local ReturnWP = false;
		//	Walk the path segment by segment until we hit land
		for (local i = 0; i < (this._paths[WorkingPath].len() - 1); i++) {
		//	End is around line 306...

			_MinchinWeb_Log_.Note("Contained in test... " + i + " : " + (this._paths[WorkingPath].len() - 2) + " : " + _MinchinWeb_Array_.ToString2D(this._clearedpaths) + " " + this._points[this._paths[WorkingPath][i]] + " " + this._points[this._paths[WorkingPath][i+1]] + " : " + _MinchinWeb_Array_.ContainedInPairs(this._clearedpaths, this._points[this._paths[WorkingPath][i]], this._points[this._paths[WorkingPath][i+1]]), 7);

			if (_MinchinWeb_Array_.ContainedInPairs(this._clearedpaths, this._points[this._paths[WorkingPath][i]], this._points[this._paths[WorkingPath][i+1]]) != true) {
				//	This means we haven't already cleared the path...
				local Land = LandHo(this._points[this._paths[WorkingPath][i]], this._points[this._paths[WorkingPath][i+1]]);
//				_MinchinWeb_Log_.Note("Land : " + _MinchinWeb_Array_.ToString1D(Land) + " : " + _MinchinWeb_Array_.ToStringTiles1D(Land), 7);
				_MinchinWeb_Log_.Note("Land : " + _MinchinWeb_Array_.ToString1D(Land), 7);
				if ((Land[0] == -1) && (Land[1] == -1)) {
					//	All water
					this._clearedpaths.push([this._points[this._paths[WorkingPath][i]], this._points[this._paths[WorkingPath][i+1]]]);
					ReturnWP = true;
				} else {
					ReturnWP = false;
					// We're going to test this path and don't want to endlessly
					//		be coming back to it
					this._testedpaths.push(this._paths[WorkingPath]);

					//	On hitting land, do the right angle split creating two copies
					//		of the path with a new midpoint
					local m = _MinchinWeb_Extras_.Perpendicular(_MinchinWeb_Extras_.Slope(this._points[this._paths[WorkingPath][i]], this._points[this._paths[WorkingPath][i+1]]));
					local MidPoint = _MinchinWeb_Extras_.MidPoint(Land[0], Land[1]);
					//	Check if Midpoint is on Water. If it is, add it and skip the right angle split
					//	Midpoint should only be added if it's in the same Waterbody as the start and finish...
					//	WBCOnMidPoint will only be true iff the point is a water tile
					this._WBC.InitializePath([MidPoint], [this._points[0]]);
					local WBCOnMidPoint = this._WBC.FindPath(-1);
					if ((WBCOnMidPoint == true) && ((Land[0] == -1) || (Land[1] == -1))) {
						local WPPoints = this._paths[WorkingPath];
						local NewPointZIndex = _InsertPoint(MidPoint);
						_MinchinWeb_Log_.Sign(MidPoint, NewPointZIndex + "", 7);
						local WPPointsZ = _MinchinWeb_Array_.InsertValueAt(WPPoints, i+1, NewPointZIndex);
						this._paths[WorkingPath] = WPPointsZ;
						this._UnfinishedPaths.Insert(WorkingPath, _PathLength(WorkingPath));
						_MinchinWeb_Log_.Note("          Midpoint on Water...", 7);
						_MinchinWeb_Log_.Note("     Inserting Path #" + WorkingPath + " : " +  _MinchinWeb_Array_.ToString1D(this._paths[WorkingPath]) + " l=" + _PathLength(WorkingPath), 6);
					} else {
						local NewPoint1 = WaterHo(MidPoint, m, false);
						local NewPoint2 = WaterHo(MidPoint, m, true);
						local WPPoints = this._paths[WorkingPath];
						if (NewPoint1 != null) {
							//	only add the point if it's in the same waterbody
							this._WBC.InitializePath([NewPoint1], [this._points[0]]);
							local WBCOnPoint1 = this._WBC.FindPath(-1);
							if (WBCOnPoint1 == true) {
								local NewPoint1Index = _InsertPoint(NewPoint1);
								_MinchinWeb_Log_.Sign(NewPoint1, NewPoint1Index + "", 7);
								local WPPoints1 = _MinchinWeb_Array_.InsertValueAt(WPPoints, i+1, NewPoint1Index);

								//	With the new point, check both forward and back to see if the
								//		points both before and after the new midpoint to see if
								//		they can be removed from the path (iff the resulting
								//		segment would be only on the water)
								if ( ((i+3) < WPPoints1.len()) && (LandHo(this._points[WPPoints1[i+1]], this._points[WPPoints1[i+3]])[0] == -1) ) {
									WPPoints1 = _MinchinWeb_Array_.RemoveValueAt(WPPoints1, i+2);
								}
								//	With the new point, check we're not putting the point in
								//		twice in a row...
								if ( ((i+2) < WPPoints1.len()) && (WPPoints1[i+1] == WPPoints1[i+2]) ) {
									WPPoints1 = _MinchinWeb_Array_.RemoveValueAt(WPPoints1, i+1);
									_MinchinWeb_Log_.Note("          Point Removed! " + WPPoints1[i+1] + " i=" + i, 6);
								} else {
									_MinchinWeb_Log_.Note("          Point Kept " + WPPoints1[i+1] + " " + WPPoints1[i+2] +  " i=" + i, 6);
								}
								if ( ((i-1) > 0) && (LandHo(this._points[WPPoints1[i-1]], this._points[WPPoints1[i+1]])[0] == -1)) {
									WPPoints1 = _MinchinWeb_Array_.RemoveValueAt(WPPoints1, i);
									i--;	//	For double point check
								}
								if ( (i > 0) && (WPPoints1[i+1] == WPPoints1[i]) ) {
									WPPoints1 = _MinchinWeb_Array_.RemoveValueAt(WPPoints1, i+1);
									_MinchinWeb_Log_.Note("          Point Removed! " + WPPoints1[i+1] + " i=" + i, 6);
								} else {
									_MinchinWeb_Log_.Note("          Point Kept " + WPPoints1[i] + " " + WPPoints1[i+1] +  " i=" + i, 6);
								}
								//	Put both paths back into the UnfinishedPath heap
								//		(assuming we haven't been down this path before...)
								if (_MinchinWeb_Array_.ContainedIn1DIn2D(this._testedpaths, WPPoints1) != true) {
									this._paths[WorkingPath] = WPPoints1;
									_MinchinWeb_Log_.Note("     Inserting Path #" + WorkingPath + " : " +  _MinchinWeb_Array_.ToString1D(this._paths[WorkingPath]) + " l=" + _PathLength(WorkingPath), 6);
									this._UnfinishedPaths.Insert(WorkingPath, _PathLength(WorkingPath));
								}
							}
						}
						if (NewPoint2 != null) {
							//	only add the point if it's in the same waterbody
							this._WBC.InitializePath([NewPoint2], [this._points[0]]);
							local WBCOnPoint2 = this._WBC.FindPath(-1);
							if (WBCOnPoint2 == true) {
								local NewPoint2Index = _InsertPoint(NewPoint2);
								_MinchinWeb_Log_.Sign(NewPoint2, NewPoint2Index + "", 7);
								local WPPoints2 = _MinchinWeb_Array_.InsertValueAt(WPPoints, i+1, NewPoint2Index);

								if ( ((i+3) < WPPoints2.len()) && (LandHo(this._points[WPPoints2[i+1]], this._points[WPPoints2[i+3]])[0] == -1) ) {
									WPPoints2 = _MinchinWeb_Array_.RemoveValueAt(WPPoints2, i+2);
								}
								if ( ((i+2) < WPPoints2.len()) && (WPPoints2[i+1] == WPPoints2[i+2]) ) {
									WPPoints2 = _MinchinWeb_Array_.RemoveValueAt(WPPoints2, i+1);
									_MinchinWeb_Log_.Note("          Point Removed! " + WPPoints2[i+1] + " i=" + i, 6);
								} else {
									_MinchinWeb_Log_.Note("          Point Kept " + WPPoints2[i+1] + " " + WPPoints2[i+2] +  " i=" + i, 6);
								}
								if ( ((i-1) > 0) && (LandHo(this._points[WPPoints2[i-1]], this._points[WPPoints2[i+1]])[0] == -1)) {
									WPPoints2 = _MinchinWeb_Array_.RemoveValueAt(WPPoints2, i);
									i--;
								}
								if ( (i > 0) && (WPPoints2[i+1] == WPPoints2[i]) ) {
									WPPoints2 = _MinchinWeb_Array_.RemoveValueAt(WPPoints2, i+1);
									_MinchinWeb_Log_.Note("          Point Removed! " + WPPoints2[i+1] + " i=" + i, 6);
								} else {
									_MinchinWeb_Log_.Note("          Point Kept " + WPPoints2[i] + " " + WPPoints2[i+1] +  " i=" + i, 6);
								}
								//	Put the paths into the UnfinishedPath heap
								//		(assuming we haven't been down this path before...)
								if (_MinchinWeb_Array_.ContainedIn1DIn2D(this._testedpaths, WPPoints2) != true) {
									this._paths.push(WPPoints2);
									_MinchinWeb_Log_.Note("     Inserting Path #" + (this._paths.len() - 1) + " : " +  _MinchinWeb_Array_.ToString1D(WPPoints2) + " l=" + _PathLength(this._paths.len() - 1), 5);
									this._UnfinishedPaths.Insert(this._paths.len() - 1, _PathLength(this._paths.len() - 1));
								}
							}
						}
					}	// End  of if MidPoint is on Water
					i = this._paths[WorkingPath].len();	//	Exits us from the for... loop
				}
//				i = this._paths[WorkingPath].len();	//	Exits us from the for... loop
			} else if (i == (this._paths[WorkingPath].len() - 2)){
			//	If we don't hit land, add the path to the FinishedPaths heap
				_MinchinWeb_Log_.Note("Inserting Finished Path " + WorkingPath + " l=" + _PathLength(WorkingPath), 5);
				this._FinishedPaths.Insert(WorkingPath, _PathLength(WorkingPath));
			}
		}		// END  for (local i = 0; i < (this._paths[WorkingPath].len() - 1); i++)  i.e. stepping through path

		if (ReturnWP == true) {
			//	If everything was water...
			_MinchinWeb_Log_.Note("     Inserting Path #" + WorkingPath + " (all water) on ReturnWP; l=" + _PathLength(WorkingPath), 5);
			this._UnfinishedPaths.Insert(WorkingPath, _PathLength(WorkingPath));
		}

		if (this._UnfinishedPaths.Count() == 0) {
			_MinchinWeb_Log_.Note("Unfinsihed count: " + this._UnfinishedPaths.Count() + " finished: " + this._FinishedPaths.Count(), 6);
			if (this._FinishedPaths.Count() !=0) {
				this._running = false;
				this._my_path = _PathToTilesArray(this._FinishedPaths.Peek());
				_MinchinWeb_Log_.Note("My Path is " + _MinchinWeb_Array_.ToString1D(this._my_path), 5);
				return this._my_path;
			} else {
				//	If the UnfinishedPath heap is empty, fail the pathfinder
				this._running = false;
				return null;
			}
		} else {
			if (this._FinishedPaths.Count() !=0) {
				//	If the Finished heap contains a path that is shorter than
				//		any of the unfinished paths, return the finished path

				//	Actually, if the shortest finished path is within 10% of
				//		shortest unfinished path, call it good enough!!
				local finished = this._PathLength(this._FinishedPaths.Peek());
				local unfinished = this._PathLength(this._UnfinishedPaths.Peek());
				if ((finished * 100) < (unfinished * 110)) {
					this._running = false;
					this._my_path = _PathToTilesArray(this._FinishedPaths.Peek());
					_MinchinWeb_Log_.Note("My Path is " + _MinchinWeb_Array_.ToString1D(this._my_path), 5);
					return this._my_path;
				}
				_MinchinWeb_Log_.Note("          Finished =" + finished + " ; Unfinsihed = " + unfinished, 5);
			}
		}
	}
	return false;
}

function _MinchinWeb_ShipPathfinder_::_PathLength(PathIndex)
{
	local Length = 0.0;
	for (local i = 0; i < (this._paths[PathIndex].len() - 1); i++) {
		Length += _MinchinWeb_Marine_.DistanceShip(this._points[this._paths[PathIndex][i]], this._points[this._paths[PathIndex][i + 1]]);
	}
	return Length;
}

/* static */ function _MinchinWeb_ShipPathfinder_::LandHo(TileA, TileB) {
	_MinchinWeb_Log_.Note("Running LandHo... (" +  _MinchinWeb_Array_.ToStringTiles1D([TileA, TileB]) + ").", 7);
	local LandA = 0;
	local LandB = 0;

	local Walker = _MinchinWeb_LW_();
	Walker.Start(TileA);
	Walker.End(TileB);
	local PreviousTile = Walker.GetStart();
	local CurrentTile = Walker.Walk();
	while (!Walker.IsEnd() && (LandA == 0)) {
		if (AIMarine.AreWaterTilesConnected(PreviousTile, CurrentTile) != true) {
			LandA = PreviousTile
		}
		PreviousTile = CurrentTile;
		CurrentTile = Walker.Walk();
	}
	if (Walker.IsEnd()) {
	//	We're all water!
		return [-1,-1];
	}

	Walker.Reset();
	Walker.Start(TileB);
	Walker.End(TileA);
	PreviousTile = Walker.GetStart();
	CurrentTile = Walker.Walk();

	while (!Walker.IsEnd() && (LandB == 0)) {
		if (AIMarine.AreWaterTilesConnected(PreviousTile, CurrentTile) != true) {
			LandB = PreviousTile
		}
		PreviousTile = CurrentTile;
		CurrentTile = Walker.Walk();
	}
	if (Walker.IsEnd()) {
		//	We're all water!
		return [-1,-1];
	}

	return [LandA, LandB];
}

/* static */ function _MinchinWeb_ShipPathfinder_::WaterHo(StartTile, Slope, ThirdQuadrant = false) {
	//	Starts at a given tile and then walks out at the given slope until it
	//		hits water
	local Walker = _MinchinWeb_LW_();
	Walker.Start(StartTile);
	Walker.Slope(Slope, ThirdQuadrant);
	_MinchinWeb_Log_.Note("    WaterHo! " + StartTile + " , m=" + Slope  + " 3rdQ " + ThirdQuadrant, 7);
	local PreviousTile = Walker.GetStart();
	local CurrentTile = Walker.Walk();
	while ((AIMarine.AreWaterTilesConnected(PreviousTile, CurrentTile) != true) && (AIMap.DistanceManhattan(PreviousTile, CurrentTile) == 1)) {
		PreviousTile = CurrentTile;
		CurrentTile = Walker.Walk();
	}

	if (AIMarine.AreWaterTilesConnected(PreviousTile, CurrentTile) == true) {
		_MinchinWeb_Log_.Note("     WaterHo returning " + _MinchinWeb_Array_.ToStringTiles1D([CurrentTile]), 7);
		return CurrentTile;
	} else {
		return null;
	}
}

function _MinchinWeb_ShipPathfinder_::_PathToTilesArray(PathIndex) {
	//	turns a path into an index to tiles (just the start, end, and turning points)
	local Tiles = [];
	for (local i = 0; i < (this._paths[PathIndex].len()); i++) {
			Tiles.push(this._points[this._paths[PathIndex][i]]);
	}
	_MinchinWeb_Log_.Note("PathToTilesArray input " + _MinchinWeb_Array_.ToString1D(this._paths[PathIndex]), 7);
	_MinchinWeb_Log_.Note("     and output " + _MinchinWeb_Array_.ToString1D(Tiles), 7);
	return Tiles;
}

function _MinchinWeb_ShipPathfinder_::GetPathLength() {
	//	Runs over the path to determine its length
	if (this._running) {
		AILog.Warning("You can't get the path length while there's a running pathfinder.");
		return false;
	}
	if (this._my_path == null) {
		AILog.Warning("You have tried to get the length of a 'null' path.");
		return false;
	}

	local Length = 0;
	for (local i = 0; i < (this._my_path.len() - 1); i++) {
		Length += _MinchinWeb_Marine_.DistanceShip(this._my_path[i], this._my_path[i + 1]);
	}

	return Length;
}

function _MinchinWeb_ShipPathfinder_::_InsertPoint(TileIndex) {
	//	Inserts a point into point list. Does a check to insure that the same
	//		point does not show up twice at different indexes.
	//	Returns the index of the point
	local Index =  _MinchinWeb_Array_.Find1D(this._points, TileIndex);
	if (Index == false) {
		this._points.push(TileIndex);
		return (this._points.len() - 1);
	} else {
		return Index;
	}
}

function _MinchinWeb_ShipPathfinder_::CountPathBuoys() {
	//	returns the number of potential buoys that may need to be built

	_MinchinWeb_Log_.Note("My Path is " + _MinchinWeb_Array_.ToString1D(this._my_path), 7);

	if (this._my_path == null) {
		AILog.Warning("MinchinWeb.ShipPathfinder.CountBuoys() must be supplied with a valid path.");
	} else {
		//	basic direction changes (minus the two ends)
		local Buoys = this._my_path.len() - 2;

		//	test for long segments
		for (local i = 1; i < this._my_path.len(); i++) {
			local TestLength = _MinchinWeb_Marine_.DistanceShip(this._my_path[i-1], this._my_path[i]);
			while (TestLength > this._max_buoy_spacing) {
				TestLength -= this._max_buoy_spacing;
				Buoys ++;
			}
		}

		return Buoys;
	}
}

function _MinchinWeb_ShipPathfinder_::BuildPathBuoys() {
	//	Build the buoys that may need to be built
	//	changes  this._my_path  to be the list of these buoys

	if (this._my_path == null) {
		AILog.Warning("MinchinWeb.ShipPathfinder.BuildBuoys() must be supplied with a valid path.");
	} else {
		for (local i = 0; i < this._my_path.len(); i++) {
			//	skip first and last points
			if ((i != 0) && (i != (this._my_path.len() - 1))) {
				//	Build a buoy at each junction, and update the path if an existing buoy is used
				_MinchinWeb_Log_.Note("Build Buoy " + i + " :" + _MinchinWeb_Array_.ToStringTiles1D([this._my_path[i]]), 5);
				this._my_path[i] = _MinchinWeb_Marine_.BuildBuoy(this._my_path[i]);
			}
		}

		// Build extra buoys for long stretches
		for (local i = 1; i < this._my_path.len(); i++) {
			if (_MinchinWeb_Marine_.DistanceShip(this._my_path[i-1], this._my_path[i]) > this._max_buoy_spacing ) {
				local midpoint = _MinchinWeb_Extras_.MidPoint(this._my_path[i-1], this._my_path[i]);
				_MinchinWeb_Marine_.BuildBuoy(midpoint);
				this._my_path = _MinchinWeb_Array_.InsertValueAt(this._my_path, i, midpoint);
				_MinchinWeb_Log_.Note("Build Buoy " + i + " : new dist=" + _MinchinWeb_Marine_.DistanceShip(this._my_path[i-1], this._my_path[i]) + " : at" + _MinchinWeb_Array_.ToStringTiles1D([this._my_path[i]]), 7);
				i--;	//	rescan the section...
			}
		}

		return this._my_path;
	}
}

function _MinchinWeb_ShipPathfinder_::GetPath() {
	//	Returns the path, as currently held by the pathfinder

	if (this._my_path == null) {
		AILog.Warning("MinchinWeb.ShipPathfinder.BuildBuoys() must be supplied with a valid path.");
	} else {
		return this._my_path;
	}
}

function _MinchinWeb_ShipPathfinder_::OverrideWBC()	{
	//	This function skips the Waterbody Check at the beginning of the Ship
	//		Pathfinder run
	//	This is intended for if you have already run Waterbody Check or
	//		otherwise know that the two points are in the same waterbody.
	//	Be warned that Ship Pathfinder's behaviour without this check in place
	//		is not tested, as the Ship Pathfinder assumes the two points are
	//		in the same waterbody...

	this._first_run == false;
	_MinchinWeb_Log_.Note("WaterBody Check has been overridden", 6);
}
// EOF
