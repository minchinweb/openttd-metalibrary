/*	Minchinweb's MetaLibrary v.9 [2014-03-10],
 *		originally part of, WmDOT v.10
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

/*	See the README for a list of the functions included in this library.
 */

require("Pathfinder.Road.nut");
	//	Requires Graph.AyStar v6 library
// require("AyStar.WM.nut");
require("Array.nut");
// require("Fibonacci.Heap.WM.nut");
require("Extras.nut");
require("Constants.nut");
require("Waterbody.Check.nut");
require("Lakes.nut");
require("Pathfinder.Ship.nut");
require("Line.Walker.nut");
require("Spiral.Walker.nut");
require("Atlas.nut");
require("Marine.nut");
require("Log.nut");
require("Dominion.Roads.nut");
require("Industry.nut");
require("Station.nut");


/**	\brief	Main Library Class
 *
 *	This is the main class of the Library. It will be renamed on importing the
 *	library into your AI.
 *
 *		Import("util.MinchinWeb", "[your_access_name]", 9);
 *
 *	(Don't really use `[your_access_name]`, use something that is easy enough
 *	to type and will remind you of where the functions are coming from. I like
 *	to use `%MinchinWeb`.)
 *
 *	Using imported name for the library, you can then access the various
 *	sublibraries. For example:
 *	-	`%MinchinWeb.Atlas` <- \_MinchinWeb\_Atlas\_
 *	-	`%MinchinWeb.Array` <- \_MinchinWeb\_Array\_
 *	-	`%MinchinWeb.Constants` <- \_MinchinWeb\_C\_
 *	-	`%MinchinWeb.DLS` <- \_MinchinWeb\_DLS\_
 *	-	`%MinchinWeb.Extras` <- \_MinchinWeb\_Extras\_
 *	-	`%MinchinWeb.Lakes` <- \_MinchinWeb\_Lakes\_
 *	-	`%MinchinWeb.LineWalker` <- \_MinchinWeb\_LW\_
 *	-	`%MinchinWeb.Log` <- \_MinchinWeb\_Log\_
 *	-	`%MinchinWeb.Industry` <- \_MinchinWeb\_Industry\_
 *	-	`%MinchinWeb.Marine` <- \_MinchinWeb\_Marine\_
 *	-	`%MinchinWeb.ShipPathfinder` <- \_MinchinWeb\_ShipPathfinder\_
 *	-	`%MinchinWeb.SpiralWalker` <- \_MinchinWeb\_SW\_
 *	-	`%MinchinWeb.Station` <- \_MinchinWeb\_Station\_
 *	-	`%MinchinWeb.RoadPathfinder` <- \_MinchinWeb\_RoadPathfinder\_
 *	-	`%MinchinWeb.WaterbodyCheck` <- \_MinchinWeb\_WBC\_
 */
class MinchinWeb {
	/**	\publicsection
	 */
	function GetVersion()       { return 9; }
	function GetRevision(       { return 140228; }
	function GetDate()          { return "2014-02-28"; }
	function GetName()          { return "MinchinWeb's MetaLibrary"; }

	static RoadPathfinder = _MinchinWeb_RoadPathfinder_;
	///<	\see	\_MinchinWeb\_RoadPathfinder\_

	static ShipPathfinder = _MinchinWeb_ShipPathfinder_;
	///<	\see	\_MinchinWeb\_ShipPathfinder\_

	static Array = _MinchinWeb_Array_;
	///<	\see	\_MinchinWeb\_Array\_

	static Extras = _MinchinWeb_Extras_;
	///<	\see	\_MinchinWeb\_Extras\_

	static WaterbodyCheck = _MinchinWeb_WBC_;
	///<	\see	\_MinchinWeb\_WBC\_

	static LineWalker = _MinchinWeb_LW_;
	///<	\see	\_MinchinWeb\_LW\_

	static SpiralWalker = _MinchinWeb_SW_;
	///<	\see	\_MinchinWeb\_SW\_

	static Constants = _MinchinWeb_C_;
	///<	\see	\_MinchinWeb\_C\_
	// in Constants.nut

	static Atlas = _MinchinWeb_Atlas_;
	///<	\see	\_MinchinWeb\_Atlas\_

	static Marine = _MinchinWeb_Marine_;
	///<	\see	\_MinchinWeb\_Marine\_

	static Industry = _MinchinWeb_Industry_;
	///<	\see	\_MinchinWeb\_Industry\_

	static Station = _MinchinWeb_Station_;
	///<	\see	\_MinchinWeb\_Station\_

	static Log = _MinchinWeb_Log_;
	///<	\see	\_MinchinWeb\_Log\_

	static DLS = _MinchinWeb_DLS_;
	///<	\see	\_MinchinWeb\_DLS\_
	// in Dominion.Roads.nut

	static Lakes = _MinchinWeb_Lakes_;
	///<	\see	\_MinchinWeb\_Lakes\_
};
// EOF
