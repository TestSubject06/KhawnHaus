package gags;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import player.Khonjin;

/**
 * ...
 * @author Zack
 */
class PipeBlast implements Gag
{
	public var name(default, null):String;
	public var pipe:FlxSprite;
	public var blast:FlxSprite;
	public var trigger:FlxObject;
	public var khonjin:Khonjin;
	public var fire:Bool = false;
	public var phase:Int = 0;
	public var timer:Float = 0;
	public var emitter:FlxEmitter;
	public function new() 
	{
		name = "Pipe Blast";
	}
	
	/* INTERFACE gags.Gag */
	
	
	public function setupGag(state:PlayState):Void 
	{
		blast = new FlxSprite(FlxG.width - 60, FlxG.height - 120);
		blast.loadGraphic(AssetPaths.laserFrames__png, true, 1, 100);
		blast.scale.x = 1000;
		blast.animation.add("blast", [2, 1, 4, 3, 0], 60);
		blast.animation.play("blast");
		blast.updateHitbox();
		blast.x -= blast.width;
		blast.visible = false;
		blast.scale.y = 0.01;
		state.entitiesLayer.add(blast);
		
		pipe = new FlxSprite(FlxG.width - 60, FlxG.height - 120, AssetPaths.Pipe__png);
		state.entitiesLayer.add(pipe);
		
		trigger = new FlxObject(pipe.x - 200, pipe.y, 200, 100);
		
		khonjin = state.khonjin;
		
		//TODO: Emitter stuff
		emitter = new FlxEmitter();
		emitter.alpha.set(1, 1, 0, 0);
		emitter.velocity.set( -5, -40, -30, -60, -40, -80, -60, -120);
	}
	
	public function tearDownGag(state:PlayState):Void 
	{
		state.entitiesLayer.remove(pipe, true);
		state.entitiesLayer.remove(blast, true);
		
		pipe.destroy();
		pipe = null;
		blast.destroy();
		blast = null;
		trigger.destroy();
		trigger = null;
	}
	
	public function update(elapsed:Float):Void 
	{
		FlxG.overlap(trigger, khonjin, function(trigger:FlxObject, khonjin:Khonjin):Void {
			FlxG.log.add("Fire");
			fire = true;
			blast.visible = true;
			//TODO: Kill khonjin.
		});
		
		if (fire) {
			if (phase == 0) {
				blast.scale.y += .35;
				if (blast.scale.y >= 1.0) {
					phase = 1;
					blast.scale.y = 1.0;
				}
			}else if (phase == 1) {
				timer += elapsed;
				if (timer > 2.4) {
					phase = 2;
				}
			}else if (phase == 2) {
				blast.scale.y -= 0.04;
				if (blast.scale.y <= 0.0) {
					phase = 3;
					blast.scale.y = 0;
					blast.visible = false;
				}
			}
			//TODO: Emitter for some little biddies.
		}
	}
	
	public function draw():Void 
	{
		
	}
	
}