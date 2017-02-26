package engine.graphics;

import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.graphics2.GraphicsExtension;
import kha.Color;
import kha.math.FastMatrix3;

import engine.base.IEntity;

class Camera implements IEntity {
	public var x:Float = 0.0;
	public var y:Float = 0.0;
	public var debug:Bool;
	public var translation:FastMatrix3;

	public function new() {
		this.translation = FastMatrix3.identity();
	}

	public function update():Void {
		
	}
	

	public function render(framebuffer: Framebuffer):Void {

	}

	public function set(graphics:Graphics) {
		graphics.pushTranslation(-this.x, -this.y);
	}

	public function unset(graphics:Graphics) {
		graphics.popTransformation();
	}
}