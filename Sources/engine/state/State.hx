package engine.state;

import kha.Framebuffer;

import engine.base.EntityContainer;
import engine.graphics.Camera;

class State extends EntityContainer {
	public var timePaceRatio:Float = 1.0;
	public var camera:Camera;
	public var width:Float;
	public var height:Float;
	override public function new(x:Float, y:Float, width:Float, height:Float) {
		super(x, y);
		this.width = width;
		this.height = height;
		this.camera = new Camera(x, y, width, height);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		this.camera.update(elapsed);
	}

	override public function render(framebuffer:Framebuffer) {
		this.camera.set(framebuffer.g2);
		super.render(framebuffer);
		this.camera.unset(framebuffer.g2);
	}
}