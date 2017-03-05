package engine.base;

import kha.Framebuffer;

class Empty implements IEntity {
	public var x:Float;
	public var y:Float;
	public var debug:Bool;

	public function new(x:Float, y:Float) {
		this.setPosition(x, y);
		this.x = x;
		this.y = y;
	}

	public function update(elapsed:Float):Void {

	}

	public function render(framebuffer:Framebuffer):Void {

	}

	public function setPosition(x:Float, y:Float):Void {
		this.x = x;
		this.y = y;
	}
}