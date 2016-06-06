package player;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Zack
 */
class Khonjin extends FlxSprite
{
	private static var COYOTE_TIME:Float = 0.10; //The amount of time after a player steps off a ledge where we still allow him to jump
												//it makes things feel very nice for the player.
	private var coyoteTime:Float = 0; 
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y, null);
		makeGraphic(30, 60, 0xFFFF0000); //red rectangle
		acceleration.set(0, GlobalValues.gravity);
		maxVelocity.set(200, 400);
		drag.set(.85, .85);
	}
	
	override public function update(elapsed:Float):Void 
	{
		//Very simple movement
		if (FlxG.keys.pressed.LEFT) {
			acceleration.x = -800;
		}else if (FlxG.keys.pressed.RIGHT) {
			acceleration.x = 800;
		}else {
			acceleration.x = 0;
		}
		
		if (isTouching(FlxObject.FLOOR)) {
			coyoteTime = COYOTE_TIME;
		}else {
			coyoteTime -= elapsed;
		}
		
		//Ballistic jump
		if (coyoteTime > 0 && FlxG.keys.justPressed.UP) {
			velocity.y = -300;
		}
		
		//Slow Khawn down horizontally if he's touching the ground, and not accelerating in a horizontal direction
		if (isTouching(FlxObject.FLOOR) && acceleration.x == 0) {
			velocity.x *= GlobalValues.friction;
		}

		super.update(elapsed);
		
	}
	
}