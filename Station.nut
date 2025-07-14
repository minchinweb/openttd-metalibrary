/*	Station functions v.3 r.253 [2011-07-21],
 *		part of Minchinweb's MetaLibrary v.6,
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

/*	Functions provided:
 *		MinchinWeb.Station.IsCargoAccepted(StationID, CargoID)
 *								- Checks whether a certain Station accepts a given cargo
 *								- Returns null if the StationID or CargoID are invalid
 *								- Returns true or false, depending on if the cargo is accepted
 *						  .IsNextToDock(TileID)
 *								- Checks whether a given tile is next to a dock. Returns true if
 *									this is the case
 *						  .DistanceFromStation(VehicleID, StationID)
 *								- Returns the distance between a given vehicle and a given station
 *								- Designed to be usable as a Valuator on a list of vehicles
 */

/**	\brief		Station
 *	\version	v.3 (2011-07-21)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.2
 *
 * These are functions relating to dealing with stations.
 */

class _MinchinWeb_Station_ {
	main = null;

	/**	\publicsection
	 *	\brief		Checks whether a certain Station accepts a given cargo
	 *	\param		StationID	ID of the station (as an integer)
	 *	\param		CargoID		ID of the cargo (as an integer)
	 *	\note		Can be used as a Valuator on a AIList of stations
	 *	\return		Returns `null` if the StationID or CargoID are invalid.
	 *				Returns true or false, depending on if the cargo is accepted
	 *	\todo		Add example of valuator code
	 *	\static
	 */
	function IsCargoAccepted(StationID, CargoID);

	/**	\brief	Checks whether a given tile is next to a dock.
	 *	\param	TileID	ID of the tile (as an integer)
	 *	\return	`True` if the tile is next to a dock, `False` otherwise.
	 *	\static
	 */
	function IsNextToDock(TileID);

	/** \brief	Returns the distance between a given vehicle and a given station.
	 *	\note	Designed to be usable as a Valuator on a AIList of vehicles
	 *	\param	VehicleID	ID of the vehicle (as an integer)
	 *	\param	StationID	ID of the station (as an integer)
	 *	\return	Manhattan Distance between the vehicle and the station.
	 *	\todo	Add check that supplied VehicleID and StationID are valid
	 *	\todo	Add example of valuator code
	 *	\static
	 */
	function DistanceFromStation(VehicleID, StationID);

	/** \brief Build a streetcar station
	 *
	 *  First tries to build a streetcar station with a half-tile loop on each
	 *	end; if that works, actually build it.
	 *
	 *  \param  Tile
	 *  \param  Loop    If `true`, build a loop connecting the two ends
	 *  \return `true` or `false` depending on if the building the station was
	 *			successful
	 */
	function BuildStreetcarStation(Tile, Loop = true);
};

//	== Function definitions ==================================================

function _MinchinWeb_Station_::IsCargoAccepted(StationID, CargoID) {
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

function _MinchinWeb_Station_::IsNextToDock(TileID) {
	local offsets = [0, AIMap.GetTileIndex(0, 1), AIMap.GetTileIndex(0, -1),
						AIMap.GetTileIndex(1, 0), AIMap.GetTileIndex(-1, 0)];

	foreach (offset in offsets) {
		if (AIMarine.IsDockTile(TileID + offset)) {
			return true;
		}
	}

	return false;
}

function _MinchinWeb_Station_::DistanceFromStation(VehicleID, StationID) {
	local VehicleTile = AIVehicle.GetLocation(VehicleID);
	local StationTile = AIBaseStation.GetLocation(StationID);

	return AITile.GetDistanceManhattanToTile(VehicleTile, StationTile);
}

function _MinchinWeb_Station_::BuildStreetcarStation(Tile, Loop = true) {
	local TestMode = AITestMode();
	AIRoad.SetCurrentRoadType(AIRoad.ROADTYPE_TRAM);
	local FrontTile;
	local BackTile;
	local MyDirection;

	// determine our road directions
	if (AIRoad.BuildDriveThroughRoadStation(
			Tile,
			SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.DIR_NE),
			AIRoad.ROADVEHTYPE_BUS,
			AIStation.STATION_NEW
		) && AIRoad.BuildRoad(
			SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.DIR_NE),
			SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.DIR_SW))
		) {
		MyDirection = SuperLib.Direction.DIR_NE;
	} else if (AIRoad.BuildDriveThroughRoadStation(
			Tile,
			SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.DIR_SE),
			AIRoad.ROADVEHTYPE_BUS,
			AIStation.STATION_NEW
		) && AIRoad.BuildRoad(
			SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.DIR_SE),
			SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.DIR_NW))
		) {
		MyDirection = SuperLib.Direction.DIR_SE;
	} else {
		return false;
	}

	// get the tiles in front and behind our proposed station
	FrontTile = SuperLib.Direction.GetAdjacentTileInDirection(Tile, MyDirection);
	BackTile = SuperLib.Direction.GetAdjacentTileInDirection(Tile, SuperLib.Direction.OppositeDir(MyDirection));

	local ExecMode = AIExecMode();
	if (AIRoad.BuildRoad(FrontTile, BackTile)) {
		//	we keep doing stuff
		AIRoad.BuildDriveThroughRoadStation(Tile, SuperLib.Direction.GetAdjacentTileInDirection(Tile, MyDirection), AIRoad.ROADVEHTYPE_BUS, AIStation.STATION_NEW);

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
		// TODO: if road building fails on one direction, try the other
		Log.Note("Streetcar Stations:" + _MinchinWeb_Array_.ToStringTiles1D([Tile]) + " Our little road building failed... exiting", 7);
		return false;
	}
}
// EOF
