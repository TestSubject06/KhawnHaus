package jokes;

/**
 * Semantics of a joke:
 * A joke is some sort of screen intrusion, or voice clip, or other non-threatening, non-game impacting joke
 * ...
 * @author Zack
 */
interface Joke
{
	public var name(default, null):String;
	public function setupJoke(state:PlayState):Void;
	public function tearDownJoke(state:PlayState):Void;
	public function update(elapsed:Float):Void;
	public function draw():Void;
}