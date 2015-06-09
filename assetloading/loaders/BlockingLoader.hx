package lycan.assetloading.loaders ;

import lycan.assetloading.tasks.IDescribable;
import lycan.assetloading.tasks.ILoadingSignalDispatcher;
import lycan.assetloading.tasks.IRunnable;
import lycan.queue.IPrioritizable;

// Crappy loader that blocks until all tasks are complete
class BlockingLoader<T:(IPrioritizable, IRunnable, ILoadingSignalDispatcher, IDescribable)> extends Loader<T> {
	override public function start():Void {
		super.start();
		
		while (!queue.empty()) {
			var task:T = queue.pop();
			task.run();
		}
	}
	
	private function onTaskCompleted(what:T):Void {
		super.onTaskCompleted(what);
		
		if (queue.empty()) {
			finish();
		}
	}
	
	private function onTaskFailed(what:T, why:String):Void {
		super.onTaskFailed(what, why);
		
		if (queue.empty()) {
			finish();
		}
	}
}