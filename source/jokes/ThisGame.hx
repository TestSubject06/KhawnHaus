package jokes;
import flixel.FlxG;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;

/**
 * ...
 * @author Zack
 */
class ThisGame implements Joke
{
	public var name(default, null):String;
	
	private var text:FlxText;
	private var underText:FlxText;
	private var colorCycle:Array<Int> = [0xFFFFFFFF, 0xFF00FFFF, 0xFF0000FF, 0xFFFF00FF, 0xFFFF0000, 0xFFFFFF00, 0xFF00FF00];
	private var colorCycleIndex:Int = 0;
	private var anchorX:Float;
	private var anchorY:Float;
	public function new() 
	{
		name = "This Game";
	}
	
	/* INTERFACE jokes.Joke */
	
	
	public function setupJoke(state:PlayState):Void 
	{
		text = new FlxText(0, 0, 0, "THIS GAME IS A JOKE", 32);
		underText = new FlxText(0, 0, 0, "THIS GAME IS A JOKE", 32);
		
		text.x = (anchorX = FlxG.width / 2 - text.width / 2);
		text.y = (anchorY = 20);
		
		underText.x = FlxG.width / 2 - text.width / 2;
		underText.y = 20;
		
		underText.color = underText.color.getDarkened();
		text.scrollFactor.set(0, 0);
		underText.scrollFactor.set(0, 0);
	}
	
	public function tearDownJoke(state:PlayState):Void 
	{
		underText = null;
		text = null;
		colorCycle = null;
	}
	
	public function update(elapsed:Float):Void 
	{
		underText.update(elapsed);
		text.update(elapsed);
		
		colorCycleIndex = FlxMath.wrap(colorCycleIndex +1, 0, colorCycle.length -1);
		text.color = FlxColor.fromInt(colorCycle[colorCycleIndex]);
		underText.color = text.color.getDarkened(0.5);
		
		text.x = Math.random() * 10 - 5 + anchorX;
		text.y = Math.random() * 10 - 5 + anchorY;
		underText.x = Math.random() * 10 - 5 + anchorX;
		underText.y = Math.random() * 10 - 5 + anchorY;
	}
	
	public function draw():Void 
	{
		underText.draw();
		text.draw();
	}
	
}