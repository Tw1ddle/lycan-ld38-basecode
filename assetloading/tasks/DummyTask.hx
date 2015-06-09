package lycan.assetloading.tasks ;

import openfl.Lib;
import lycan.assetloading.tasks.PriorityTask;

class DummyTask extends PriorityTask {
	private var duration:Float;
	
	public function new(durationMillis:Float, priority:Float = 0) {
		super(priority);
		duration = durationMillis;
	}
	
	override public function run():Void {
		signal_started.dispatch(this);
		
		var startTime = Lib.getTimer();
		while (startTime + duration > Lib.getTimer()) {
			#if !flash
			Sys.sleep(0.05);
			#end
			
			var progress = ((Lib.getTimer() - startTime) / duration) * 100;
			signal_progressed.dispatch(this, progress);
		}
		
		signal_progressed.dispatch(this, 100);
		signal_completed.dispatch(this);
	}
	
	override public function getDescription():String {
		return "dummy // " + Math.round(duration) + "ms";
	}
}