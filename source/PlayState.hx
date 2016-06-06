package;

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

class PlayState extends FlxState
{
	private var walls:FlxGroup;
	private var khonjin:Khonjin;
	private var level:FlxTilemap;
	override public function create():Void
	{
		super.create();
		FlxG.worldBounds.set(-100, -100, FlxG.width + 200, FlxG.height + 200);
		walls = new FlxGroup();
		var floor:FlxObject = new FlxObject(5, FlxG.height, FlxG.width, 10);
		var wall1:FlxObject = new FlxObject(-5, 0, 10, FlxG.height);
		var wall2:FlxObject = new FlxObject(FlxG.width-5, 0, 10, FlxG.height);
		floor.immovable = true;
		wall1.immovable = true;
		wall2.immovable = true;
		walls.add(floor);
		walls.add(wall1);
		walls.add(wall2);
		add(walls);
		
		level = new FlxTilemap();
		level.loadMapFromCSV(AssetPaths.SomeWalls__csv, AssetPaths.autotiles__png, 32, 32, AUTO);
		add(level);
		
		khonjin = new Khonjin(50, 50);
		add(khonjin);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.justPressed.ESCAPE) {
			Sys.exit(0);
		}
		
		FlxG.collide(walls, khonjin);
		FlxG.collide(level, khonjin);
	}
}
