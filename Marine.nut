/*	Ship and Marine functions v.4 [2025-09-30],
 *		part of Minchinweb's MetaLibrary v.11,
 *		originally part of WmDOT v.10
 *	Copyright © 2011-12 by W. Minchin. For more info,
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

/**	\brief		Water and Ship related functions.
 *	\version	v.4 (2025-09-30)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.2
 *	\see		\_MinchinWeb\_ShipPathfinder\_
 */

/*
 *		MinchinWeb.Marine.DistanceShip(TileA, TileB)
 *							- Assuming open ocean, ship in OpenTTD will travel
 *								45° angle where possible, and then finish up the
 *								trip by going along a cardinal direction
 *					   .GetPossibleDockTiles(IndustryID)
 *							- Given an industry (by IndustryID), searches for
 *								possible tiles to build a dock and retruns the
 *								list as an array of TileIndexes
 *							- Tiles given should be checked to ensure that the
 *								desired cargo is still accepted
 *					   .GetDockFrontTiles(Tile)
 *							- Given a tile, returns an array of possible 'front'
 *								tiles that a ship could access the dock from
 *							- Can be either the land tile of a dock, or the
 *								water tile
 *							- Does not test if there is currently a dock at the
 *								tile
 *							- Might do funny things if the tile given is next to
 *								a river (i.e. a flat tile next to a water tile)
 *					   .BuildBuoy(Tile)
 *							- Attempts to build a buoy, but first checks the box
 *								within MinchinWeb.Constants.BuoyOffset() for an
 *								existing buoy, and makes sure there's nothing
 *								but water between the two. If no existing buoy
 *								is found, one is built.
 *							- Returns the location of the existing or built buoy.
 *							- This will fail if the Tile given is a dock (or
 *								any tile that is not a water tile)
 *						.BuildDepot(DockTile, Front)
 *							- Attempts to build a (water) depot, but first checks
 *								the box within Constants.WaterDepotOffset() for
 *								an existing depot, and makes sure there's nothing
 *								but water between the depot and dock. If no
 *								existing depot is found, one is built.
 *							- Returns the location of the existing or built depot.
 *							- This will fail if the DockTile given is a dock (or
 *								any tile that is not a water tile)
 *						.RateShips(EngineID, Life, Cargo)
 *							- Note: Deprecated
 *							- Designed to run as a validator
 *							- Given the EngineID, it will score them; higher is better
 *							- Life is assumed to be in years
 *							- Note: Cargo doesn't work yet. Capacity is measured in
 *								the default cargo.
 *						.RateShips2(EngineID, Cargo, TargetCapacity, MaxSpend = 0)
 *							- Designed to run as a validator
 *							- higher scores are better
 *						.RateShips3(EngineID, Cargo, MonthlyProduction, Distance, MaxSpend = 0)
 *							- Designed to run as a validator
 *							- higher scores are better
 *						.NearestDepot(TileID)
 *							- Returns the tile of the Ship Depot nearest to the
 *								given TileID
 *
 *		See also MinchinWeb.ShipPathfinder
 */


class _MinchinWeb_Marine_ {
	main = null;

	/**	\publicsection
	 *	\brief	Distance, as measured by a ship.
	 *
	 *	Assuming open ocean, ship in OpenTTD will travel 45° angle where
	 *	possible, and then finish up the trip by going along a cardinal
	 *	direction.
	 *	\static
	 */
	function DistanceShip(TileA, TileB);

	/**	\brief	Tiles where a dock can be built near an industry.
	 *
	 *	Given an industry (by IndustryID), searches for possible tiles to build
	 *	a dock and returns the list as an array of TileIndexs.
	 *	\note	Tiles returned should be checked to ensure that the desired
	 *			cargo is still accepted.
	 *	\note	Assumes that the industry location returned is the NE corner of
	 *			the industry, and that industries fit within a 4x4 block.
	 *	\param	IndustryID	The IndustryID you wanted checked.
	 *	\return	An array of tiles that a dock could be built on near the
	 *			industry.
	 *	\return	If the industry has a built-in dock, that tile will be included
	 *			in the tiles returned.
	 *	\static
	 */
	function GetPossibleDockTiles(IndustryID);

	/**	\brief	The tiles a ship can access a dock from.
	 *
	 *	Given a tile, returns an array of possible 'front' tiles that a ship
	 *	could access the dock from.
	 *	\param	Tile	Can be either the land tile of a dock, or the water
	 *					tile.
	 *	\note	Does not test if there is currently a dock at the tile.
	 *
	 *	\note	Might do funny things if the tile given is next to a river
	 *			(i.e. a flat tile next to a water tile).
	 *	\static
	 */
	function GetDockFrontTiles(Tile);

	/**	\brief	Builds a buoy.
	 *
	 *	Attempts to build a buoy, but first checks the box within
	 *	\_MinchinWeb\_C\_.BuoyOffset() for an existing buoy, and makes sure
	 *	there's nothing but water between the two. If no existing buoy is found,
	 *	one is built.
	 *	\return	The location of the existing or built buoy.
	 *	\static
	 */
	function BuildBuoy(Tile);

	/**	\brief	Build a (ship) depot next to a dock.
	 *
	 *	Attempts to build a (water) depot, but first checks the box within
	 *	\_MinchinWeb\_C\_.WaterDepotOffset() for an existing depot, and makes
	 *	sure there's nothing but water between the depot and dock. If no
	 *	existing depot is found, one is built.
	 *	\param	DockTile		Must be a water tile.
	 *	\param	NotNextToDock	When `True`, will keep the dock from being built
	 *							next to an existing dock.
	 *	\note	This will fail if the `DockTile` given is a dock (or any tile
	 *			that is not a water tile).
	 *	\return	The location of the existing or built depot.
	 *	\todo	Check documentation of parameters.
	 *	\static
	 */
	function BuildDepot(DockTile, Front, NotNextToDock=true);

	/**	\brief	Ship Scoring. Deprecated in favour of `RateShips2()`.
	 *
	 *	Given an EngineID, the function will score them; higher is better.
	 *	\param	Life	Desired lifespan of route, assumed to be in years.
	 *	\param	Cargo	Doesn't work yet. Capacity is measured in the default
	 *					cargo.
	 *	\note	Designed to run as a valuator on a AIList of EngineID's.
	 *	\todo	Implement ship capacity in given cargo.
	 *	\see	RateShips2()
	 *	\static
	 */
	function RateShips(EngineID, Life, Cargo);

	/**	\brief	Ship Scoring v2. Deprecated in favour of `RateShips3()`.
	 *
	 *	Given an EngineID, the function will score them; higher is better.
	 *  \param  Cargo   Cargo you want to carry. Ensure that the ship can
	 *					retrofit to the desired cargo.
	 *  \param  TargetCapacity  (Approximate) amount of cargo you want to
	 *							carry. Often the industry's monthly production.
	 *  \param  MaxSpend    Hard upper limit on (upfront) Engine cost. Set to
	 *						zero (the default) to ignore. Does not include
	 *						retrofit costs.
	 *	\note	Designed to run as a valuator on a AIList of EngineID's.
	 *	\note	Capacity is measured in the default cargo.
	 *  \note   Assumes this vehicle will be continuously replaced, rather than
	 *			over a pre-defined "lifetime".
	 *	\todo	Add example of validator code.
	 *	\todo	Implement ship capacity in given cargo.
	 *	\since	MetaLibrary v10.1
	 *	\see	\_MinchinWeb\_Engine\_.Rate2()
	 *	\see	RateShips3()
	 *	\static
	 */
	function RateShips2(EngineID, Cargo, TargetCapacity, MaxSpend = 0);

	/**	\brief	Ship Scoring v3.
	 *
	 *	Given an EngineID, the function will score them; higher is better.
	 *  \param  Cargo   Cargo you want to carry. Ensure that the ship can
	 *					retrofit to the desired cargo.
	 *  \param  MonthlyProduction  (Approximate) amount of cargo you want to
	 *							carry. Often the industry's monthly production.
	 *	\param	Distance	The distance (in map tiles) that the engine is
	 *						expected to travel between pickup and drop off.
	 *						Assumes that the return distance is the same.
	 *  \param  MaxSpend    Hard upper limit on (upfront) Engine cost. Set to
	 *						zero (the default) to ignore. Does not include
	 *						retrofit costs.
	 *	\note	Designed to run as a valuator on a AIList of EngineID's.
	 *	\note	Capacity is measured in the default cargo.
	 *  \note   Assumes this vehicle will be continuously replaced, rather than
	 *			over a pre-defined "lifetime".
	 *	\todo	Add example of validator code.
	 *	\todo	Implement ship capacity in given cargo.
	 *	\since	MetaLibrary v10.1
	 *	\see	\_MinchinWeb\_Engine\_.Rate3()
	 *	\static
	 */
	function RateShips3(EngineID, Cargo, MonthlyProduction, Distance, MaxSpend = 0);


	/**	\brief	Nearest ship depot.
	 *	\return	The tile of the Ship Depot nearest to the given TileID
	 *	\todo	Add check that depot is connected to the given TileID.
	 *	\todo	Check that there is a depot to return.
	 *	\static
	 */
	function NearestDepot(TileID);
};

//	== Function definitions ================================================

function _MinchinWeb_Marine_::DistanceShip(TileA, TileB) {
//	Assuming open ocean, ship in OpenTTD will travel 45° angle where possible,
//		and then finish up the trip by going along a cardinal direction
	return ((AIMap.DistanceManhattan(TileA, TileB) - AIMap.DistanceMax(TileA, TileB)) * 0.4 + AIMap.DistanceMax(TileA, TileB)).tointeger();
}

function _MinchinWeb_Marine_::GetPossibleDockTiles(IndustryID) {
//	Given an industry (by IndustryID), searches for possible tiles to build a
//		dock and returns the list as an array of TileIndexs

//	Tiles given should be checked to ensure that the desired cargo is still
//		accepted

//	Assumes that the industry location returned is the NE corner of the
//		industry, and that industries fit within a 4x4 block
	local Tiles = [];
	if (AIIndustry.IsValidIndustry(IndustryID) == true) {
		//	Check if the industry already has a dock
		if (AIIndustry.HasDock(IndustryID) == true) {
			return [AIIndustry.GetDockLocation(IndustryID)];
		} else {
			local ex = AITestMode();
			local Walker = _MinchinWeb_SW_();	//	Spiral Walker
			Walker.Start(AIIndustry.GetLocation(IndustryID));

			while (Walker.GetStage() <= ((_MinchinWeb_C_.IndustrySize() + AIStation.GetCoverageRadius(AIStation.STATION_DOCK)) * 4)) {
				if (AIMarine.BuildDock(Walker.Walk(), AIStation.STATION_NEW) == true) {
					Tiles.push(Walker.GetTile());
				}
			}
		}
		_MinchinWeb_Log_.Note("MinchinWeb.Marine.GetPossibleDockTiles()  " + _MinchinWeb_Array_.ToStringTiles1D(Tiles, true), 6);
		return Tiles;
	} else {
		AILog.Warning("MinchinWeb.Marine.GetPossibleDockTiles() was supplied with an invalid IndustryID. Was supplied " + IndustryID + ".");
		return Tiles;
	}
}

function _MinchinWeb_Marine_::GetDockFrontTiles(Tile) {
//	Given a tile, returns an array of possible 'front' tiles that a ship could
//		access the dock from
//	Can be either the land tile of a dock, or the water tile
//	Does not test if there is currently a dock at the tile

//	Tiles under Oil Rigs do NOT return  AITile.IsWaterTile(Tile) == true

//	Might do funny things if the tile given is next to a river (i.e. a flat tile
//		next to a water tile)

	local ReturnTiles = [];
	local offset = AIMap.GetTileIndex(0, 0);;
	local DockEnd = null;
	local offsets = [AIMap.GetTileIndex(0, 1), AIMap.GetTileIndex(0, -1),
					 AIMap.GetTileIndex(1, 0), AIMap.GetTileIndex(-1, 0)];
	local next_tile;

	if (AIMap.IsValidTile(Tile)) {
		if (AITile.IsWaterTile(Tile)) {
			// water tile
			DockEnd = Tile;
		} else {
			//	land tile
			switch (AITile.GetSlope(Tile)) {
			//	see  http://vcs.openttd.org/svn/browser/trunk/docs/tileh.png
			//		for slopes
				case 0:
					// flat
					offset = AIMap.GetTileIndex(0, 0);
					break;
				case 3:
					offset = AIMap.GetTileIndex(-1, 0);
					break;
				case 6:
					offset = AIMap.GetTileIndex(0, -1);
					break;
				case 9:
					offset = AIMap.GetTileIndex(0, 1);
					break;
				case 12:
					offset = AIMap.GetTileIndex(1, 0);
					break;
			}

			DockEnd = Tile + offset;
		}

		if (DockEnd != null) {
			/* Check all tiles adjacent to the current tile. */
			foreach (offset in offsets) {
				next_tile = DockEnd + offset;
				if (AITile.IsWaterTile(next_tile)) {
					ReturnTiles.push(next_tile);
				}
			}
		}
	} else {
		AILog.Warning("MinchinWeb.Marine.GetDockFrontTiles() was supplied with an invalid TileIndex. Was supplied " + Tile + ".");
	}

	return ReturnTiles;
}

function _MinchinWeb_Marine_::BuildBuoy(Tile) {
	//	Attempts to build a buoy, but first checks the box within
	//		MinchinWeb.Constants.BuoyOffset() for an existing buoy, and makes sure
	//		there's nothing but water between the two. If no existing buoy is found,
	//		one is built.

	//	Returns the location of the existing or built buoy.

	local Existing = AITileList();
	local UseExistingAt = null;

	local Walker = _MinchinWeb_SW_();	//	Spiral Walker
	Walker.Start(Tile);

	while (Walker.GetStage() <= (_MinchinWeb_C_.BuoyOffset() * 4)) {
		if (AIMarine.IsBuoyTile(Walker.Walk())) {
			Existing.AddItem(Walker.GetTile(), AIMap.DistanceManhattan(Tile, Walker.GetTile()));
			_MinchinWeb_Log_.Note("BuildBuoy() : Insert Existing at" + _MinchinWeb_Array_.ToStringTiles1D([Walker.GetTile()]), 7);
		}
	}

	if (Existing.Count() > 0) {
		Existing.Sort(AIList.SORT_BY_VALUE, AIList.SORT_ASCENDING);
		local TestBuoy = Existing.Begin();
		local KeepTrying = true;
		local WBC = _MinchinWeb_WBC_();
		while (KeepTrying == true) {
			WBC.InitializePath([TestBuoy], [Tile]);
			WBC.PresetSafety(TestBuoy, Tile);
			local WBCResults = WBC.FindPath(-1);
			if (WBCResults != null) {
				UseExistingAt = TestBuoy;
				KeepTrying = false;
			} else {
				if (Existing.IsEnd()) {
					KeepTrying = false;
					UseExistingAt = null;
				} else {
					TestBuoy = Existing.Next();
				}
			}
		}
	}

	if (UseExistingAt == null) {
		AIMarine.BuildBuoy(Tile);
		return Tile;
	} else {
		return UseExistingAt;
	}
}

function _MinchinWeb_Marine_::BuildDepot(DockTile, Front, NotNextToDock=true) {
	//	Attempts to build a (water) depot, but first checks the box within
	//		MinchinWeb.Constants.WaterDepotOffset() for an existing depot, and makes
	//		sure there's nothing but water between the depot and dock. If no
	//		existing depot is found, one is built.

	//	Returns the location of the existing or built depot.
	//	This will fail if the DockTile given is a dock (or any tile that is not a water tile)

	//	'NotNextToDock,' when set, will keep the dock from being built next to an
	//		existing dock

	local StartX = AIMap.GetTileX(DockTile) - _MinchinWeb_C_.WaterDepotOffset();
	local StartY = AIMap.GetTileY(DockTile) - _MinchinWeb_C_.WaterDepotOffset();
	local EndX = AIMap.GetTileX(DockTile) + _MinchinWeb_C_.WaterDepotOffset();
	local EndY = AIMap.GetTileY(DockTile) + _MinchinWeb_C_.WaterDepotOffset();

	local Existing = AITileList();
	local UseExistingAt = null;

	for (local i = StartX; i < EndX; i++) {
		for (local j = StartY; j < EndY; j++) {
			if (AIMarine.IsWaterDepotTile(AIMap.GetTileIndex(i,j))) {
				Existing.AddItem(AIMap.GetTileIndex(i,j), AIMap.DistanceManhattan(DockTile, AIMap.GetTileIndex(i,j)));
				_MinchinWeb_Log_.Note("BuildDepot() : Insert Existing at" + _MinchinWeb_Array_.ToStringTiles1D([AIMap.GetTileIndex(i,j)]), 6);
			}
		}
	}

	if (Existing.Count() > 0) {
		Existing.Sort(AIList.SORT_BY_VALUE, AIList.SORT_ASCENDING);
		local TestDepot = Existing.Begin();
		local KeepTrying = true;
		local WBC = _MinchinWeb_WBC_();
		while (KeepTrying == true) {
			WBC.InitializePath([TestDepot], [DockTile]);
			WBC.PresetSafety(TestDepot, DockTile);
			local WBCResults = WBC.FindPath(-1);
			if (WBCResults != null) {
				UseExistingAt = TestDepot;
				KeepTrying = false;
			} else {
				if (Existing.IsEnd()) {
					KeepTrying = false;
					UseExistingAt = null;
				} else {
					TestDepot = Existing.Next();
				}
			}
		}
	}

	if (UseExistingAt == null) {
		if(AIMarine.BuildWaterDepot(DockTile, Front)) {
			// try and build right at the given spot
			UseExistingAt = DockTile;
		} else {
			//	if that doesn't work, build it close by
			//	Generate a list of water tiles, and pick one at random
			Existing.Clear();
			for (local i = StartX; i < EndX; i++) {
				for (local j = StartY; j < EndY; j++) {
					if (AITile.IsWaterTile(AIMap.GetTileIndex(i,j)) && (_MinchinWeb_Station_.IsNextToDock(AIMap.GetTileIndex(i,j)) == false) ) {
						Existing.AddItem(AIMap.GetTileIndex(i,j), AIBase.Rand());
						_MinchinWeb_Log_.Note("BuildDepot() : Insert WaterTile at" + _MinchinWeb_Array_.ToStringTiles1D([AIMap.GetTileIndex(i,j)]), 7);
					}
				}
			}

			Existing.Sort(AIList.SORT_BY_VALUE, AIList.SORT_ASCENDING);
			local TestDepot = Existing.Begin();
			local KeepTrying = true;
			local WBC = _MinchinWeb_WBC_();
			while (KeepTrying == true) {
				WBC.InitializePath([TestDepot], [DockTile]);
				WBC.PresetSafety(TestDepot, DockTile);
				local WBCResults = WBC.FindPath(-1);
				_MinchinWeb_Log_.Note("BuildDepot() : WBC on" + _MinchinWeb_Array_.ToStringTiles1D([TestDepot, DockTile]) + " returned " + WBCResults, 7);
				if (WBCResults != null) {
					local Front2 = _MinchinWeb_Extras_.NextCardinalTile(TestDepot, DockTile);
					if (AIMarine.BuildWaterDepot(TestDepot, Front2))
					{
						UseExistingAt = TestDepot;
						KeepTrying = false;
					} else {
						if (Existing.IsEnd()) {
							KeepTrying = false;
							UseExistingAt = null;
						} else {
							TestDepot = Existing.Next();
						}
					}
				} else {
					if (Existing.IsEnd()) {
						KeepTrying = false;
						UseExistingAt = null;
					} else {
						TestDepot = Existing.Next();
					}
				}
			}

		}
	}

	return UseExistingAt;
}

function _MinchinWeb_Marine_::RateShips(EngineID, Life, Cargo) {
	//	Designed to Run as a validator
	//	Given the EngineID, it will score them; higher is better
	//	   Score = [(Capacity in Cargo) * Reliability * Speed] /
	//                      [ (Purchase Price over Life) + (Running Costs) * Life ]
	//
	//	Life is assumed to be in years
	//  Note: Cargo doesn't work yet. Capacity is measured in the default cargo.

	local Score = 0;
	local Age = AIEngine.GetMaxAge(EngineID);
	local BuyTimes = (Life / Age/366).tointeger() + 1;
		// GetMaxAge is given in days
	local Cost = (BuyTimes * AIEngine.GetPrice(EngineID)) + (Life * AIEngine.GetRunningCost(EngineID)) + 0.001;
	local Return = (AIEngine.GetCapacity(EngineID) * AIEngine.GetReliability(EngineID) * AIEngine.GetMaxSpeed(EngineID)) + 0.001;
	if (Return == 0) {
		Score = 0;
	} else {
		Score = (Return * 1000 / Cost).tointeger();
	}

	_MinchinWeb_Log_.Note("Rate Ship : " + Score + " : " + AIEngine.GetName(EngineID) + " : " + AIEngine.GetCapacity(EngineID) + " * " + AIEngine.GetReliability(EngineID) + " * " + AIEngine.GetMaxSpeed(EngineID) + " / " + BuyTimes + " * " + AIEngine.GetPrice(EngineID) + " + " + Life + " * " + AIEngine.GetRunningCost(EngineID), 7);
	return Score;
}

function _MinchinWeb_Marine_::RateShips2(EngineID, Cargo, TargetCapacity, MaxSpend = 0) {
	// only water vehicles (i.e. ships)
	if (AIEngine.GetVehicleType(EngineID) != AIVehicle.VT_WATER) {
		return 0;
	}

	return _MinchinWeb_Engine_.Rate2(EngineID, Cargo, TargetCapacity, MaxSpend);
}


function _MinchinWeb_Marine_::RateShips3(EngineID, Cargo, MonthlyProduction, TravelDistance, PayDistance = 0, MaxSpend = 0) {
	// only water vehicles (i.e. ships)
	if (AIEngine.GetVehicleType(EngineID) != AIVehicle.VT_WATER) {
		return 0;
	}

	return _MinchinWeb_Engine_.Rate3(EngineID, Cargo, MonthlyProduction, TravelDistance, PayDistance, MaxSpend);
}


function _MinchinWeb_Marine_::NearestDepot(TileID) {
//	Returns the tile of the Ship Depot nearest to the given TileID

//	To-Do:	Add check that depot is connected to tile
//	To-Do:	Check that there is a depot to return
	local AllDepots = AIDepotList(AITile.TRANSPORT_WATER);
	AllDepots.Valuate(AITile.GetDistanceManhattanToTile, TileID);
	AllDepots.Sort(AIList.SORT_BY_VALUE, AIList.SORT_ASCENDING);
	return AllDepots.Begin();
}
// EOF
