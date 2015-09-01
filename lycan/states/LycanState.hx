package lycan.states;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxTween.TweenOptions;
import flixel.util.FlxColor;

// Base state for all substates in a game
class LycanState extends FlxSubState implements LateUpdatable {
	#if debug
	private var updatesWithoutLateUpdates:Int = 0; // Double check lateupdate is being called
	#end
	
	public var uiGroup:FlxGroup;
	
	public var uiCamera:FlxCamera;
	public var worldCamera:FlxCamera;
	
	public var worldZoom(default, set):Float;
	public var baseZoom:Float;
	
	public var zoomTween:FlxTween;
	/** Map of IDs to tweens that should be cancelled before another tween of the same ID plays */
	public var exclusiveTweens:Map<String, FlxTween>;
	
	public function new() {
		super();
		
		exclusiveTweens = new Map<String, FlxTween>();
		
		// Cameras
		worldCamera = FlxG.camera;
		uiCamera = new FlxCamera(Std.int(FlxG.camera.x), Std.int(FlxG.camera.y), 
		                         FlxG.camera.width, FlxG.camera.height, FlxG.camera.zoom);
		uiCamera.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(uiCamera);
		FlxCamera.defaultCameras = [worldCamera];
		
		baseZoom = worldCamera.zoom;
		worldZoom = 1;
		
		// Groups
		uiGroup = new FlxGroup();
		uiGroup.cameras = [uiCamera];
		
		add(uiGroup);
	}
	
	override public function create():Void {
		super.create();
	}
	
	override public function update(dt:Float):Void {
		super.update(dt);
		
		#if debug
		updatesWithoutLateUpdates++;
		if (updatesWithoutLateUpdates > 1) {
			throw("lateUpdate has not been called since last update");
		}
		#end
	}
	
	public function lateUpdate(dt:Float) {
		#if debug
		updatesWithoutLateUpdates = 0;
		#end
		
		forEach(function(o:FlxBasic) {
			if (Std.is(o, LateUpdatable)) {
				var u:LateUpdatable = cast o;
				u.lateUpdate(dt);
			}
		}, true);
	}
	
	public function exclusiveTween(id:String, object:Dynamic, values:Dynamic, duration:Float = 1, ?options:TweenOptions):FlxTween {
		if (exclusiveTweens.exists(id)) {
			exclusiveTweens.get(id).cancel();
		}
		var tween:FlxTween = FlxTween.tween(object, values, duration, options);
		exclusiveTweens.set(id, tween);
		return tween;
	}
	
	public function zoomTo(zoom:Float, duration:Float = 0.5, ?ease:Float->Float):FlxTween {
		if (ease == null) {
			ease = FlxEase.quadInOut;
		}
		if (zoomTween != null) {
			zoomTween.cancel();
		}
		zoomTween = FlxTween.tween(this, { worldZoom: zoom }, duration, { type: FlxTween.ONESHOT, ease: ease } ); 
		return zoomTween;
	}
	
	private function set_worldZoom(worldZoom:Float):Float {
		// Set world and camera zoom
		worldCamera.zoom = baseZoom * worldZoom;
		return this.worldZoom = worldZoom;
	}
	
	//TODO autotweening
	//TODO camera targeting
	//TODO sound fading
}