/*	Minchinweb's MetaLibrary v.11 [2015-09-30],
 *		originally part of WmDOT v.10
 *	Copyright © 2011-15, 2025 by W. Minchin. For more info,
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

/**	\brief	MinchinWeb extends AILibrary so that it is registered as a library
 *			by OpenTTD.
 *	\see	MinchinWeb
 */
class MinchinWeb extends AILibrary {
	function GetAuthor()      { return "W. Minchin"; }
	function GetName()        { return "MinchinWeb"; }
	function GetShortName()   { return "LMmW"; }	//	William's MetaLibrary
	function GetDescription() { return "Minchinweb's MetaLibrary for AI development. See the minchin.ca/openttd-metalibrary/ for included functions. (v.10, 2025-07-11)"; }
	function GetVersion()     { return 11; }
	function GetDate()        { return "2025-09-30"; }
	function CreateInstance() { return "MinchinWeb"; }
	function GetCategory()    { return "Util"; }
//	function GetURL()		  { return "http://www.tt-forums.net/viewtopic.php?f=65&t=57903"; }
//	function GetAPIVersion()  { return "1.2"; }
	function MinVersionToLoad() { return 1; }
}

RegisterLibrary(MinchinWeb());

//	requires AyStar v6
//	requires Fibonacci Heap v3
