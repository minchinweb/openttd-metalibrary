/*	Station functions v.6 [2013-01-22],
 *		split from Extra functions v.5 r.253 [2011-07-01],
 *		part of Minchinweb's MetaLibrary v.7,
 *	Copyright © 2011-13 by W. Minchin. For more info,
 *		please visit https://github.com/MinchinWeb/openttd-metalibrary
 *
 *	Permission is granted to you to use, copy, modify, merge, publish, 
 *	distribute, sublincense, and/or sell this software, and provide these 
 *	rights to others, provided:
 *
 *	+ The above copyright notice and this permission notice shall be included
 *		in all copies or substantial portions of the software.
 *	+ Attribution is provided in the normal place for recognition of 3rd party
 *		contributions.
 *	+ You accept that this software is provided to you "as is", without warranty.
 */
 
/*	These are 'random' functions that didn't seem to fit well elsewhere.
 *
 *	Functions provided:
 *		MinchinWeb.Station.IsCargoAccepted(StationID, CargoID)
 *								- Checks whether a certain Station accepts a given cargo
 *								- Returns null if the StationID or CargoID are invalid
 *								- Returns true or false, depending on if the cargo is accepted
 *						  .IsNextToDock(TileID)
 *								- Checks whether a given tile is next to a dock. Returns true if
 *									this is the case
 *						  .DistanceFromStation(VehicleID, StationID)
 *								- Returns the distance between a given vehicle and a given station
 *								- Designed to be useable as a Valuator on a list of vehicles
 */

// =============  STATION class  =============
class _MinchinWeb_Station_ {
	main = null;
}

function _MinchinWeb_Station_::IsCargoAccepted(StationID, CargoID)
{
//	Checks whether a certain Station accepts a given cargo
//	Returns null if the StationID or CargoID are invalid
//	Returns true or false, depending on if the cargo is accepted

	if (!AIStation.IsValidStation(StationID) || !AICargo.IsValidCargo(CargoID)) {
		AILog.Warning("MinchinWeb.Station.IsCargoAccepted() was provided with invalid input. Was provided " + StationID + " and " + CargoID + ".");
		return null;
	} else {
		local AllCargos = AICargoList_StationAccepting(StationID);
		_MinchinWeb_Log_.Note("MinchinWeb.Station.IsCargoAccepted() was provided with " + StationID + " and " + CargoID + ". AllCargos: " + AllCargos.Count(), 6);
		if (AllCargos.HasItem(CargoID)) {
			return true;
		} else {
			return false;
		}
	}
}

function _MinchinWeb_Station_::IsNextToDock(TileID)
{
//	Checks whether a given tile is next to a dock. Returns true if this is the case
	
	local offsets = [0, AIMap.GetTileIndex(0, 1), AIMap.GetTileIndex(0, -1),
						AIMap.GetTileIndex(1, 0), AIMap.GetTileIndex(-1, 0)];
				 
	foreach (offset in offsets) {
		if (AIMarine.IsDockTile(TileID + offset)) {
			return true;
		}
	}
	
	return false;
}

function _MinchinWeb_Station_::DistanceFromStation(VehicleID, StationID)
{
//	Returns the distance between a given vehicle and a given station
//	Designed to be useable as a Valuator on a list of vehicles

//	To-DO:  Add check that supplied VehicleID and StationID are valid

	local VehicleTile = AIVehicle.GetLocation(VehicleID);
	local StationTile = AIBaseStation.GetLocation(StationID);
	
	return AITile.GetDistanceManhattanToTile(VehicleTile, StationTile);
}

function _MinchinWeb_Station_::BuildStreetcarStation(Tile, Loop = true)
{
	//	first tries to build a streetcar station with a half-tile loop on each end
	//	if it works, actually build it
	//
	//	if Loop == true, build a loop connecting the two ends

	local TestMode = AITestMode();
	AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_TRAM);
	local FrontTile;
	local BackTile;
	local MyDirection;

	if (AIRoad.BuildDriveThroughRoadStation(Tile, SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.DIR_NE), AIRoad.ROADVEHTYPE_BUS, AIStation.STATION_NEW)) {
		MyDirection = SuperLib.Direction.DIR_NE;
	} else if (AIRoad.BuildDriveThroughRoadStation(Tile, SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.DIR_SE), AIRoad.ROADVEHTYPE_BUS, AIStation.STATION_NEW)) {
		MyDirection = SuperLib.Direction.DIR_SE;		
	} else {
		return false;
	}

	FrontTile = SuperLib.Direction.GetAdjacentTileInDirection(Tile, MyDirection);
	BackTile = SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.OppositeDir(MyDirection));

	local ExecMode = AIExecMode();
	if (AIRoad.BuildRoad(FrontTile, BackTile)) {
		//	we keep doing stuff
		
		// local Result = AIRoad.BuildRoad(FrontTile, BackTile);
		// Log.Note("Loop Result: " + Result, 7);
		switch (MyDirection) {
			case SuperLib.Direction.DIR_NE :
			case SuperLib.Direction.DIR_SE :
				AIRoad.BuildDriveThroughRoadStation(Tile, SuperLib.Direction.GetAdjacentTileInDirection(Tile, MyDirection), AIRoad.ROADVEHTYPE_BUS, AIStation.STATION_NEW);
				break;
			default:
				// didn't work, should never get here
		}
		
		if (Loop) {
			local Pathfinder = _MinchinWeb_RoadPathfinder_();
			Pathfinder.InitializePath([FrontTile], [BackTile], [Tile]);
			Pathfinder.PresetStreetcar();
			if (Pathfinder.FindPath(5000) != null) {
				SuperLib.Money.MakeSureToHaveAmount(Pathfinder.GetBuildCost());
				Pathfinder.BuildPath();
			} else {
				Log.Note("No loop path." + _MinchinWeb_Array_.ToStringTiles1D([Tile]), 7);
			}
		}

		return true;
	} else {
		// TO-DO: if road building fails on one direction, try the other
		Log.Note("Streetcar Stations:" + _MinchinWeb_Array_.ToStringTiles1D([Tile]) + " Our little road building failed... exiting", 7);
		return false;
	}
}