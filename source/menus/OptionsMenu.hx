package menus;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.scaleModes.BaseScaleMode;
import flixel.system.scaleModes.FillScaleMode;
import flixel.system.scaleModes.PixelPerfectScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.system.scaleModes.RelativeScaleMode;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.util.FlxSave;

/**
 * ...
 * @author Zack
 */
class OptionsMenu extends FlxSubState
{
	private static var scaleModes:Array<String> = ["Maintain Aspect Ratio", "Fill Screen", "Pixel Perfect Scaling", "Letterboxed"];
	private var options:FlxTypedGroup<FlxButton>;
	private var scaleModeText:FlxText;
	private var fullScreenModeText:FlxText;
	
	public function new(BGColor:FlxColor=0) 
	{
		super(0xFF000000);
		
		var save = new FlxSave();
		save.bind("preferences");
		
		var text = new FlxText(FlxG.width/2 - 40, 10, 150, "Options Menu");
		text.scrollFactor.set(0, 0);
		add(text);
		
		options = new FlxTypedGroup();
		add(options);
		
		var scaleMode = save.data.scaleMode;
		var scaleModeText = new FlxText(FlxG.width/2 - 40, 60, 150, "Scale Mode is: " + scaleModes[scaleMode]);
		scaleModeText.scrollFactor.set(0, 0);
		add(scaleModeText);
		
		var button1 = new FlxButton(FlxG.width/2 - 40, 75, "Scale Mode", function():Void {
			scaleMode = FlxMath.wrap(++scaleMode, 0, 3);
			FlxG.scaleMode = getScaleMode(scaleMode);
			scaleModeText.text = "Scale Mode is: " + scaleModes[scaleMode];
			save.data.scaleMode = scaleMode;
			save.flush();
		});
		options.add(button1);
		
		var button2 = new FlxButton(FlxG.width/2 - 40, 125, "Fullscreen", function():Void {
			FlxG.fullscreen = !FlxG.fullscreen;
			if (!FlxG.fullscreen) {
				FlxG.resizeWindow(FlxG.width, FlxG.height);
			}
			save.data.fullscreen = FlxG.fullscreen;
			save.flush();
		});
		options.add(button2);
		
		var button3 = new FlxButton(FlxG.width / 2 - 40, 175, "Exit Options", function():Void {
			save.close();
			close();
		});
		options.add(button3);
		
		options.forEach(function(item:FlxButton):Void {
			item.scrollFactor.set(0, 0);
		}, true);
		
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
	
}