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
	
	private var canClimb:Bool = false;
	private var climbing:Bool = false;
	private var ladder:Array<Float> = [0, 0, 0, 0]; 
	
	public var ballisticJumpVelocity:Float = 300;
	public var maxRunSpeed(default, set):Float = 200;
	public var runAcceleration:Float = 800;
	public var maxFallSpeed(default, set):Float = 400;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y, AssetPaths.khonjinsprite__png);
		
		//makeGraphic(103, 143, 0xFFFF0000); //red rectangle
		acceleration.set(0, GlobalValues.gravity);
		maxVelocity.set(maxRunSpeed, maxFallSpeed);
		drag.set(.85, .85);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		scale.set(0.6, 0.6);
		updateHitbox();
	}
	
	override public function update(elapsed:Float):Void 
	{
		//Very simple movement
		if (FlxG.keys.pressed.LEFT) {
			facing = FlxObject.LEFT;
			acceleration.x = -runAcceleration;
		}else if (FlxG.keys.pressed.RIGHT) {
			facing = FlxObject.RIGHT;
			acceleration.x = runAcceleration;
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
			velocity.y = -ballisticJumpVelocity;
			coyoteTime = 0;//prevents super fast double jumps
		}
		
		//Slow Khawn down horizontally if he's touching the ground, and not accelerating in a horizontal direction
		if (isTouching(FlxObject.FLOOR) && acceleration.x == 0) {
			velocity.x *= GlobalValues.friction;
		}

		//Attempt at ladders needs more reading
		
		//if overlapping with a Ladder
		//canClimb = true else false
		//ladder = Ladder.ladder
		
		//if canClimb is true and Up/Down were pressed
		//snap position to closest point on Ladder's line (vector maths)
		//climbing = true
		
		//if climbing is true and Up/Down were pressed
		//suppress normal movement
		//determine normalised directional vector of ladder and add to velocity
		
		//if center position is within 5 pixels of either endpoint of ladder
		//climbing = false
		
		super.update(elapsed);
		
	}
	
	function set_maxRunSpeed(value:Float):Float 
	{
		maxRunSpeed = value;
		maxVelocity.set(maxRunSpeed, maxFallSpeed);
		return maxRunSpeed;
	}
	
	function set_maxFallSpeed(value:Float):Float 
	{
		maxFallSpeed = value;
		maxVelocity.set(maxRunSpeed, maxFallSpeed);
		return maxFallSpeed;
	}
	
}