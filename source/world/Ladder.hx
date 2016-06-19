package world;

import flixel.FlxSprite;
import Math;

/**
 * ...
 * @author Marat
 */
class Ladder extends FlxSprite
{
    private var ladder:Array<Float> = [0, 0, 0, 0];
    private var directionalVector:Array<Float> = [0, 0];
	
	public function new(X:Float, Y:Float, H:Int, W:Int, dX:Float, dY:Float) 
	{
		super(X, Y, null);
		makeGraphic(H, W, 0xFF0000FF); //blue rectangle
		ladder = [X + W / 2, Y, X + H + W / 2, Y + H];
		directionalVector = [dX/Math.sqrt(dX*dX+dY*dY),dY/Math.sqrt(dX*dX+dY*dY)];
	}
	
}