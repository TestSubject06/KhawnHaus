package rules;
import flixel.FlxG;

/**
 * ...
 * @author Zack
 */
class RuleFactory
{
	private static var ruleMap:Map<String, Class<Rule>>;
	
	//TODO: Keep this updated as new rules are added
	private static var rules:Array<Class<Rule>> = [SlowMo, Speedy, Light, Heavy, Caffeinated, Tired];
	
	public static function getRuleByName(name:String):Rule {
		if (ruleMap == null) {
			buildRuleMap();
		}
		return Type.createInstance(ruleMap.get(name), []);
	}
	
	public static function getAllRuleNames():Array<String> {
		if (ruleMap == null) {
			buildRuleMap();
		}
		var ret:Array<String> = [];
		for (key in ruleMap.keys()) {
			ret.push(key);
		}
		return ret;
	}
	
	public static function buildRuleMap():Void {
		ruleMap = new Map<String, Class<Rule>>();
		for (rule in rules) {
			ruleMap.set(Type.createInstance(rule, []).name, rule);
		}
	}
}