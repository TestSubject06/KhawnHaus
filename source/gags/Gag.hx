package gags;

/**
 * ...
 * @author Zack
 */
interface Gag
{
	public var name(default, null):String;
	public function setupGag(state:PlayState):Void;
	public function tearDownGag(state:PlayState):Void;
	public function update(elapsed:Float):Void;
	public function draw():Void;
}