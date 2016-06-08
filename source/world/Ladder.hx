package world;

import flixel.FlxSprite;

/**
 * ...
 * @author Marat
 */
class Ladder extends FlxSprite
{

	public function new(X:Float, Y:Float, H:Int, W:Int) 
	{
		super(X, Y, null);
		makeGraphic(H, W, 0xFF0000FF); //blue rectangle
	}
	
}