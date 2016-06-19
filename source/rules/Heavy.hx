package rules;

/**
 * ...
 * @author Zack
 */
class Heavy implements Rule
{
	public var name(default, null):String;
	public function new() 
	{
		name = "Heavy";
	}
	
	/* INTERFACE rules.Rule */
	
	
	public function setupRule(state:PlayState):Void 
	{
		state.khonjin.ballisticJumpVelocity = 150;
	}
	
	public function tearDownRule(state:PlayState):Void 
	{
		state.khonjin.ballisticJumpVelocity = 300;
	}
	
}