package engine.state;

import kha.Framebuffer;

import engine.base.EntityContainer;
import engine.graphics.Camera;

class State extends EntityContainer {
	public var timePaceRatio:Float = 1.0;
	public var camera:Camera;
	override public function new() {
		super();
		this.camera = new Camera();
	}

	override public function update() {
		super.update();		
	}

	override public function render(framebuffer:Framebuffer) {
		//this.camera.set(framebuffer.g2);
		super.render(framebuffer);
		//this.camera.unset(framebuffer.g2);
	}
}