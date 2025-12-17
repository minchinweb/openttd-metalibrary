class Wm14864Test extends AIInfo
{
	function GetAuthor()        { return "William Minchin"; }
	function GetName()          { return "Issue 14864 Test"; }
	function GetDescription()   { return "This AI is to test the Logging Interface in OpenTTD. 2025-12-16"; }
	function GetVersion()       { return 1; }
	function MinVersionToLoad() { return 1; }
	function GetDate()          { return "2025-12-16"; }
	function GetShortName()     { return "2ZmW"; }
	function CreateInstance()   { return "Wm14864Test"; }
	function GetAPIVersion()    { return "15"; }

	// function GetSettings() {
	// 	AddSetting({name = "Debug_Level", description = "Debug Level ", min_value = 0, max_value = 7, easy_value = 7, medium_value = 7, hard_value = 7, custom_value = 7, flags = CONFIG_INGAME});
	// }
}

/* Tell the core we are an AI */
RegisterAI(Wm14864Test());

