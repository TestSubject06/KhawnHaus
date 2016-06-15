package menus;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * We may want to consider having a base Menu state that extends FlxState, and then having other menus subclass that.
 * It all depends on how many menus we end up having.
 * ...
 * @author Zack
 */
class PauseMenu extends FlxSubState
{

	private var background:FlxSprite;
	private var options:FlxTypedGroup<FlxButton>;
	
	//In general we don't use the constructor for states, we use the create method.
	public function new() { super(); }
	
	override public function create():Void 
	{
		super.create();
		
		background = new FlxSprite();
		background.makeGraphic(150, 400, 0xFF000000);
		background.x = FlxG.width / 2 - background.width / 2;
		background.y = FlxG.height / 2 - background.height / 2;
		background.scrollFactor.set(0, 0);
		add(background);
		
		var text = new FlxText(background.x, background.y + 10, 150, "Pause Menu");
		text.scrollFactor.set(0, 0);
		text.alignment = FlxTextAlign.CENTER;
		add(text);
		
		options = new FlxTypedGroup();
		add(options);
		
		
		var optionsButton = new FlxButton(background.x + 25, background.y + 50, "Options", function():Void {
			openSubState(new OptionsMenu());
			FlxG.log.add("Move to options");
		});
		options.add(optionsButton);
		
		var resumeButton = new FlxButton(background.x + 25, background.y + 75, "Resume", function():Void {
			//openSubState(new OptionsMenu());
			close();
		});
		options.add(resumeButton);
		
		var quitButton = new FlxButton(background.x + 25, background.y + 100, "Quit", function():Void {
			//openSubState(new OptionsMenu());
			Sys.exit(0);
		});
		options.add(quitButton);
		
		options.forEach(function(item:FlxButton):Void {
			item.scrollFactor.set(0, 0);
		}, true);
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.ESCAPE) {
			close();
		}
	}
}