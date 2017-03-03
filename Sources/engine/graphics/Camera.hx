package engine.graphics;

import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.graphics2.GraphicsExtension;
import kha.Color;
import kha.math.FastMatrix3;

import engine.base.IEntity;

class Camera implements IEntity {
	public var x:Float;
	public var y:Float;
	public var centerX:Float;
	public var centerY:Float;
	public var width:Float;
	public var height:Float;
	public var debug:Bool;
	public var translation:FastMatrix3 = FastMatrix3.identity();

	public function new(x:Float, y:Float, width:Float, height:Float) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = width;
		this.realignCenter();
	}

	public function setPosition(x, y) {
		this.x = x;
		this.y = y;
		this.realignCenter();
	}

	public function realignCenter() {
		this.centerX = this.x - this.width/2;
		this.centerY = this.y - this.height/2;
	}

	public function update(elapsed):Void {
		this.realignCenter();
	}
	

	public function render(framebuffer: Framebuffer):Void {

	}

	public function set(graphics:Graphics) {
		graphics.pushTranslation(-this.centerX, -this.centerY);
	}

	public function unset(graphics:Graphics) {
		graphics.popTransformation();
	}
}