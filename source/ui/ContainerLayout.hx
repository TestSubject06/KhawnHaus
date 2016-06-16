package ui;
import flixel.FlxG;

/**
 * Basic data container for layout structure. Designed to be used in conjunction with Container.hx
 * ...
 * @author Zack
 */
class ContainerLayout
{
	//Layout flow directions
	public static var HORIZONTAL(default, never):Int = 0;
	public static var VERTICAL(default, never):Int = 1;
	
	//Layout flow alignments
	public static var ALIGN_LEFT(default, never):Int = 0;
	public static var ALIGN_RIGHT(default, never):Int = 2;
	public static var ALIGN_CENTER(default, never):Int = 1;
	public static var ALIGN_TOP(default, never):Int = 0;
	public static var ALIGN_BOTTOM(default, never):Int = 2;
	
	//The direction that the elements will be placed in
	public var direction(default, set):Int;
	
	//The horizontal alignment of the elements in the container
	public var horizontalAlignment(default, set):Int;
	
	//the vertical alignment of elements in the container
	public var verticalAlignment(default, set):Int;
	
	//If there's no more space at the end of this container, should it wrap to the next line, or expand the container to fit?
	public var wrapFlow(default, set):Bool;
	
	//A reference to the container this links to. TODO: trigger a reflow in the container when there are changes to this data structure.
	public var container:Container;

	public function new(direction:Int, horizontalAlignment:Int, verticalAlignment:Int, wrapFlow:Bool) {
		this.direction = direction;
		this.horizontalAlignment = horizontalAlignment;
		this.verticalAlignment = verticalAlignment;
		this.wrapFlow = wrapFlow;
		if (wrapFlow) {
			FlxG.log.error("Wrap flow is not yet supported. Setting it to false");
		}
		this.wrapFlow = false;
	}
	
	function set_verticalAlignment(value:Int):Int 
	{
		verticalAlignment = value;
		if(container != null)
			container.reflow();
		return verticalAlignment;
	}
	
	function set_horizontalAlignment(value:Int):Int 
	{
		horizontalAlignment = value;
		if(container != null)
			container.reflow();
		return horizontalAlignment;
	}
	
	function set_direction(value:Int):Int 
	{
		direction = value;
		if(container != null)
			container.reflow();
		return direction;
	}
	
	function set_wrapFlow(value:Bool):Bool 
	{
		if (value) {
			FlxG.log.error("Wrap flow is not yet supported. Setting it to false");
		}
		return wrapFlow = false;
	}
	
}