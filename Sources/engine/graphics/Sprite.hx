package engine.graphics;

import kha.Framebuffer;
import kha.Image;
import kha.Assets;

import engine.base.IEntity;
import engine.state.State;

class Sprite implements IEntity {
	public var debug:Bool = true;
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public var isFlippedVertically:Bool = false;
	public var state:State;
	public var rotationAngle:Float = 0.0;
	private var _image:Image;

	public function new(x:Float, y:Float, width:Float, height:Float, state:State) {
		this.width = width;
		this.height = height;
		this.state = state;
		this.setPosition(x, y);
	}

	public function setPosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function update(elapsed:Float): Void {
		
	}

	public function render(framebuffer: Framebuffer): Void {
		var graphics = framebuffer.g2;
		var imageX:Float = this.x - this.width/2;
		var imageY:Float = this.y - this.height/2;
		var rotationX:Float = this.x - this.state.camera.centerX;
		var rotationY:Float = this.y - this.state.camera.centerY;
		if (this._image != null) {
			graphics.pushRotation(this.rotationAngle, rotationX, rotationY);
			graphics.drawScaledImage(this._image, imageX, imageY, this.width, this.height);
			graphics.popTransformation();
		}
		if (debug) {
			var graphics = framebuffer.g2;
			graphics.pushRotation(this.rotationAngle, rotationX, rotationY);
			graphics.drawRect(imageX, imageY, this.width, this.height);
			graphics.popTransformation();
		}
	}

	public function loadGraphics(filename:String) {
		this._image = Reflect.getProperty(Assets.images, filename);
	}
}
