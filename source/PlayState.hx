package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import jokes.Joke;
import jokes.ThisGame;
import menus.PauseMenu;
import player.Khonjin;
import rules.Rule;
import rules.SlowMo;
import rules.Speedy;
import world.Ladder;

class PlayState extends FlxState
{
	public var walls:FlxGroup;
	public var floors:FlxGroup;
	public var ladders:FlxGroup;
	public var background:FlxSprite;
	public var ladder1:Ladder;
	public var khonjin:Khonjin;
	public var level:FlxTilemap;
	
	//visual layering
	private var backgroundLayer:FlxGroup;
	private var entitiesLayer:FlxGroup;
	private var foregroundLayer:FlxGroup;
	private var uiLayer:FlxGroup;
	
	private var jokes:Array<Joke>;
	private var scenario:Scenario;
	public function new(scenario:Scenario) {
		super();
		if (scenario == null) {
			this.scenario = new Scenario();
		}else {
			this.scenario = scenario;
		}
	}
	override public function create():Void
	{		
		
		//We shouldn't be handling resolution like this.
		super.create();
		FlxG.worldBounds.set( -100, -100, 1920 + 200, 1080 + 200);
		
		backgroundLayer = new FlxGroup();
		entitiesLayer = new FlxGroup();
		foregroundLayer = new FlxGroup();
		uiLayer = new FlxGroup();
		add(backgroundLayer);
		add(entitiesLayer);
		add(foregroundLayer);
		add(uiLayer);
		
		var levelCreator = new FlxOgmoLoader(AssetPaths.Level1__oel);
		level = levelCreator.loadTilemap(AssetPaths.autotiles__png, 32, 32, "TilesLayer");
		add(level);
		
		floors = new FlxGroup();
		
		levelCreator.loadEntities(function(itemType:String, itemData:Xml):Void {
			switch(itemType.toLowerCase()) {
				case "platform":
					var newPlatform:FlxSprite = new FlxSprite(Std.parseFloat(itemData.get("x")), Std.parseFloat(itemData.get("y")));
					newPlatform.makeGraphic(Std.parseInt(itemData.get("width")), Std.parseInt(itemData.get("height")), 0xFFFF0000);
					newPlatform.immovable = true;
					floors.add(newPlatform);
					entitiesLayer.add(newPlatform);
				
				case "background1":
					background = new FlxSprite(Std.parseFloat(itemData.get("x")), Std.parseFloat(itemData.get("y")), AssetPaths.backgroundflat__png);
					backgroundLayer.add(background);
			}
		}, "EntitiesLayer");
		
		
		ladders = new FlxGroup();
		ladder1 = new Ladder(1739, 632, 111, 406, 1, 0);
		ladder1.immovable = true;
		ladders.add(ladder1);
		backgroundLayer.add(ladders);
		
		khonjin = new Khonjin(50, 900);
		entitiesLayer.add(khonjin);
		
		FlxG.camera.follow(khonjin);
		FlxG.camera.setScrollBounds(0, 1920, 0, 1080);
		
		for (joke in scenario.jokes) {
			joke.setupJoke(this);
		}
		//for (gag in scenario.gags) {
			//.setupJoke(this);
		//}
		for (rule in scenario.rules) {
			rule.setupRule(this);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(walls, khonjin);
		FlxG.collide(floors, khonjin);
		FlxG.collide(level, khonjin);
		
		if (FlxG.keys.justPressed.ESCAPE) {
			openSubState(new PauseMenu());
		}
		
		for (joke in scenario.jokes) {
			joke.update(elapsed);
		}
	}
	override public function draw():Void 
	{
		super.draw();
		for (joke in scenario.jokes) {
			joke.draw();
		}
	}
}
