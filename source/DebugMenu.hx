package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import ui.Container;
import ui.ContainerLayout;

/**
 * Allows us as debug users to create our own scenarios
 * ...
 * @author Zack
 */


 
class DebugMenu extends FlxState
{
	public var container:Container;
	public var masterContainer:Container;
	private var a:Float;
	override public function create():Void 
	{
		super.create();
		
		//Structure of the debug menu
		//Title - centered at the top
		//Level selector - select the level style
		//Primary Objective - Select the primary objective of the scenario
		//Rules - Add new rules to the list of rules - opposites are incompatible with eachother
		//Gags - Add new gags to the list of gags
		//Jokes - Add new jokes to the list of jokes
		
		//Go! - button to launch the level
		
		//Container usage
		//TODO: Finish up the menu
		masterContainer = new Container(new ContainerLayout(ContainerLayout.VERTICAL, ContainerLayout.ALIGN_CENTER, ContainerLayout.ALIGN_TOP, false), FlxG.width - 20, FlxG.height - 20, 10, 10);
		masterContainer.spacing = 30;
		masterContainer.add(new FlxText(0, 0, 300, "Scenario Editor").setFormat(16, FlxColor.WHITE, FlxTextAlign.CENTER));
		
		var contentContainer:Container = new Container(new ContainerLayout(ContainerLayout.VERTICAL, ContainerLayout.ALIGN_CENTER, ContainerLayout.ALIGN_TOP, false));
		contentContainer.spacing = 20;
		masterContainer.add(contentContainer);
		
		var rowContainer:Container = new Container(new ContainerLayout(ContainerLayout.HORIZONTAL, ContainerLayout.ALIGN_CENTER, ContainerLayout.ALIGN_CENTER, false));
		rowContainer.spacing = 25;
		rowContainer.add(new FlxText(0, 0, 200, "Level Selection", 8).setFormat(8, FlxColor.WHITE, FlxTextAlign.RIGHT));
		contentContainer.add(rowContainer);
		
		var controlsContainer:Container = new Container(new ContainerLayout(ContainerLayout.HORIZONTAL, ContainerLayout.ALIGN_LEFT, ContainerLayout.ALIGN_CENTER, false));
		controlsContainer.add(new FlxButton(0, 0, "<-"));
		controlsContainer.add(new FlxText(0, 0, 80, "Flat House", 8).setFormat(8, FlxColor.WHITE, FlxTextAlign.CENTER));
		controlsContainer.add(new FlxButton(0, 0, "->"));
		rowContainer.add(controlsContainer);
		
		add(masterContainer);
		
		
		//container = new Container(new ContainerLayout(ContainerLayout.HORIZONTAL, ContainerLayout.ALIGN_CENTER, ContainerLayout.ALIGN_CENTER, false), 400, 200, 50, 250);
		//container.lock();
		//container.add(new FlxText(0, 0, 35, "Blab"));
		//container.add(new FlxText(0, 0, 35, "Blab2"));
		//container.add(new FlxText(0, 0, 35, "Blab3"));
		//container.add(new FlxText(0, 0, 70, "Blablablablab"));
		//container.add(new FlxText(0, 0, 35, "Blab5"));
		//container.add(new FlxText(0, 0, 35, "Blab6"));
		//container.add(new FlxText(0, 0, 35, "Blab7"));
		//container.unlock();
		//add(container);
		
		var goButton = new FlxButton(FlxG.width / 2 - 50, FlxG.height - 20, "Go", function():Void {
			FlxG.switchState(new PlayState());
		});
		add(goButton);
		
	}
	
	override public function draw():Void 
	{
		super.draw();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.justReleased.Q) {
			container.layout.horizontalAlignment = ContainerLayout.ALIGN_LEFT;
		}
		if (FlxG.keys.justReleased.W) {
			container.layout.horizontalAlignment = ContainerLayout.ALIGN_CENTER;
		}
		if (FlxG.keys.justReleased.E) {
			container.layout.horizontalAlignment = ContainerLayout.ALIGN_RIGHT;
		}
		if (FlxG.keys.justReleased.A) {
			container.layout.verticalAlignment = ContainerLayout.ALIGN_TOP;
		}
		if (FlxG.keys.justReleased.S) {
			container.layout.verticalAlignment = ContainerLayout.ALIGN_CENTER;
		}
		if (FlxG.keys.justReleased.D) {
			container.layout.verticalAlignment = ContainerLayout.ALIGN_BOTTOM;
		}
		if (FlxG.keys.justReleased.ONE) {
			container.layout.direction = ContainerLayout.HORIZONTAL;
		}
		if (FlxG.keys.justReleased.TWO) {
			container.layout.direction = ContainerLayout.VERTICAL;
		}
		super.update(elapsed);
	}
	
}