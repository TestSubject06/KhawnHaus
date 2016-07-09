package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import jokes.Joke;
import jokes.JokeFactory;
import jokes.ThisGame;
import rules.RuleFactory;
import gags.GagFactory;
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
	
	private var scenario:Scenario;
	override public function create():Void 
	{
		super.create();
		scenario = new Scenario();
		
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
		var options:Map<String, Array<String>> = new Map();
		trace(RuleFactory.getAllRuleNames());
		options.set("Level Type", ["Old", "New"]);
		options.set("Primary Objective", ["Dunk", "Cross", "Board"]);
		options.set("Rules", RuleFactory.getAllRuleNames());
		options.set("Gags", GagFactory.getAllGagNames());
		options.set("Jokes", JokeFactory.getAllJokeNames());
		var sections:Array<Dynamic> = [ { title:"Level Type", type:"single_select" }, { title:"Primary Objective", type:"single_select" }, { title:"Rules", type:"multi_select" }, 
										{title:"Gags", type:"multi_select"}, {title:"Jokes", type:"multi_select"}];
		
		masterContainer = new Container(new ContainerLayout(ContainerLayout.VERTICAL, ContainerLayout.ALIGN_CENTER, ContainerLayout.ALIGN_TOP, false), FlxG.width - 20, FlxG.height - 20, 10, 10);
		masterContainer.spacing = 30;
		masterContainer.add(new FlxText(0, 0, 300, "Scenario Editor").setFormat(16, FlxColor.WHITE, FlxTextAlign.CENTER));
		
		var contentContainer:Container = new Container(new ContainerLayout(ContainerLayout.VERTICAL, ContainerLayout.ALIGN_CENTER, ContainerLayout.ALIGN_TOP, false));
		contentContainer.spacing = 20;
		masterContainer.add(contentContainer);
		
		for (section in sections) {
			var rowContainer:Container = new Container(new ContainerLayout(ContainerLayout.HORIZONTAL, ContainerLayout.ALIGN_CENTER, ContainerLayout.ALIGN_CENTER, false));
			rowContainer.spacing = 25;
			var controlsContainer:Container = new Container(new ContainerLayout(ContainerLayout.HORIZONTAL, ContainerLayout.ALIGN_LEFT, ContainerLayout.ALIGN_CENTER, false));
			var extraRow:Container = new Container(new ContainerLayout(ContainerLayout.HORIZONTAL, ContainerLayout.ALIGN_CENTER, ContainerLayout.ALIGN_CENTER, false));
			
			var localOptions = options.get(section.title);
			var addedOptions:Array<String> = [];
			
			var controlsText = new FlxText(0, 0, 80, localOptions[0], 8).setFormat(8, FlxColor.WHITE, FlxTextAlign.CENTER);
			
			controlsContainer.add(new FlxButton(0, 0, "<-", function():Void {
				var newString = localOptions[FlxMath.wrap(localOptions.indexOf(controlsText.text) - 1, 0, localOptions.length - 1)];
				controlsText.text = newString;
				if (addedOptions.indexOf(newString) > -1) {
					controlsText.color = FlxColor.RED;					
				} else {
					controlsText.color = FlxColor.WHITE;
				}
				updateScenario(section.title, newString);
			}));
			controlsContainer.add(controlsText);
			controlsContainer.add(new FlxButton(0, 0, "->", function():Void {
				var newString = localOptions[FlxMath.wrap(localOptions.indexOf(controlsText.text) + 1, 0, localOptions.length - 1)];
				controlsText.text = newString;
				if (addedOptions.indexOf(newString) > -1) {
					controlsText.color = FlxColor.RED;					
				} else {
					controlsText.color = FlxColor.WHITE;
				}
				updateScenario(section.title, newString);
			}));
			if (section.type == "multi_select") {
				controlsContainer.add(new FlxButton(0, 0, "Add", function():Void {
					if (addedOptions.indexOf(controlsText.text) == -1) {
						extraRow.add(new FlxText(0, 0, 0, controlsText.text));
						addedOptions.push(controlsText.text);
						controlsText.color = FlxColor.RED;
						addToScenario(section.title, controlsText.text);
					}
				}));
			}
			
			rowContainer.add(new FlxText(0, 0, controlsContainer.width, section.title, 8).setFormat(8, FlxColor.WHITE, FlxTextAlign.RIGHT));
			rowContainer.add(controlsContainer);
			contentContainer.add(rowContainer);
			if (section.type == "multi_select") {
				contentContainer.add(extraRow);
			}
		}
		add(masterContainer);
		
		var goButton = new FlxButton(FlxG.width / 2 - 50, FlxG.height - 20, "Go", function():Void {
			FlxG.switchState(new PlayState(scenario));
		});
		add(goButton);
		
		#if flash
			
		#else
			FlxG.sound.playMusic(AssetPaths.robocop3__ogg);
		#end
	}
	
	private function updateScenario(category:String, value:String):Void {
		switch(category) {
			case "Level Type":
				scenario.levelType = ["Old", "New"].indexOf(value);
			
			case "Primary Objective":
				scenario.objective = ["Dunk", "Cross", "Board"].indexOf(value);
			
			default:
				//Do nothing.
		}
	}
	
	private function addToScenario(category:String, value:String) {
		switch(category) {
			case "Rules":
				scenario.rules.push(RuleFactory.getRuleByName(value));
			
			case "Gags":
				scenario.gags.push(GagFactory.getGagByName(value));
				
			case "Jokes":
				scenario.jokes.push(JokeFactory.getJokeByName(value));
			
			default:
				//Do nothing.
		}
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