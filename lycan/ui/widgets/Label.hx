package lycan.ui.widgets;

import lycan.ui.renderer.ITextRenderItem;
import lycan.ui.UIObject;

// A simple text graphic display
class Label extends Widget {
	public var graphic(default,set):ITextRenderItem;
	
	public function new(?parent:UIObject, ?name:String) {
		super(parent, name);
	}
	
	private function set_graphic(graphic:ITextRenderItem) {		
		width = graphic.get_width();
		height = graphic.get_height();
		return this.graphic = graphic;
	}
	
	override private function set_x(x:Int):Int {
		if(graphic != null) {
			graphic.set_x(x);	
		}
		
		return super.set_x(x);
	}
	
	override private function set_y(y:Int):Int {
		if (graphic != null) {
			graphic.set_y(y);
		}
		
		return super.set_y(y);
	}
}