package engine.graphics;

import kha.Framebuffer;
import kha.Image;
import kha.Rotation;
import kha.Assets;

import engine.base.IEntity;
import engine.state.State;

class Sprite implements IEntity {
	private var _image:Image;
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public var state:State;
	public var rotation:Rotation;
	public var debug:Bool = false;
	
	public function new(x:Float, y:Float, width:Float, height:Float, state:State) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		this.state = state;
		this.rotation = new Rotation(new kha.math.Vector2(this.width/2, this.height/2), 0);
	}

	public function update(elapsed:Float): Void {
		this.rotation.center.x = this.x - this.state.camera.centerX;
		this.rotation.center.y = this.y - this.state.camera.centerY;
	}

	public function render(framebuffer: Framebuffer): Void {
		var graphics = framebuffer.g2;
		if (this._image != null) {
			graphics.pushRotation(this.rotation.angle, this.rotation.center.x, this.rotation.center.y);
			graphics.drawScaledImage(this._image, this.x - this.width/2, this.y - this.height/2, this.width, this.height);
			graphics.popTransformation();
		}
	}

	public function loadGraphics(filename:String) {
		if (Reflect.hasField(Assets.images, filename)) {
			this._image = Reflect.getProperty(Assets.images, filename);
		}
	}
}
