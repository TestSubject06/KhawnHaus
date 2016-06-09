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
import player.Khonjin;
import world.Ladder;

class PlayState extends FlxState
{
	private var walls:FlxGroup;
	private var floors:FlxGroup;
	private var ladders:FlxGroup;
	private var background:FlxSprite;
	private var khonjin:Khonjin;
	private var level:FlxTilemap;
	
	//visual layering
	private var backgroundLayer:FlxGroup;
	private var entitiesLayer:FlxGroup;
	private var foregroundLayer:FlxGroup;
	private var uiLayer:FlxGroup;
	override public function create():Void
	{		
		
		//We shouldn't be handling resolution like this.
		FlxG.camera.width = 1920;
		FlxG.camera.height = 1080;
		FlxG.camera.x = -560;
		FlxG.camera.y = -315;
		FlxG.camera.zoom = FlxG.height / 1080;
		
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
		
		khonjin = new Khonjin(50, 900);
		entitiesLayer.add(khonjin);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(walls, khonjin);
		FlxG.collide(floors, khonjin);
		FlxG.collide(level, khonjin);
		
		if (FlxG.keys.justPressed.ESCAPE) {
			Sys.exit(0);
		}
	}
}
