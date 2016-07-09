package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
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
	public var backgroundLayer:FlxGroup;
	public var entitiesLayer:FlxGroup;
	public var foregroundLayer:FlxGroup;
	public var uiLayer:FlxGroup;
	
	private var jokes:Array<Joke>;
	private var scenario:Scenario;
	private var khonjinSpawn:FlxPoint;
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
		super.create();
		
		
		backgroundLayer = new FlxGroup();
		entitiesLayer = new FlxGroup();
		foregroundLayer = new FlxGroup();
		uiLayer = new FlxGroup();
		add(backgroundLayer);
		add(entitiesLayer);
		add(foregroundLayer);
		add(uiLayer);
		
		var levelCreator = new FlxOgmoLoader(getLevelFromScenario(scenario));
		level = levelCreator.loadTilemap(AssetPaths.autotiles__png, 32, 32, "TilesLayer");
		add(level);
		FlxG.worldBounds.set( -200, -200, levelCreator.width + 400, levelCreator.height + 400);
		
		floors = new FlxGroup();
		walls = new FlxGroup();
		
		levelCreator.loadEntities(function(itemType:String, itemData:Xml):Void {
			switch(itemType.toLowerCase()) {
				case "platform":
					var newPlatform:FlxSprite = new FlxSprite(Std.parseFloat(itemData.get("x")), Std.parseFloat(itemData.get("y")));
					newPlatform.makeGraphic(Std.parseInt(itemData.get("width")), Std.parseInt(itemData.get("height")), 0xFFFF0000);
					newPlatform.immovable = true;
					newPlatform.visible = false;
					floors.add(newPlatform);
					entitiesLayer.add(newPlatform);
				
				case "wall":
					var newPlatform:FlxSprite = new FlxSprite(Std.parseFloat(itemData.get("x")), Std.parseFloat(itemData.get("y")));
					newPlatform.makeGraphic(Std.parseInt(itemData.get("width")), Std.parseInt(itemData.get("height")), 0xFFFF0000);
					newPlatform.immovable = true;
					newPlatform.visible = false;
					walls.add(newPlatform);
					entitiesLayer.add(newPlatform);
				
				case "background1":
					background = new FlxSprite(Std.parseFloat(itemData.get("x")), Std.parseFloat(itemData.get("y")), AssetPaths.backgroundflat__png);
					backgroundLayer.add(background);
				
				case "background2":
					background = new FlxSprite(Std.parseFloat(itemData.get("x")), Std.parseFloat(itemData.get("y")), AssetPaths.khonjin_bg6__png);
					background.origin.set(0, 0);
					background.scale.set(2, 2);
					backgroundLayer.add(background);
					
				case "khonjinspawn":
					khonjinSpawn = new FlxPoint(Std.parseFloat(itemData.get("x")), Std.parseFloat(itemData.get("y")));
			}
		}, "EntitiesLayer");
		
		
		ladders = new FlxGroup();
		ladder1 = new Ladder(1739, 632, 111, 406, 1, 0);
		ladder1.immovable = true;
		ladders.add(ladder1);
		backgroundLayer.add(ladders);
		
		khonjin = new Khonjin(khonjinSpawn.x, khonjinSpawn.y);
		entitiesLayer.add(khonjin);
		
		FlxG.camera.follow(khonjin);
		FlxG.camera.setScrollBounds(0, levelCreator.width, 0, levelCreator.height);
		
		for (joke in scenario.jokes) {
			joke.setupJoke(this);
		}
		for (gag in scenario.gags) {
			gag.setupGag(this);
		}
		for (rule in scenario.rules) {
			rule.setupRule(this);
		}
		
		#if flash
			FlxG.sound.playMusic(AssetPaths.Khonjin_House_The_Movie_2_The_Game__mp3);
		#else
			FlxG.sound.playMusic(AssetPaths.Khonjin_House_The_Movie_2_The_Game__ogg);
		#end
	}
	
	private function getLevelFromScenario(scenario:Scenario):Dynamic {
		switch(scenario.levelType) {
			case 0:
				return AssetPaths.Level1__oel;
			case 1:
				return AssetPaths.TieredHouse__oel;
			default:
				return AssetPaths.TieredHouse__oel;
		}
		return null;
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
		for (gag in scenario.gags) {
			gag.update(elapsed);
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
