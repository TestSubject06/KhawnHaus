package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;

class MenuState extends FlxState
{
	
	override public function create():Void
	{
		super.create();
		
		add(new FlxButton(FlxG.width / 2, FlxG.height / 2, "Khawn Haus", function() {
			FlxG.switchState(new PlayState());
		}));
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ESCAPE) {
			Sys.exit(0);
		}
	}
}
