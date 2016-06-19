package rules;

/**
 * ...
 * @author Zack
 */
interface Rule
{
	public var name(default, null):String;
	public function setupRule(state:PlayState):Void;
	public function tearDownRule(state:PlayState):Void;
}