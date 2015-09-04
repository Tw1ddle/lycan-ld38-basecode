package lycan.util;

import flixel.FlxSprite;

class GameUtil {
	 // Set the position of a sprite such that its position is a given value at a given camera scroll
	 // Used for parallax sprites
	public static inline function setPositionAtScroll(sprite:FlxSprite, x:Float, y:Float, scrollX:Float, scrollY:Float):Void {
		sprite.x = GameUtil.parallaxOrigin(x, scrollX, sprite.scrollFactor.x);
		sprite.y = GameUtil.parallaxOrigin(y, scrollY, sprite.scrollFactor.y);
	}
	
	public static inline function parallaxOrigin(origin:Float, cameraPosition:Float, scrollFactor:Float):Float {
		return origin + cameraPosition * (scrollFactor - 1);
	}
}