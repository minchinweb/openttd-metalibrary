/*	Constants for MetaLibrary v.1 r.206 [2012-01-12],
 *		part of Minchinweb's MetaLibrary v.6,
 *		originally part of MetaLibrary v.2
 *	Copyright © 2011-14, 2025 by W. Minchin. For more info,
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
 *		MinchinWeb.Constants.Infinity() - returns 10,000
 *							.FloatOffset() - returns 1/2000
 *							.Pi() - returns 3.1415...
 *							.e() - returns 2.7182...
 *							.IndustrySize() - returns 4
 *							.InvalidIndustry() - returns 0xFFFF (65535)
 *							.InvalidTile() - returns 0xFFFFFF
 *							.MaxStationSpread() - returns the maximum station spread
 *							.BuoyOffset() - returns 3
 *							.WaterDepotOffset() - return 4
 *
 */

/**	\class		_MinchinWeb_C_
 *	\brief		Constants
 *	\version	v.1
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.2
 *
 *	In general, these are constants used by other sub-libraries within
 *	MetaLibrary.
 */

class _MinchinWeb_C_ {
	//	These are constants called by the various sublibraries

	/**	\publicsection
	 *	\brief	A number close enough to infinity to work for our purposes here.
	 *	\return	10,000
	 *	\note	Slopes are capped at 10,000 and 1/10,000
	 *	\note	A tile that is a Manhattan Distance of 'infinity' tiles away
	 *          will always be outside of the defined map (valid up to
	 *          4,096x4,096 maps).
	 *	\static
	 */
	function Infinity() 	{ return 10000; }

	/**	\brief	Used to compare floating point numbers to determine if they are
	 *			"equal".
	 *
	 *			Two floating point numbers (i.e. numbers with decimal points)
	 *			are considered to be equal if they differ by less than this
	 *			value.
	 *	\note	Floating points, due to the imprecision is translating binary
	 *			numbers (as they are stored by the computer) to decimal numbers,
	 *			and then performing math with these imperfectly translated
	 *			numbers, can result in numbers than are otherwise equal, except
	 *			for very small remainders. This is an attempt to sidestep this
	 *			issue.
	 *	\return	0.000,5 (or 1/2,000)
	 *	\todo	Convert from an absolute number to a percentage.
	 *	\static
	 */
	function FloatOffset()	{ return 0.0005; }	//	= 1/2000

	/**	\brief	Pi (π = 3.14...) to 31 decimal places
	 *	\static
	 */
	function Pi() { return 3.1415926535897932384626433832795; }

	/**	\brief	Euler's number (*e* = 2.718...) to 31 decimal places
	 *	\static
	 */
	function e() { return 2.7182818284590452353602874713527; }

	/**	\brief	Industries are assumed to fit within a 4x4 box
	 *	\return	4
	 *	\static
	 */
	function IndustrySize() { return 4; }

	/**	\brief	Number returned by OpenTTD for an invalid industry (65535)
	 *	\return	0xFFFF
	 *	\static
	 */
	function InvalidIndustry() { return 0xFFFF; }

	/**	\brief	A number beyond the a valid TileIndex.
	 *
	 *	Valid (or invalid, if you prefer) for at least up to 2048x2048 maps.
	 *	\return	0xFFFFFF
	 *	\todo	Check that this is still valid on 4096x4096 maps.
	 *	\static
	 */
	function InvalidTile() { return 0xFFFFFF; }

	/**	\brief	This is the assumed minimum desired spacing between buoys.
	 *	\return 3
	 *	\static
	 */
	function BuoyOffset() { return 3; }

	/**	\brief	This is the maximum desired spacing between docks and depots.
	 *	\return	4
	 *	\static
	 */
	function WaterDepotOffset() { return 4; }

	/**	\brief	Returns the OpenTTD setting for maximum station spread
	 *	\static
	 */
	function MaxStationSpread();
};

//	== Function definitions =================================================

function _MinchinWeb_C_::MaxStationSpread() {
	if (AIGameSettings.IsValid("station_spread")) {
		return AIGameSettings.GetValue("station_spread");
	} else {
		try {
			AILog.Error("'station_spread' is no longer valid! (MinchinWeb.Constants.MaxStationSpread(), v." + this.GetVersion() + " r." + this.GetRevision() + ")");
			AILog.Error("Please report this problem to http://www.tt-forums.net/viewtopic.php?f=65&t=57903");
		} catch (idx) {
			// pass
		}
		return 16;
	}
}
// EOF
