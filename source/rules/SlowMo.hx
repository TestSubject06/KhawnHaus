package rules;
import flixel.FlxG;

/**
 * ...
 * @author Zack
 */
class SlowMo implements Rule
{
	public var name(default, null):String;
	public function new() 
	{
		name = "Slow-mo";
	}
	
	public function setupRule(state:PlayState):Void 
	{
		FlxG.timeScale = 0.30;
	}
	
	public function tearDownRule(state:PlayState):Void {
		FlxG.timeScale = 1.0;
	}
	
	
	
}