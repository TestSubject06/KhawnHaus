package rules;

/**
 * ...
 * @author Zack
 */
class Tired implements Rule
{
	public var name(default, null):String;
	public function new() 
	{
		name = "Tired";
	}
	
	/* INTERFACE rules.Rule */
	
	
	public function setupRule(state:PlayState):Void 
	{
		state.khonjin.maxRunSpeed = 100;
		state.khonjin.runAcceleration = 300;
	}
	
	public function tearDownRule(state:PlayState):Void 
	{
		state.khonjin.maxRunSpeed = 200;
		state.khonjin.runAcceleration = 800;
	}
	
}