/*	Station functions v.3 r.253 [2011-07-01],
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
// EOF
