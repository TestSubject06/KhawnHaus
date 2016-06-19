package rules;

/**
 * ...
 * @author Zack
 */
class Caffeinated implements Rule
{
	public var name(default, null):String;
	public function new() 
	{
		name = "Caffeinated";
	}
	
	/* INTERFACE rules.Rule */
	
	
	public function setupRule(state:PlayState):Void 
	{
		state.khonjin.maxRunSpeed = 400;
		state.khonjin.runAcceleration = 1200;
	}
	
	public function tearDownRule(state:PlayState):Void 
	{
		state.khonjin.maxRunSpeed = 200;
		state.khonjin.runAcceleration = 800;
	}
	
}