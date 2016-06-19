package rules;
import flixel.FlxG;

/**
 * ...
 * @author Zack
 */
class Speedy implements Rule
{
	public var name(default, null):String;
	public function new() 
	{
		name = "Speedy";
	}
	
	/* INTERFACE rules.Rule */
	
	
	public function setupRule(state:PlayState):Void 
	{
		FlxG.timeScale = 3.0;
	}
	
	public function tearDownRule(state:PlayState):Void 
	{
		FlxG.timeScale = 1.0;
	}
	
}