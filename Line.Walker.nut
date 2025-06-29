/*	LineWalker class v.1 r.221 [2012-01-28],
 *		part of Minchinweb's MetaLibrary v.4,
 *		originally part of WmDOT v.7
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

/**	\brief		Line Walker
 *	\version	v.1 (2012-01-28)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.4
 *
 *	The LineWalker class allows you to define a starting and endpoint, and then
 *		'walk' all the tiles between the two. Alternately, you can give a
 *		starting point and a slope. It was originally part of my Ship
 *		Pathfinder, also part of Minchinweb's MetaLibrary.
 */

/*	Functions provided:
 *		MetaLib.LineWalker()
 *		MetaLib.LineWalker.Start(Tile)
 *						  .End(Tile)
 *						  .Slope(Slope)
 *						  .Reset()
 *						  .Restart()
 *						  .Walk()
 *						  .IsEnd()
 *						  .GetStart()
 *						  .GetEnd()
 */

/**	\note	Plane geometry does funky things when you don't have an infinity, or
 *			by extension, zero (the inverse of infinity) for slopes. To get
 *			around the fact integer conversions drop everything past the decimal
 *			point (effectively rounding down), slopes are set so that there is a
 *			slight inflection point at the 'origin' so that as you move out from
 *			the start point, so stay slightly above the 'unchanging' index...
 *
 *	\note	`LineWalker` is designed to be a persistent class.
 *	\see	\_MinchinWeb\_SW\_
 */

class _MinchinWeb_LW_ {
	_start = null;				///<	start tile
	_end = null;				///<	end tile
	_slope = null;				///<	line slope
	_start_x = null;				///<	x value of start tile
	_start_y = null;				///<	y value of start tile
	_end_x = null;				///<	x value of end tile
	_end_y = null;				///<	y value of end tile
	_past_end = null;
	_x = null;					///<	x value of current tile
	_y = null;					///<	y value of current tile
	_dir_x = null;
	_current_tile = null;		///<	current tile

	constructor() {
		this._past_end = true;
//		this._infinity = _MinchinWeb_C_.Infinity();	//	close enough to infinity :P
								//	Slopes are capped at 10,000 and 1/10,000

	}

	/**	\publicsection
	 *	\brief	Sets the starting tile for LineWalker
	 *	\see	End()
	 *	\see	Slope()
	 *	\see	Restart()
	 *	\see	Reset()
	 *	\see	GetStart()
	 */
	function Start(Tile);

	/**	\brief	Sets the ending tile for LineWalker
	 *	\note	If the slope is also directly set, the start and end tiles
	 *			define a bounding box. Otherwise, the slope is calculated
	 *			between the start and end tiles.
	 *	\see	Start()
	 *	\see	Slope()
	 *	\see	GetEnd()
	 */
	function End(Tile);

	/**	\brief	Sets the slope for LineWalker
	 *	\note	Assumes that the slope is in the first or second quadrant unless
	 *			`ThirdQuadrant == true`
	 *	\todo	Add a picture of the four Cartesian quadrants
	 */
	function Slope(Slope, ThirdQuadrant = false);

	/** \brief	Resets the variables for the LineWalker
	 *	\see	Restart()
	 */
	function Reset();

	/**	\brief	Moves the LineWalker to the original starting position
	 *	\see	Reset()
	 */
	function Restart();

	//	=== LineWalker Walk ===
	//		This is where (most) of the action is!

	/**	\brief	'Walks' the LineWalker one tile at a tile
	 *	\return	the tile that the LineWalker is now "standing on"
	 *	\note	This is where (most) of the action is!
	 *	\note	Before calling this function, you need to set the Start() and at
	 *			least one of End() or Slope().
	 */
	function Walk();

	/**	\brief	Returns `True` if we are at the edge of the bounding box defined
	 *			by the Starting and Ending point
	 *	\return	`True` if we are at the edge of the bounding box defined
	 *			by the Starting and Ending point
	 *	\see	End()
	 *	\see	GetEnd()
	 */
	function IsEnd() { return this._past_end; }

	/**	\brief	Returns the tile the LineWalker is starting on
	 *	\return	The tile the LineWalker is starting on
	 *	\see	Start()
	 */
	function GetStart() { return this._start; }

	/**	\brief	Returns the tile the LineWalker is ending on
	 *	\return	The tile the LineWalker is ending on
	 *	\see	End()
	 *	\see	IsEnd()
	 */
	function GetEnd() { return this._end; }
};


//	== Function definitions ==================================================

function _MinchinWeb_LW_::Start(Tile) {
	this._start = Tile;
	this._start_x = AIMap.GetTileX(Tile);
	this._start_y = AIMap.GetTileY(Tile);
	this._x = this._start_x;
	this._y = this._start_y;
	this._past_end = false;
	this._current_tile = AIMap.GetTileIndex(this._x, this._y);
	this._x = this._x.tofloat();
	this._y = this._y.tofloat();

	if (this._end != null) {
		if (this._slope == null) {
			this._slope = _MinchinWeb_Extras_.Slope(this._start, this._end);
		}

		if (this._start_x < this._end_x) {
			this._dir_x = 1;
		} else if (this._start_x > this._end_x) {
			this._dir_x = -1;
		} else {
		//	startX == EndX
			if (this._start_y < this._end_y) {
				this._dir_x = 1;

			} else {
				this._dir_x = 1;
			}
			this._end_x = this._end_x.tofloat() + (1.0 - (1.0 / _MinchinWeb_C_.Infinity()));
		}

		if (this._start_y == this._end_y) {
			this._end_y = this._end_y.tofloat() + (1.0 - (1.0 / _MinchinWeb_C_.Infinity()));
		}
	}

//	_MinchinWeb_Log_.Note("    LineWalker.Start out: " + this._start_x + " " + this._start_y + " m" + this._slope + " ± " + this._dir_x, 6);
}

function _MinchinWeb_LW_::End(Tile) {
	this._end = Tile;
	this._end_x = AIMap.GetTileX(Tile);
	this._end_y = AIMap.GetTileY(Tile);

	if (this._start != null) {
		if (this._slope == null) {
			this._slope = _MinchinWeb_Extras_.Slope(this._start, this._end);
		}

		if (this._start_x < this._end_x) {
			this._dir_x = 1;
		} else if (this._start_x > this._end_x) {
			this._dir_x = -1;
		} else {
		//	startX == EndX
			if (this._start_y < this._end_y) {
				this._dir_x = 1;

			} else {
				this._dir_x = 1;
			}
			this._end_x = this._end_x.tofloat() + (1.0 - (1.0 / _MinchinWeb_C_.Infinity()));
		}

		if (this._start_y == this._end_y) {
			this._end_y = this._end_y.tofloat() + (1.0 - (1.0 / _MinchinWeb_C_.Infinity()));
		}
	}

//	_MinchinWeb_Log_.Note("    LineWalker.End out: " + this._end_x + " " + this._end_y + " m" + this._slope + " ± " + this._dir_x + " mult=" + _MinchinWeb_Extras_.MinAbsFloat(1.0, (1.0 / this._slope) ), 6);
}

function _MinchinWeb_LW_::Slope(Slope, ThirdQuadrant = false) {
	if (_MinchinWeb_Extras_.AbsFloat(Slope) > _MinchinWeb_C_.Infinity()) {
		AILog.Warning("Slope is capped at " + _MinchinWeb_C_.Infinity() + ", you provided " + Slope + ".");
		this._slope = _MinchinWeb_C_.Infinity();
	} else if (_MinchinWeb_Extras_.AbsFloat(Slope) < (1.0 / _MinchinWeb_C_.Infinity())) {
		AILog.Warning("Slope is capped at 1/" + _MinchinWeb_C_.Infinity() + ", you provided " + Slope + ".");
		this._slope = (1.0 / _MinchinWeb_C_.Infinity());
	} else {
		this._slope = Slope;
	}

	if (ThirdQuadrant == false) {
		this._dir_x = 1;
		this._end_x = AIMap.GetMapSizeX();

		if (this._slope > 0.0) {
			this._end_y = AIMap.GetMapSizeY();
		} else {
			this._end_y = 0;
		}

	} else {
		this._dir_x = -1;
//		this._x += (1.0 - (1.0 / _MinchinWeb_C_.Infinity()));
//		this._end_x = -1 * this._infinity;
//		this._end_y = -1 * this._end_y;
		this._end_x = 0;

		if (this._slope > 0.0) {
	//		this._end_y = AIMap.GetMapSizeY();
			this._end_y = 0;
		} else {
	//		this._end_y = 0;
			this._end_y = AIMap.GetMapSizeY();
		}
	}

//	_MinchinWeb_Log_.Note("   LineWalker.Slope out: " + Slope + " " + ThirdQuadrant + " : " + this._end_x + " " + this._end_y + " " + this._slope + " ± " + this._dir_x, 6);
}

function _MinchinWeb_LW_::Reset() {
	this._start = null;
	this._end = null;
	this._slope = null;
	this._start_x = null;
	this._start_y = null;
	this._end_x = null;
	this._end_y = null;
	this._past_end = true;
	this._x = null;
	this._y = null;
	this._current_tile = null;
	this._dir_x = null;
}

function _MinchinWeb_LW_::Restart() {
	this._x = this._start_x.tofloat();
	this._y = this._start_y.tofloat();
	this._past_end = false;
	this._current_tile = AIMap.GetTileIndex(this._x.tointeger(), this._y.tointeger());
}

//	=== LineWalker Walk ===
//		This is where (most) of the action is!
function _MinchinWeb_LW_::Walk() {
	if (this._past_end == true) {
		return this._current_tile;
	}

	if ((AIMap.DistanceManhattan(this._current_tile, AIMap.GetTileIndex(this._x.tointeger(), this._y.tointeger())) == 1 ) && _MinchinWeb_Extras_.WithinFloat(this._start_x.tofloat(), this._end_x.tofloat(), this._x.tointeger()) &&_MinchinWeb_Extras_.WithinFloat(this._start_y.tofloat(), this._end_y.tofloat(), this._y.tointeger())) {
		this._current_tile = AIMap.GetTileIndex(this._x.tointeger(), this._y.tointeger());
//		_MinchinWeb_Log_.Note("Linewalker output " + AIMap.GetTileX(this._current_tile) + "," + AIMap.GetTileY(this._current_tile) + " from " + this._x + "," + this._y, 7);
		return this._current_tile;
	}

	//	Infinity assumed to be 10,000
	local multiplier = 0.0;

	//	We need to find the value, such that MAX(ABS(∆x, m∆x)) == 1
	//		Therefore, our multiplier is MIN(ABS(1, 1/m))
	multiplier = _MinchinWeb_Extras_.MinAbsFloat(1.0, (1.0 / this._slope) );

	local NewX = 0.0;
	local NewY = 0.0;
	NewX = this._x + multiplier * this._dir_x;
	NewY = this._y + this._slope * multiplier * this._dir_x;
//	_MinchinWeb_Log_.Note("Linewalker new : " + NewX + "," + NewY, 7);

	if (AIMap.DistanceManhattan(this._current_tile, AIMap.GetTileIndex(NewX.tointeger(), NewY.tointeger())) == 1 ) {
		this._current_tile = AIMap.GetTileIndex(NewX.tointeger(), NewY.tointeger());
	} else if (AIMap.DistanceManhattan(this._current_tile, AIMap.GetTileIndex(NewX.tointeger(), this._y.tointeger())) == 1 ) {
		this._current_tile = AIMap.GetTileIndex(NewX.tointeger(), this._y.tointeger());
	}

	this._x = NewX;
	this._y = NewY;

	//	Check that we're still within our bounding box
//	_MinchinWeb_Log_.Note("    " + this._start_x + " , " + this._end_x + " , " + this._x.tointeger() + " , " + this._start_y + " , " + this._end_y + " , " + this._y.tointeger(), 7);

	if (!_MinchinWeb_Extras_.WithinFloat(this._start_x.tofloat(), this._end_x.tofloat(), this._x) || !_MinchinWeb_Extras_.WithinFloat(this._start_y.tofloat(), this._end_y.tofloat(), this._y)) {
//		_MinchinWeb_Log_.Note("Linewalker outside box " + this._start_x + " " + this._end_x + " " + this._x + " " + _MinchinWeb_Extras_.WithinFloat(this._start_x.tofloat(), this._end_x.tofloat(), this._x) + " : " + this._start_y + " " + this._end_y + " " + this._y + " " + (_MinchinWeb_Extras_.WithinFloat(this._start_y.tofloat(), this._end_y.tofloat(), this._y)), 6);
		this._past_end = true;
		return this._current_tile;
	} else {
//		_MinchinWeb_Log_.Note("Linewalker output " + AIMap.GetTileX(this._current_tile) + "," + AIMap.GetTileY(this._current_tile), 6);
		return this._current_tile;
	}
}
// EOF
