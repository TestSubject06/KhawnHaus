package;
import gags.Gag;
import jokes.Joke;
import rules.Rule;
/**
 * ...
 * @author Zack
 */
class Scenario
{
	public var levelType:Int;
	public var objective:Int;
	
	
	
	//SEMANTICS:
	//The difference between a Rule, Gag, and a Joke:
	//A Rule is something that changes the rules of the world/engine
	//For example: Slow-motion, Heavy Khonjin, Underwater physics
	//Rules will get access to the full state of the game, and will run only once before the player
	//gets control of their character
	
	//A Gag is an in-game object that will be triggered, often to the effect of killing Khonjin
	//For example: Moving pit, Pipe Blast, non-colliding floor on the pit level
	//Gags will have access to the full state of the game, and will run in the update loop
	
	//A Joke is something that changes what the player sees in the game
	//For example: Playing as Gino, Earthquake mode, rotating camera
	//Jokes will get access to the full state of the game, and will run in the update loop
	
	public var rules:Array<Rule>;
	public var gags:Array<Gag>;
	public var jokes:Array<Joke>;
	public function new() 
	{
		rules = [];
		gags = [];
		jokes = [];
	}
	
}