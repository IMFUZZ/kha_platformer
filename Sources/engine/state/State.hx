package engine.state;

import kha.Framebuffer;

import engine.base.EntityContainer;

class State extends EntityContainer {
	public var timePaceRatio:Float = 1.0;
	override public function new() {
		super();
	}

	override public function update() {
		super.update();		
	}

	override public function render(framebuffer:Framebuffer) {
		super.render(framebuffer);
	}
}