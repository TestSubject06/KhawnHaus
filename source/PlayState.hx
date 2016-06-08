package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
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
	override public function create():Void
	{		
		FlxG.camera.width = 1920;
		FlxG.camera.height = 1080;
		FlxG.camera.x = -560;
		FlxG.camera.y = -315;
		FlxG.camera.zoom = FlxG.height / 1080;
		
		super.create();
		FlxG.worldBounds.set( -100, -100, 1920 + 200, 1080 + 200);
		
		background = new FlxSprite(0, 0, AssetPaths.backgroundflat__png);
		background.origin.set(0,0); // Resize from top-left corner
		add(background);
		
		walls = new FlxGroup();
		var leftwall:FlxObject = new FlxObject( -32, -1080, 32, 2160); // values taken from Adobe Fireworks vector bounds in background-meta.png
		    leftwall.immovable = true;
		var rigtwall:FlxObject = new FlxObject(1920, -1080, 32, 2160);
		    rigtwall.immovable = true;
		walls.add(leftwall);
		walls.add(rigtwall);
		add(walls);
		
		floors = new FlxGroup();
		var floor1:FlxObject = new FlxObject( 0, 1038, 1920, 42);
		    floor1.immovable = true;
		var floor2:FlxObject = new FlxObject( 0, 673, 1920, 50);
		    floor2.immovable = true;
		var floor3:FlxObject = new FlxObject( 0, 312, 1920, 51);
		    floor3.immovable = true;
		floors.add(floor1);
		floors.add(floor2);
		floors.add(floor3);
		add(floors);		
		
		ladders = new FlxGroup();
		var ladder1:FlxObject = new FlxObject(1739, 632, 111, 406);
		    ladder1.immovable = true;
		var ladder2:FlxObject = new FlxObject(107, 264, 109, 409);
		    ladder2.immovable = true;
		ladders.add(ladder1);
		ladders.add(ladder2);
		add(ladders);
		
		//level = new FlxTilemap();
		//level.loadMapFromCSV(AssetPaths.SomeWalls__csv, AssetPaths.autotiles__png, 32, 32, AUTO);
		//add(level);
		
		khonjin = new Khonjin(50, 900);
		add(khonjin);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(walls, khonjin);
		FlxG.collide(floors, khonjin);
		//FlxG.collide(level, khonjin);
	}
}
