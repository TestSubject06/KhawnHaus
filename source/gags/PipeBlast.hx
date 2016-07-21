package gags;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
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
	public var burnGroup:FlxGroup;
	public var deadKhonjinFrame:FlxSprite;
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
		blast.animation.add("blast", [2, 1, 4, 3, 0], 58);
		blast.animation.play("blast");
		blast.updateHitbox();
		blast.x -= blast.width;
		blast.visible = false;
		blast.scale.y = 0.01;
		state.foregroundLayer.add(blast);
		
		pipe = new FlxSprite(FlxG.width - 60, FlxG.height - 120, AssetPaths.Pipe__png);
		state.entitiesLayer.add(pipe);
		
		trigger = new FlxObject(pipe.x - 200, pipe.y, 200, 100);
		
		khonjin = state.khonjin;
		
		emitter = new FlxEmitter();
		emitter.alpha.set(1, 1, 0, 0);
		emitter.velocity.set( -5, -40, -30, -60, -40, -80, -60, -120);
		emitter.setSize(1000, 5);
		emitter.x = blast.x;
		emitter.y = blast.y + 60;
		emitter.launchMode = FlxEmitterMode.SQUARE;
		emitter.lifespan.set(1, 2);
		state.foregroundLayer.add(emitter);
		
		var colorPalette = [FlxColor.fromRGB(223, 57, 1), FlxColor.fromRGB(254, 252, 70), FlxColor.fromRGB(254, 174, 34)];
		for (i in 0...100) {
			var particle:FlxParticle = new FlxParticle();
			particle.makeGraphic(3, 3, colorPalette[FlxG.random.int(0, 2)]);
			emitter.add(particle);
		}
		
		burnGroup = new FlxGroup();
		state.entitiesLayer.add(burnGroup);
		burnGroup.exists = false;
		
		deadKhonjinFrame = new FlxSprite();
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
		emitter.destroy();
		emitter = null;
	}
	
	public function update(elapsed:Float):Void 
	{
		FlxG.log.add(deadKhonjinFrame.pixelsOverlapPoint(new FlxPoint(FlxG.mouse.x, FlxG.mouse.y)));
		if(trigger.exists){
			FlxG.overlap(trigger, khonjin, function(trigger:FlxObject, khonjin:Khonjin):Void {
				FlxG.log.add("Fire");
				fire = true;
				blast.visible = true;
				//TODO: Kill khonjin.
				deadKhonjinFrame.x = khonjin.x;
				deadKhonjinFrame.y = khonjin.y;
				deadKhonjinFrame.makeGraphic(Math.ceil(khonjin.width), Math.ceil(khonjin.height), 0x0, true);
				deadKhonjinFrame.stamp(khonjin, Math.floor(-khonjin.offset.x), Math.floor(-khonjin.offset.y));
				
				khonjin.kill();
				
				trigger.exists = false;
			});
		}
		
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
					burnGroup.exists = true;
				}
				//try to create a couple of burnt particle on where khonjin was.
				for(i in 0...4){
					var point:FlxPoint = new FlxPoint(deadKhonjinFrame.x + Math.floor(Math.random() * deadKhonjinFrame.width), deadKhonjinFrame.y + Math.floor(Math.random() * deadKhonjinFrame.height));
					if (deadKhonjinFrame.pixelsOverlapPoint(point)) {
						var burnt = new FlxParticle();
						burnt.x = point.x - 2;
						burnt.y = point.y - 2;
						burnt.makeGraphic(4, 4, 0xFF333333);
						burnt.acceleration.set(Math.random() * -2, Math.random() * -2);
						burnt.exists = true;
						burnt.alive = true;
						burnGroup.add(burnt);
					}
				}
			}else if (phase == 2) {
				blast.scale.y -= 0.04;
				if (blast.scale.y <= 0.0) {
					phase = 3;
					blast.scale.y = 0;
					blast.visible = false;
				}
			}else if(phase == 3){
				emitter.start();
				phase++;
			}
		}
	}
	
	public function draw():Void 
	{
		
	}
	
}