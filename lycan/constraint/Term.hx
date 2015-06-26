package lycan.constraint;

class Term {
	public var value(get, null):Float;
	public var variable(get, null):Variable;
	public var coefficient(get, null):Float;
	
	public function new(variable:Variable, coefficient:Float = 1.0) {
		this.variable = variable;
		this.coefficient = coefficient;
	}
	
	private function get_value():Float {
		return variable.value * coefficient;
	}
	
	private function get_variable():Variable {
		return variable;
	}
	
	private function get_coefficient():Float {
		return coefficient;
	}
}