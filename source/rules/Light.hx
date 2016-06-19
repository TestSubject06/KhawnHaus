package rules;

/**
 * ...
 * @author Zack
 */
class Light implements Rule
{
	public var name(default, null):String;
	public function new() 
	{
		name = "Light";
	}
	
	/* INTERFACE rules.Rule */
	
	
	public function setupRule(state:PlayState):Void 
	{
		state.khonjin.ballisticJumpVelocity = 450;
	}
	
	public function tearDownRule(state:PlayState):Void 
	{
		state.khonjin.ballisticJumpVelocity = 300;
	}
	
}