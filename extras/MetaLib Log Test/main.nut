/*	WmBasic v.3  r.140214
 *	Created by W. Minchin
 */

import("util.MinchinWeb", "MetaLib", 7);
import("util.SuperLib", "SuperLib", 26);

class WmLogTest extends AIController {
	//	SETTINGS
	WmBasicv = 3;
	/*	Version number of AI
	 */
	WmBasicr = 140214;
	/*	Reversion number of AI
	 */

	SleepLength = 174;
	/*	Controls how many ticks the AI sleeps between iterations.
	 */

	//	END SETTINGS

	function Start();
}

function WmLogTest::Start()
{
	AILog.Info("Welcome to WmBasic, version " + WmBasicv + ", revision " + WmBasicr + " by W. Minchin.");
	AILog.Info("Copyright © 2011-12 by W. Minchin. For more info, please visit http://blog.minchin.ca")
	AILog.Info(" ");
	AILog.Info("This AI is to test the Logging in MinchinWeb's MetaLibrary. To perform the test,");
	AILog.Info("allow the AI to run, and change it's logging level. Every 5 (or so) seconds,");
	AILog.Info("the AI will output a series of test statements to the AI console.")
	AILog.Info(" ");

	// Keep us going forever
	local tick;

	while (true) {
		tick = AIController.GetTick();
		AILog.Info("Running test at tick " + tick);
		MetaLib.Log.Note("Log Level -1", -1);
		MetaLib.Log.Note("Log Level 0", 0);
		MetaLib.Log.Note("Log Level 1", 1);
		MetaLib.Log.Note("Log Level 2", 2);
		MetaLib.Log.Note("Log Level 3", 3);
		MetaLib.Log.Note("Log Level 4", 4);
		MetaLib.Log.Note("Log Level 5", 5);
		MetaLib.Log.Note("Log Level 6", 6);
		MetaLib.Log.Note("Log Level 7", 7);
		MetaLib.Log.Note("Log default level is 3");
		MetaLib.Log.Warning("Log Warning, all levels");
		try {
			MetaLib.Log.Error("Log Error, all levels");
		} catch(all) {
			// nothing, allows calling the Error without crashing the AI
		}

		AILog.Info(" ");

		this.Sleep(SleepLength);
	}
}
