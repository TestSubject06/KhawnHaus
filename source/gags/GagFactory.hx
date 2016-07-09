package gags;

/**
 * ...
 * @author Zack
 */
class GagFactory
{
	private static var gagMap:Map<String, Class<Gag>>;
	
	//TODO: Keep this updated as new gags are added
	private static var gags:Array<Class<Gag>> = [PipeBlast];
	
	public static function getGagByName(name:String):Gag {
		if (gagMap == null) {
			buildGagMap();
		}
		return Type.createInstance(gagMap.get(name), []);
	}
	
	public static function getAllGagNames():Array<String> {
		if (gagMap == null) {
			buildGagMap();
		}
		var ret:Array<String> = [];
		for (key in gagMap.keys()) {
			ret.push(key);
		}
		return ret;
	}
	
	public static function buildGagMap():Void {
		gagMap = new Map<String, Class<Gag>>();
		for (gag in gags) {
			gagMap.set(Type.createInstance(gag, []).name, gag);
		}
	}
}