/*	Logging Interface v.4, [2014-02-14]
 *		part of MinchinWeb's MetaLibrary v.4,
 *		originally part of WmDOT v.5
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

/**	\brief		Logging Interface
 *	\version	v.4 (2014-02-14)
 *	\author		W. Minchin (%MinchinWeb)
 *	\since		MetaLibrary v.4
 *
 * To make use of this library, add this you the `info.nut` file of your AI:
 *
 * ~~~
	function GetSettings() {
		AddSetting({name = "Debug_Level", description = "Debug Level ", min_value = 0, max_value = 8, easy_value = 3, medium_value = 3, hard_value = 3, custom_value = 3, flags = CONFIG_INGAME});
	}
 * ~~~
 *
 * This will add an option to your AI allowing users to control the debug output
 * from your AI. You can allow this setting to be configured in-game, as it is
 * read each time the class is called.
 *
 *	\note	There is no requirement that you use the Logging interface in your
 *			AI if you make use of MetaLibrary. You just will not see any
 *			debugging output from the library.
 *	\note	This class will work equally well as a static or a non-static class,
 *			as Debug Level is determined at each call.
 */

class _MinchinWeb_Log_ {
	/**	\publicsection
	 *	\fn		GetVersion()
	 *	\return	current version of the Logging Interface
	 *	\static
	 *	\fn		GetDate()
	 *	\return	the date of the last update to the Logging Interface
	 *	\static
	 *	\fn		GetName()
	 *	\return	the name of the Logging Interface
	 *	\static
	 *	\fn		GetRevision()
	 *	\return	The revision (as per svn) of the last update to the Logging
	 *			Interface.
	 *	\static
	 *	\note	This has been changed with the move to git. On files updated
	 *			since the move to git, this will be of the form YYMMDD.
	 */
	function GetVersion()       { return 4; };
	function GetRevision()		{ return 140214; };
	function GetDate()          { return "2014-02-14"; };
	function GetName()          { return "Logging Interface"; };

	/**	\privatesection
	 *	\var	_DebugLevel
	 *	Used to hold the current debug level.
	 *
	 *	Messages with a debug level less than or equal to the current debug
	 *	level will be printed to the AI debug screen (or a sign placed, as
	 *	appropriate). Others will be silently ignored.
	 *
	 *	The debug level is not designed to be set directly by the AI.
	 *
	 *	This is how I have 'translated' the various levels 1 through 8 on the
	 *	AI settings to what I would expect to see on the debug screen.
	 *
	 *	- AI's
	 *		- 0 - run silently
	 *		- 1 - 'Operations' noted here
	 *		- 2 - 'normal' debugging - each step
	 *		- 3 - substeps
	 *		- 4 - most verbose (including arrays)
	 *		- 5 - including signs (but generally nothing more from the AI to
	 *				the debug screen)
	 *	- Libraries
	 *		- 5 - basic
	 *		- 6 - verbose
	 *  	- 7 - signs
	 *		- 8 - signs for library subfunctions
	 *
	 *	Every level beyond 1 is indented 5 spaces per higher level.
	 */
	_DebugLevel = null;

	/** \private
	 *	Does nothing
	 */
	function constructor() { };

	/**	\publicsection
	 *	\brief	Output messages to the AI debug screen.
	 *	Displays the message if the Debug level is set high enough.
	 *
	 *	Can be used as a replacement for `AILog.Info()`
	 *	\param	Message	message to print to AI debug screen
	 *	\param	Level	required minimum level to print message (default is 3)
	 *	\static
	 */
	function Note(Message, Level = 3);

	/**	\public
	 *	\brief	Output warnings to the AI debug screen.
	 *
	 *	Displays the message as a Warning (in yellow text).
	 *
	 *	Can be used as a replacement for `AILog.Warning()`
	 *	\param	Message	message to print to AI debug screen
	 *	\static
	 */
	function Warning(Message) { AILog.Warning(Message); };

	/**	\public
	 *	\brief	Output errors to the AI debug screen.
	 *
	 *	Displays the message as an Error (in red text).
	 *
	 *	Can be used as a replacement for `AILog.Error()`.
	 *	If not captured, errors (including calling this function) will crash
	 *	your AI.
	 *	\param	Message	message to print to AI debug screen
	 *	\static
	 */
	function Error(Message) { AILog.Error(Message); };

	/**	\public
	 *	\brief	Prints a message on a sign.
	 *
	 *	\param	Tile	tile to place the sign on (as an `AITile` object)
	 *	\param	Message	message to print on the sign
	 *	\param	Level	required minimum level to place tile (default is 5)
	 *	\static
	 */
	function Sign(Tile, Message, Level = 5);

	/**	\public
	 *	\brief	Prints the current debug level to the AI debug screen.
	 *	\return	nothing
	 *	\static
	 */
	function PrintDebugLevel();

	/**	\public
	 *	\brief	Looks for an AI setting for Debug Level, and set the debug level to that.
	 *
	 *	This is a bit of a failsafe. If there is no AI setting for the debug
	 *	level, then a default of 3 is used.
	 *
	 *	This function will not typically need to be called directly.
	 *	\return	current debug level, as per AI setting.
	 *	\see _DebugLevel
	 *	\static
	 */
	function UpdateDebugLevel() {
		local DebugLevel = 3;
		if (AIController.GetSetting("Debug_Level") != -1) {
			DebugLevel = AIController.GetSetting("Debug_Level");
		}
		return DebugLevel;
	};
};

//	== Function definition =================================================

function _MinchinWeb_Log_::Note(Message, Level = 3) {
	if (Level <=  _MinchinWeb_Log_.UpdateDebugLevel() ) {
		local i = 1;
		while (i < Level) {
			Message = "     " + Message;
			Level--;
		}
		AILog.Info(Message);
	}
}

function _MinchinWeb_Log_::Sign(Tile, Message, Level = 5) {
	if (Level <= _MinchinWeb_Log_.UpdateDebugLevel() ) {
		AISign.BuildSign(Tile, Message);
	}
}

function _MinchinWeb_Log_::PrintDebugLevel() {
	try {
		AILog.Info("OpLog is running at level " + AIController.GetSetting("Debug_Level") + ".");
	} catch (all) {
		AILog.Warning("No AI setting 'Debug_Level'");
	}

}

function _MinchinWeb_Log_::UpdateDebugLevel() {
	local DebugLevel = 3;
	if (AIController.GetSetting("Debug_Level") != -1) {
		DebugLevel = AIController.GetSetting("Debug_Level");
	}
	return DebugLevel;
}
// EOF
