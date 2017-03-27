package engine.base;

import kha.Canvas;
import engine.state.State;

class Empty implements IEntity {
	public var x:Float;
	public var y:Float;
	public var debug:Bool;
	public var alive:Bool = true;
	public var state:State;

	public function new(x:Float, y:Float, state:State) {
		this.x = x;
		this.y = y;
		this.state = state;
	}

	public function update(elapsed:Float):Void {}

	public function render(canvas:Canvas):Void {}

	public function setPosition(x:Float, y:Float):Void {
		this.x = x;
		this.y = y;
	}

	public function kill() {
		this.alive = false;
	}

	public function destroy() {
		this.state.remove(this);
	}
}