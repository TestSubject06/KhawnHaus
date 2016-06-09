package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.util.FlxSave;
import openfl.display.Sprite;
import flixel.system.scaleModes.*;

class Main extends Sprite
{
	public function new()
	{
		super();
		
		var preferences = new FlxSave();
		preferences.bind("preferences");
		
		if (!preferences.data.initialized) {
			initialize(preferences);
		}
		
		var game = new FlxGame(960, 540, MenuState);
		addChild(game);
		
		FlxG.fullscreen = preferences.data.fullscreen;
		FlxG.scaleMode = getScaleMode(preferences.data.scaleMode);
		preferences.close();
	}
	
	private function getScaleMode(scaleMode:Int):BaseScaleMode {
		switch(scaleMode) {
			case 0:
				return new RatioScaleMode();
			case 1:
				return new FillScaleMode();
			case 2:
				return new PixelPerfectScaleMode();
			case 3:
				return new RelativeScaleMode(0.8, 0.8);
			default:
				return new RatioScaleMode();
		}
		
	}
	
	private function initialize(save:FlxSave):Void {
		save.data.scaleMode = 0;
		save.data.fullscreen = false;
		save.data.initialized = true;
		save.flush();
	}
}