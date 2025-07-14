/*	Extra functions v.7 [2025-07-14],
 *		part of Minchinweb's MetaLibrary v.10
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

// TO-DO:	Break this into Math, Geometry, and Extras

/*	These are 'random' functions that didn't seem to fit well elsewhere.
 *
 *	Comparison functions will return the first value if the two are equal
 */

/**	\brief		Extra functions
 *	\version	v.7 (2025-07-14)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.1
 *
 *	These are 'random' functions that didn't seem to fit well elsewhere.
 *	Many of them are math helper functions. Many others are helpful in dealing
 *	geometry.
 */

class _MinchinWeb_Extras_ {
	_infinity = null;	///< pointer to \_MinchinWeb\_C\_::Infinity()

	constructor() {
		this._infinity = _MinchinWeb_C_.Infinity();
	}

	/**	\publicsection
	 *	\brief	Get the location of a sign.
	 *	\param	text	message to search for
	 *	\return	TileID of the first instance where the sign matches the given
	 *			text.
	 *	\return	`null` if no matching sign can be found.
	 *	\static
	 */
	function SignLocation(text);

	/**	\brief	Find the tile halfway between two other tiles.
	 *	\param	TileA	one 'end' tile
	 *	\param	TileB	the other 'end' tile
	 *	\return	the `TileID` of the tile halfway between `TileA` and `TileB`
	 *	\static
	 */
	function MidPoint(TileA, TileB);

	/**	\brief	Get the perpendicular slope
	 *	\param	SlopeIn	original slope
	 *	\return	slope perpendicular to `SlopeIn` (as a floating point number)
	 *	\note	Perpendicular slopes are inverses of each other.
	 *	\see	Slope()
	 *	\see	\_MinchinWeb\_C\_.Infinity()
	 *	\static
	 */
	function Perpendicular(SlopeIn);

	/**	\brief	Get the slope between two tiles.
	 *	\param	TileA	first 'end' tile
	 *	\param	TileB	tile at the other 'end'
	 *	\return	Slope between the two tiles (typically as a floating point
	 *			number.
	 *	\return	If the slope is vertical, "Infinity (`Constants.Infinity()`)"
	 *			is returned.
	 *	\return	If the slope is flat (i.e. 0), `1/Infinity` is returned.
	 *	\see	\_MinchinWeb\_C\_.Infinity()
	 *	\static
	 */
	function Slope(TileA, TileB);

	/**	\brief	Does `Value` fall between the bounds?
	 *	\param	Bound1	one limit
	 *	\param	Bound2	another limit
	 *	\param	Value	the value being tested
	 *	\return	`True` is `Value` falls between the bounds, `False` otherwise.
	 *	\note	This is helpful in that there is no requirement that `Bound1` be
	 *			larger than `Bound2` or vis-versa.
	 *	\see	WithinFloat()
	 *	\static
	 */
	function Within(Bound1, Bound2, Value);

	/**	\brief	Does `Value` fall between the bounds?
	 *	\param	Bound1	one limit
	 *	\param	Bound2	another limit
	 *	\param	Value	the value being tested
	 *	\return	`True` is `Value` falls between the bounds, `False` otherwise.
	 *	\note	This is helpful in that there is no requirement that `Bound1` be
	 *			larger than `Bound2` or vis-versa.
	 *	\note	This version explicitly converts all three parameters to
	 *			floating point numbers before comparing them.
	 *	\see	Within()
	 *	\static
	 */
	function WithinFloat(Bound1, Bound2, Value);

	/**	\brief	Takes the absolute value of both numbers and then returns the
	 *			smaller of the two.
	 *	\return	the magnitude of the value closer to zero (this will always
	 *			be positive).
	 *	\see	MinAbsFloatKeepSign()
	 *	\see	MaxAbsFloat()
	 *	\static
	 */
	function MinAbsFloat(Value1, Value2);

	/**	\brief	Takes the absolute value of both numbers and then returns the
	 *			larger of the two.
	 *	\return	the magnitude of the value farther to zero (this will always
	 *			be positive).
	 *	\see	MinAbsFloat()
	 *	\see 	MaxAbsFloatKeepSign()
	 *	\static
	 */
	function MaxAbsFloat(Value1, Value2);

	/**	\brief	Returns the absolute value of a given number.
	 *	\return	the absolute value of a given number (this will always
	 *			be positive) (this will typically be a floating point number).
	 *	\static
	 */
	function AbsFloat(Value);

	/**	\brief	Returns the sign of a given number
	 *	\return +1 if the Value >= 0, -1 Value < 0
	 *	\static
	 */
	function Sign(Value);

	/**	\brief	Returns the smaller of the two numbers
	 *	\return	The smaller of the two numbers, as a floating point number.
	 *	\see	MaxFloat()
	 *	\static
	 */
	function MinFloat(Value1, Value2);

	/**	\brief	Returns the larger of the two numbers
	 *	\return	The larger of the two numbers, as a floating point number.
	 *	\see	MinFloat()
	 *	\static
	 */
	function MaxFloat(Value1, Value2);

	/**	\brief	Takes the absolute value of both numbers and then returns the
	 *			number with the lesser of the two, sign intact.
	 *	\see	MaxAbsFloatKeepSign()
	 *	\see	MinAbsFloat()
	 *	\static
	 */
	function MinAbsFloatKeepSign(Value1, Value2);

	/**	\brief	Takes the absolute value of both numbers and then returns the
	 *			number with the greater of the two, sign intact.
	 *	\see	MinAbsFloatKeepSign()
	 *	\see	MaxAbsFloat()
	 *	\static
	 */
	function MaxAbsFloatKeepSign(Value1, Value2);

	/**	\brief	The tile that is neighbouring `StartTile` that is closest to
	 *			`TowardsTile`
	 *
	 *	Given a `StartTile` and a `TowardsTile`, will give the tile immediately
	 *	next (Manhattan Distance == 1) to `StartTile` that is closest to
	 *	`TowardsTile`.
	 *	\return	a neighbouring tile to `StartTile`
	 *	\static
	 */
	function NextCardinalTile(StartTile, TowardsTile);

	/**	\brief	Returns the revision number of the current build of OpenTTD
	 *	\see	See AILib.Common for more details on what is contained in the
	 *			full returned version number.
	 *	\note	I determine this at the beginning of my AI's run so that when I
	 *			get bug reports, I know what version of OpenTTD was being run.
	 *	\note	This might also be useful if you want to turn on or off certain
	 *			features, depending on if they are in the user's version of OpenTTD.
	 *	\static
	 */
	function GetOpenTTDRevision();

	/**	\brief	Get the minimum distance between TileID and any of the tiles
	 *			in TargetArray
	 *	\note	This is designed such that it can be run as a validator on an
	 *			AIList of tiles
	 *	\param	TileID		Tile we measure distance from
	 *	\param	TargetArray	An array to tiles that we want to measure distance
	 *						to. This can also be an AIList where the items are
	 *						tiles.
	 *	\return	the minimum distance between TileID and any of the TargetArray
	 *	\note	Distances is measured using Manhattan Distance
	 *	\note	Distances to invalid tiles is reported as `-1`; therefore
	 *			invalid tiles are always 'closer' that valid tiles.
	 *	\todo	Remove invalid tiles from the TargetArray
	 */
	function MinDistance(TileID, TargetArray);

	/**	\brief	Get the maximum when provided with more than two inputs (up to
	 * 			four)
	 *	\param	i1...		input values
	 *	\return	the maximum value
	 *	\static
	 */
	function MultiMax(i1);
	function MultiMax(i1, i2);
	function MultiMax(i1, i2, i3);
	function MultiMax(i1, i2, i3, i4);
};


class _MinchinWeb_Extras_.Info {
	_main = null;

	function GetVersion()       { return 7; }
	// function GetMinorVersion()	{ return 0; }
	function GetRevision()		{ return 250714; }
	function GetDate()          { return "2025-07-14"; }
	function GetName()          { return "Extras"; }

	constructor(main) {
		this._main = main;
	}
};

//	== Function definitions =================================================

function _MinchinWeb_Extras_::SignLocation(text) {
	local sign_list = AISignList();
	for (local i = sign_list.Begin(); !sign_list.IsEnd(); i = sign_list.Next()) {
		if(AISign.GetName(i) == text)
		{
			return AISign.GetLocation(i);
		}
	}
	return null;
}

function _MinchinWeb_Extras_::MidPoint(TileA, TileB) {
	local X = (AIMap.GetTileX(TileA) + AIMap.GetTileX(TileB)) / 2 + 0.5;
	local Y = (AIMap.GetTileY(TileA) + AIMap.GetTileY(TileB)) / 2 + 0.5;
		//	the 0.5 is to make rounding work
	X = X.tointeger();
	Y = Y.tointeger();
	return AIMap.GetTileIndex(X, Y);
}

function _MinchinWeb_Extras_::Perpendicular(SlopeIn) {
	if (SlopeIn == 0) {
		return this._infinity;
	} else {
		SlopeIn = SlopeIn.tofloat();
		return (-1 / SlopeIn);
	}
}

function _MinchinWeb_Extras_::Slope(TileA, TileB) {
	local dx = AIMap.GetTileX(TileB) - AIMap.GetTileX(TileA);
	local dy = AIMap.GetTileY(TileB) - AIMap.GetTileY(TileA);

	//	Zero check
	if (dx == 0) {
		return _MinchinWeb_C_.Infinity() * _MinchinWeb_Extras_.Sign(dy);
	} else if (dy == 0) {
		return (1.0 / _MinchinWeb_C_.Infinity()) * _MinchinWeb_Extras_.Sign(dx);
	} else {
		dx = dx.tofloat();
		dy = dy.tofloat();

		return (dy / dx);
	}
}

function _MinchinWeb_Extras_::Within(Bound1, Bound2, Value) {
	local UpperBound = max(Bound1, Bound2);
	local LowerBound = min(Bound1, Bound2);

	return ((Value <= UpperBound) && (Value >= LowerBound));
}

function _MinchinWeb_Extras_::WithinFloat(Bound1, Bound2, Value) {
	local UpperBound = _MinchinWeb_Extras_.MaxFloat(Bound1, Bound2) + _MinchinWeb_C_.FloatOffset();
	local LowerBound = _MinchinWeb_Extras_.MinFloat(Bound1, Bound2) - _MinchinWeb_C_.FloatOffset();
	local Value = Value.tofloat();

//	_MinchinWeb_Log_.Note("          Extras.WithinFloat: Val=" + Value + " B1=" + Bound1 + " B2=" + Bound2 + " : UB=" + UpperBound + " LB=" + LowerBound + " is " + (Value <= UpperBound) + " " + (Value >= LowerBound) + " : " + ((Value <= UpperBound) && (Value >= LowerBound)) + " : above " + (Value - UpperBound) + " below " + (LowerBound - Value) + " : " + _MinchinWeb_C_.FloatOffset() , 7);

	return ((Value <= UpperBound) && (Value >= LowerBound));
}

function _MinchinWeb_Extras_::MinAbsFloat(Value1, Value2) {
	if (Value1 < 0) { Value1 *= -1.0; }
	if (Value2 < 0) { Value2 *= -1.0; }
	if (Value1 <= Value2) {
		return Value1;
	} else {
		return Value2;
	}
}

function _MinchinWeb_Extras_::MaxAbsFloat(Value1, Value2) {
	if (Value1 < 0) { Value1 *= -1.0; }
	if (Value2 < 0) { Value2 *= -1.0; }
	if (Value1 >= Value2) {
		return Value1;
	} else {
		return Value2;
	}
}

function _MinchinWeb_Extras_::AbsFloat(Value) {
	if (Value >= 0) {
		return Value;
	} else {
		return (Value * (-1.0));
	}
}

function _MinchinWeb_Extras_::Sign(Value) {
	if (Value >= 0) {
		return 1;
	} else {
		return -1;
	}
}

function _MinchinWeb_Extras_::MinFloat(Value1, Value2) {
	if (Value1 <= Value2) {
		return (Value1).tofloat();
	} else {
		return (Value2).tofloat();
	}
}

function _MinchinWeb_Extras_::MaxFloat(Value1, Value2) {
	if (Value1 >= Value2) {
		return (Value1).tofloat();
	} else {
		return (Value2).tofloat();
	}
}

function _MinchinWeb_Extras_::MinAbsFloatKeepSign(Value1, Value2) {
	local Sign1 = _MinchinWeb_Extras_.Sign(Value1);
	local Sign2 = _MinchinWeb_Extras_.Sign(Value2);
	if (Value1 < 0) { Value1 *= -1.0; }
	if (Value2 < 0) { Value2 *= -1.0; }
	if (Value1 <= Value2) {
		return (Value1 * Sign1).tofloat();
	} else {
		return (Value2 * Sign2).tofloat();
	}
}

function _MinchinWeb_Extras_::MaxAbsFloatKeepSign(Value1, Value2) {
	local Sign1 = _MinchinWeb_Extras_.Sign(Value1);
	local Sign2 = _MinchinWeb_Extras_.Sign(Value2);
	if (Value1 < 0) { Value1 *= -1.0; }
	if (Value2 < 0) { Value2 *= -1.0; }
	if (Value1 >= Value2) {
		return (Value1 * Sign1).tofloat();
	} else {
		return (Value2 * Sign2).tofloat();
	}
}

function _MinchinWeb_Extras_::NextCardinalTile(StartTile, TowardsTile) {
	local Tiles = AITileList();
	local offsets = [AIMap.GetTileIndex(0, 1), AIMap.GetTileIndex(0, -1),
						AIMap.GetTileIndex(1, 0), AIMap.GetTileIndex(-1, 0)];

	foreach (offset in offsets) {
		Tiles.AddItem(StartTile + offset, AIMap.DistanceSquare(StartTile + offset, TowardsTile));
	}

	Tiles.Sort(AIList.SORT_BY_VALUE, AIList.SORT_ASCENDING);

	return Tiles.Begin();
}

function _MinchinWeb_Extras_::GetOpenTTDRevision() {
	local Version = AIController.GetVersion();
	local Revision = Version & 0x0007FFFF;
	return Revision;
}

function _MinchinWeb_Extras_::MinDistance(TileID, TargetArray) {
	local MinDist = _MinchinWeb_C_.Infinity();
	foreach (Target in TargetArray) {
		//	note that with AIList's, Target is the `Value`, not the `Item`
		MinDist = min(MinDist, AITile.GetDistanceManhattanToTile(TileID, Target));
	}
	return MinDist;
}

function _MinchinWeb_Extras_::MultiMax(i1) {
	return i1;
}
function _MinchinWeb_Extras_::MultiMax(i1, i2) {
	return max(i1, i2);
}
function _MinchinWeb_Extras_::MultiMax(i1, i2, i3) {
	return max(max(i1, i2), i3);
}
function _MinchinWeb_Extras_::MultiMax(i1, i2, i3, i4) {
	return max(max(max(i1, i2), i3), i4);
}
// EOF
