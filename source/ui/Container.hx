package ui;

import flash.display.Graphics;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;


typedef Movable = {
	public var x(default, set):Float;
	public var y(default, set):Float;
	@:isVar
	public var width(get, set):Float;
	@:isVar
	public var height(get, set):Float;
}
/**
 * This is a container class for ordering and arranging UI Elements on screen.
 * Generally you'll nest several containers together to create UIs that can work at any resolution, and are general and scalable.
 * ...
 * @author Zack
 */
class Container extends FlxGroup
{

	public var x(default, set):Float;
	public var y(default, set):Float;
	@:isVar
	public var width(get, set):Float;
	@:isVar
	public var height(get, set):Float;
	//The padding around the borders of this container that will be avoided where possible
	public var innerPadding:FlxRect;
	//The spacing between one element and the next - in pixels.
	public var spacing:Float;
	
	public var layout(default, set):ContainerLayout;
	
	private var movables:Array<Movable>;
	
	//This will be linked when this container is added to another container.
	public var parent:Container;
	private var reflowIsLocked:Bool;
	/**
	 * Creates a new Container
	 * @param	layout this is the layout the container will use
	 * @param	width	optional	set a starting width for this container
	 * @param	height	optional	set a starting height for this container
	 * @param	x		optional	set an x position for this container - this is overwritten if being added to another container
	 * @param	y		optional	set a y position for this container - this is overwritten if being added to another container
	 */
	public function new(layout:ContainerLayout, width:Float = 0, height:Float = 0, x:Float = 0, y:Float = 0) 
	{
		super();
		
		movables = [];
		innerPadding = new FlxRect(0, 0, 0, 0);
		spacing = 5;
		reflowIsLocked = false;
		this.layout = layout;
		this.layout.container = this;
		
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}
	
	override public function add(object:FlxBasic):FlxBasic 
	{
		super.add(object);
		
		//Check and see if it's a positionable object
		var doReflow:Bool = false;
		if (Std.is(object, FlxObject)) {
			var flxobject:FlxObject = cast (object, FlxObject);
			movables.push(flxobject);
			doReflow = true;
		}
		
		if (Std.is(object, Container)) {
			var container:Container = cast (object, Container);
			container.parent = this;
			movables.push(container);
			doReflow = true;
		}
		
		if(doReflow) {
			reflow();
		}
		return object;
	}
	
	//TODO: Inner Padding, Multi-line wrapping mode
	public function reflow():Void {
		if (movables.length <= 0 || reflowIsLocked) {
			return;
		}
		//For each thing we have, start shifting things around.
		//Pass 1, arrange all the objects according to layout, keep track of extents
		
		//Layouts do some strange ass shit.
		//HORIZONTAL_ALIGNMENT:
		//If Vertical - take it at face value and align things to that position.
		//If Horizontal
			//Left - Just set a start point, and move across by width + spacing each item
			//Right - Place items on the right side, and move all other items by the width of the item added + spacing
			//Center - Calculate the new width extent, then add the item at the right end of the width extent + spacing, then calculate a dx and move all items by that dx
		
		//Left align: 	Insert at extents.width + spacing - (object.width * (horizontal_align/2)), shift previous by (object.width * (horizontal_align/2))
		//Center align: Insert at extents.width + spacing - (object.width * (horizontal_align/2)), shift previous by (object.width * (horizontal_align/2))
		//Right align: 	Insert at extents.width + spacing - (object.width * (horizontal_align/2)), shift previous by (object.width * (horizontal_align/2))
		//horizontal aligns are 0 for left, 1 for center, 2 for right.
		
		//The same should be able to apply to verticality
		
		//Pass 1, collect size information, and resize as necessary
		var newWidth:Float = 0;
		var newHeight:Float = 0;
		for (movable in movables) {
			if (layout.direction == ContainerLayout.HORIZONTAL) {
				newWidth += movable.width + spacing;
				newHeight = Math.max(newHeight, movable.height);
			}else {
				newWidth = Math.max(newWidth, movable.width);
				newHeight += movable.height + spacing;
			}
		}
		//remove the extra piece of spacing that was added in.
		newWidth -= layout.direction == ContainerLayout.HORIZONTAL ? spacing : 0;
		newHeight -= layout.direction == ContainerLayout.HORIZONTAL ? 0 : spacing;
		var doReflow:Bool = false;
		if (newWidth + innerPadding.x + innerPadding.width > width || newHeight + innerPadding.y + innerPadding.height > height) {
			doReflow = true;
		}
		
		//We either take the new size, or the old size
		width = Math.max(width, newWidth + innerPadding.x + innerPadding.width);
		height = Math.max(height, newHeight + innerPadding.y + innerPadding.height);
			
		//The same thing applies transposed to Vertical alignment things
		var row:Array<Movable> = [];
		var rowExtents:FlxRect = new FlxRect(Math.floor(width * (layout.horizontalAlignment / 2)), Math.floor(height * (layout.verticalAlignment / 2)), -spacing, -spacing);
		for (movable in movables) {
			if (layout.direction == ContainerLayout.HORIZONTAL) {
				movable.x = x + innerPadding.x + rowExtents.x + rowExtents.width + spacing - Math.floor(movable.width * (layout.horizontalAlignment / 2));
				movable.y = y + innerPadding.y + rowExtents.y - Math.floor(movable.height * (layout.verticalAlignment / 2));
				
				rowExtents.width += movable.width + spacing;
				rowExtents.height = Math.max(movable.height, rowExtents.height);
			}else {
				movable.x = x + innerPadding.x + rowExtents.x - Math.floor(movable.width * (layout.horizontalAlignment / 2));
				movable.y = y + innerPadding.y + rowExtents.y + rowExtents.height + spacing - Math.floor(movable.height * (layout.verticalAlignment / 2));
				
				rowExtents.width = Math.max(movable.width, rowExtents.width);
				rowExtents.height += movable.height + spacing;
			}
			
			for (rowItem in row) {
				if (layout.direction == ContainerLayout.HORIZONTAL) {
					rowItem.x -= Math.floor((movable.width + spacing) * (layout.horizontalAlignment / 2));
				}else {
					rowItem.y -= Math.floor((movable.height + spacing) * (layout.verticalAlignment / 2));
				}
			}
			
			if (layout.direction == ContainerLayout.HORIZONTAL) {
				rowExtents.x -= Math.floor((movable.width + spacing) * (layout.horizontalAlignment / 2));
			}else {
				rowExtents.y -= Math.floor((movable.height + spacing) * (layout.verticalAlignment / 2));
			}
			
			row.push(movable);
		}
		//Then, if the extents are larger than this container + padding, enlarge the container to fit everything.
		//If this container was resized, then reflow the parent
		if (doReflow && parent != null) {
			parent.reflow();
		}
	}
	
	public function lock():Void {
		reflowIsLocked = true;
	}
	
	public function unlock():Void {
		reflowIsLocked = false;
		reflow();
	}
	
	private function reposition(dx:Float, dy:Float):Void {
		for (movable in movables) {
			movable.x -= dx;
			movable.y -= dy;
		}
	}
	
	private inline function castToMovable(item:FlxBasic):Movable {
		if (Std.is(item, FlxObject)) {
			return cast(item, FlxObject);
		}
		if (Std.is(item, Container)) {
			return cast(item, Container);
		}
		return null;
	}
	
	override public function draw():Void 
	{
		super.draw();
		#if !FLX_NO_DEBUG
		if (FlxG.debugger.drawDebug)
			drawDebug();
		#end
	}
	
#if !FLX_NO_DEBUG
	public function drawDebug():Void
	{	
		for (camera in cameras)
		{
			drawDebugOnCamera(camera);
		}
	}
	
	/**
	 * Override this function to draw custom "debug mode" graphics to the
	 * specified camera while the debugger's drawDebug mode is toggled on.
	 * 
	 * @param	Camera	Which camera to draw the debug visuals to.
	 */
	public function drawDebugOnCamera(camera:FlxCamera):Void
	{
		if (!camera.visible || !camera.exists)
		{
			return;
		}
		
		var rect = new FlxRect(x, y, width, height);
		
		// Find the color to use
		var color:Null<Int> = FlxColor.WHITE;
		
		//fill static graphics object with square shape
		var gfx:Graphics = beginDrawDebug(camera);
		gfx.lineStyle(1, color, 0.5);
		gfx.drawRect(x, y, width, height);
		endDrawDebug(camera);
	}

	private inline function beginDrawDebug(camera:FlxCamera):Graphics
	{
		if (FlxG.renderBlit)
		{
			FlxSpriteUtil.flashGfx.clear();
			return FlxSpriteUtil.flashGfx;
		}
		else
		{
			return camera.debugLayer.graphics;
		}
	}
	
	private inline function endDrawDebug(camera:FlxCamera)
	{
		if (FlxG.renderBlit)
		{
			camera.buffer.draw(FlxSpriteUtil.flashGfxSprite);
		}
	}
#end
	
	function set_layout(value:ContainerLayout):ContainerLayout {
		layout = value;
		reflow();
		return layout;
	}
	
	function set_x(value:Float):Float 
	{
		var dx = x - value;
		x = value;
		reposition(dx, 0);
		return x;
	}
	
	function set_y(value:Float):Float 
	{
		var dy = y - value;
		y = value;
		reposition(0, dy);
		return y;
	}
	
	function get_width():Float 
	{
		return width;
	}
	
	function set_width(value:Float):Float 
	{
		return width = value;
	}
	
	function get_height():Float 
	{
		return height;
	}
	
	function set_height(value:Float):Float 
	{
		return height = value;
	}
}