package lycan.ai;

import haxe.ds.StringMap;
import msignal.Signal.Signal1;

// TODO consider how to do behaviour orchestration/smart scenes with these NPCs and their brains

enum UnprioritizedBehaviourHandlingMode {
	IGNORE_UNWEIGHTED; // Ignore suggested behaviours that the brain doesn't have a priority for
}

// AI for a game entity
class Brain {
	public var signal_behaviourChanged = new Signal1<Node>();
	public var signal_behaviourAccepted = new Signal1<Node>();
	public var signal_behaviourRejected = new Signal1<Node>();
	
	private var activeBehaviours = new List<Node>(); // TODO prefer a set, not a list - there's no inherent ordering to active behaviours
	private var behaviourPriorityWeights:StringMap<Float>; // Maps named behaviours to this brain's priorities
	
	private var unprioritizedBehaviourHandlingMode = UnprioritizedBehaviourHandlingMode.IGNORE_UNWEIGHTED;
	
	public function new(?values:StringMap<Float>) {
		if (values == null) {
			values = new StringMap<Float>();
		}
		
		this.behaviourPriorityWeights = values;
	}
	
	public function offerBehaviour(root:Node, suggestedPriority:NodePriority):Bool {
		var weighting:Null<Float> = behaviourPriorityWeights.get(suggestedPriority.name);
		
		if(weighting == null) {
			weighting = 1;
		}
		
		switch(unprioritizedBehaviourHandlingMode) {
			case IGNORE_UNWEIGHTED:
				weighting = 0;
		}
		
		var subjectivePriority:Float = suggestedPriority.priority * weighting;
		
		// TODO iterate over the active behaviours and see if they can accept the new behaviour at the suggested priority
		// TODO if one/all (??) accept the behaviour, then install it (how?)
		// TODO how does the brain work out which behaviours are compatible with each other?
		
		var accepted:Bool = true;
		
		if (accepted) {
			signal_behaviourAccepted.dispatch(root);
			signal_behaviourChanged.dispatch(root);
			
			// TODO should probably be to replace a behaviour first, rather than add
			activeBehaviours.add(root);
			
			return true;
		} else {
			signal_behaviourRejected.dispatch(root);
			return false;
		}
	}
	
	// TODO need to do a deep comparison - the behaviour may only really the same if the children, histories, queued futures are equal too
 	public function hasBehaviour(behaviour:Node):Bool {
		for (activeBehaviour in activeBehaviours) {
			if (behaviour.id == activeBehaviour.id) {
				return true;
			}
		}
		
		return false;
	}
}