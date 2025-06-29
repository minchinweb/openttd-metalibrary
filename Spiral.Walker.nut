/*	SpiralWalker class v.3 r.223 [2012-01-28],
 *		part of Minchinweb's MetaLibrary v.4,
 *		originally part of WmDOT v.5
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

/**	\brief		Spiral Walker
 *	\version	v.3 (2012-01-28)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.4
 *
 *	The SpiralWalker class allows you to define a starting point, and then
 *		'walk' all the tiles in a spiral outward. It was originally used to
 *		find a build-able spot for my HQ in WmDOT, but is useful for many other
 *		things as well.
 *
 *	\note	`SpiralWalker` is designed to be a persistent class.
 *	\see	\_MinchinWeb\_LW\_
 *	\todo	add image showing the walk out pattern
 */

/*	Functions provided:
 *		MetaLib.SpiralWalker()
 *		MetaLib.SpiralWalker.Start(Tile)
 *							.Reset()
 *							.Restart()
 *							.Walk()
 *							.GetStart()
 *							.GetStage()
 *							.GetStep()
 */

class _MinchinWeb_SW_ {
	_start = null;				///<	start tile
	_start_x = null;			///<	x value of start tile
	_start_y = null;			///<	y value of start tile
	_x = null;					///<	x value of current tile
	_y = null;					///<	y value of current tile
	_current_tile = null;		///<	current tile
	_dx = null;
	_dy = null;
	_Steps = null;				///< see GetStep()
	_Stage = null;				///< see GetStage()
	_StageMax = null;
	_StageSteps = null;

	constructor() {
		this._dx = -1;
		this._dy =  0;
		this._Steps = 0;
		this._Stage = 1;
		this._StageMax = 1;
		this._StageSteps = 0;
	}

	/**	\publicsection
	 *	\brief	Sets the starting tile for SpiralWalker
	 *	\see	Restart()
	 */
	function Start(Tile);

	/** \brief	Resets the variables for the SpiralWalker
	 *	\see	Restart()
	 */
	function Reset();

	/**	\brief	Moves the SpiralWalker to the original starting position
	 *	\see	Reset()
	 */
	function Restart();

	/**	\brief	'Walks' the SpiralWalker one tile at a tile
	 *	\return	the tile that the SpiralWalker is now "standing on"
	 *	\note	This is where (most) of the action is!
	 *	\note	Before calling this function, you need to set the Start().
	 */
	function Walk();

	/**	\brief	Returns the tile the SpiralWalker is starting on
	 *	\return	The tile the SpiralWalker is starting on
	 *	\see	Start()
	 */
	function GetStart() { return this._start; }

	/**	\brief	Returns the Stage the SpiralWalker is on.
	 *
	 *	Basically, the line segments its completed plus one; it takes four
	 *	stages to complete a revolution.
	 *	\return	stage number
	 *	\see	GetStep()
	 *	\todo	Add an image showing how stages are counted
	 */
	function GetStage() { return this._Stage; }

	/**	\brief	Returns the Tile the SpiralWalker is on.
	 *	\return	the Tile the SpiralWalker is on.
	 *	\see	GetStep()
	 *	\see	GetStage()
	 */
	function GetTile() { return this._current_tile; }

	/**	\brief	Returns the number of steps the SpiralWalker has done.
	 *	\return	The number of steps the SpiralWalker has done.
	 *	\see	GetStage()
	 *	\todo	Add an image showing how steps are counted
	 */
	function GetStep() { return this._Steps; }
};


//	== Function definition ==================================================
function _MinchinWeb_SW_::Start(Tile) {
	this._start = Tile;
	this._start_x = AIMap.GetTileX(Tile);
	this._start_y = AIMap.GetTileY(Tile);
	this._x = this._start_x;
	this._y = this._start_y;
	this._current_tile = this._start;

	this._dx = -1;
	this._dy =  0;
	this._Steps = 0;
//	this._Stage = 1;
	this._Stage = 1;
	this._StageMax = 1;
	this._StageSteps = 0;
}

function _MinchinWeb_SW_::Reset() {
	this._start = null;
	this._start_x = null;
	this._start_y = null;
	this._x = null;
	this._y = null;
	this._current_tile = null;
}

function _MinchinWeb_SW_::Restart() {
	this._x = this._start_x;
	this._y = this._start_y;
	this._current_tile = this._start;

	this._dx = -1;
	this._dy =  0;
	this._Steps = 0;
	this._Stage = 1;
	this._StageMax = 1;
	this._StageSteps = 0;
}

function _MinchinWeb_SW_::Walk() {
	if (this._Steps == 0) {
		this._Steps++;
	} else {

		this._x += this._dx;
		this._y += this._dy;
		this._StageSteps ++;
		this._Steps ++;

		// Check if it's time to turn
		if (this._StageSteps == this._StageMax) {
			this._StageSteps = 0;
			if (this._Stage % 2 == 0) {
				this._StageMax++;
			}
			this._Stage ++;

			// Turn Clockwise
			switch (this._dx) {
				case 0:
					switch (this._dy) {
						case -1:
							this._dx = -1;
							this._dy =  0;
							break;
						case 1:
							this._dx = 1;
							this._dy = 0;
							break;
					}
					break;
				case -1:
					this._dx = 0;
					this._dy = 1;
					break;
				case 1:
					this._dx =  0;
					this._dy = -1;
					break;
			}
		}
	}
	_MinchinWeb_Log_.Note("     SpiralWalker.Walk: " + this._dx + " " + this._dy + " : " + this._Steps + " " + this._Stage + " " + this._StageSteps + " " + this._StageMax + " :: " + this._x + ", " + this._y, 7);
	this._current_tile = AIMap.GetTileIndex(this._x, this._y);
//	AISign.BuildSign(this._current_tile, "" + this._Steps);
	return this._current_tile;
}
// EOF
