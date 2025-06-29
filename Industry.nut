/*	Industry related functions v.1 r.206 [2012-01-12],
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

/**	\brief		Industries
 *	\version	v.1 (2012-01-12)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.2
 *
 * These are functions relating to dealing with OpenTTD industries.
 */

class _MinchinWeb_Industry_ {
	main = null;

	/**	\publicsection
	 *	\brief	Get the `IndustryID` of the industry at a given `TileID`.
	 *	\param	Tile	TileID to start the search from
	 *	\return	`IndustryID` of the industry at (or around) `TileID`.
	 *	\return	`Constants.InvalidIndustry()` if no valid industries can be
	 *			found.
	 *	\note	`AIIndustry.GetIndustryID( AIIndustry.GetLocation( IndustryID ) )`
	 *			sometimes fails because `GetLocation()` returns the northmost
	 *			tile of the industry which may be a dock, heliport, or not part
	 *			of the industry at all.
	 *	\note	This function starts at the northmost tile, and then searches a
	 *			square out (up to `Constants.StationSize()` ) until it finds a
	 *			tile with a valid `IndustryID`.
	 *	\static
	 */
	function GetIndustryID(Tile);
};

//	== Function definitions ================================================

function _MinchinWeb_Industry_::GetIndustryID(Tile) {
	local StartX = AIMap.GetTileX(Tile);
	local StartY = AIMap.GetTileY(Tile);
	local EndX = AIMap.GetTileX(Tile) + _MinchinWeb_C_.IndustrySize();
	local EndY = AIMap.GetTileY(Tile) + _MinchinWeb_C_.IndustrySize();

	for (local i = StartX; i < EndX; i++) {
		for (local j = StartY; j < EndY; j++) {
			if (AIIndustry.GetIndustryID(AIMap.GetTileIndex(i,j)) != _MinchinWeb_C_.InvalidIndustry()) {
				return AIIndustry.GetIndustryID(AIMap.GetTileIndex(i,j));
			}
		}
	}

	//	if no valid industry is found...
	return _MinchinWeb_C_.InvalidIndustry();
}
// EOF

