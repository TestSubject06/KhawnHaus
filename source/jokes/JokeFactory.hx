package jokes;

/**
 * ...
 * @author Zack
 */
class JokeFactory
{
	private static var jokeMap:Map<String, Class<Joke>>;
	
	//TODO: Keep this updated as new jokes are added
	private static var jokes:Array<Class<Joke>> = [ThisGame];
	
	public static function getJokeByName(name:String):Joke {
		if (jokeMap == null) {
			buildJokeMap();
		}
		return Type.createInstance(jokeMap.get(name), []);
	}
	
	public static function getAllJokeNames():Array<String> {
		if (jokeMap == null) {
			buildJokeMap();
		}
		var ret:Array<String> = [];
		for (key in jokeMap.keys()) {
			ret.push(key);
		}
		return ret;
	}
	
	public static function buildJokeMap():Void {
		jokeMap = new Map<String, Class<Joke>>();
		for (joke in jokes) {
			jokeMap.set(Type.createInstance(joke, []).name, joke);
		}
	}
}