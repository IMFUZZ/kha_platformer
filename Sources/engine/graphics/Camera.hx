package engine.graphics;

import kha.graphics2.Graphics;
import kha.math.FastMatrix3;

import engine.base.IEntity;

class Camera {
	public var debug:Bool;
	public var centerX:Float;
	public var centerY:Float;
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	private var _scaleMatrix:FastMatrix3 = FastMatrix3.identity();
	private var _target:IEntity = null;

	public function get_x() {
		return this.x;
	}

	public function new(x:Float, y:Float, width:Float, height:Float, ?target:IEntity = null) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = width;
		this.follow(target);
		this.realignCenter();
	}

	public function follow(target:IEntity) {
		this._target = target;
	}

	public function setPosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;
		this.realignCenter();
	}

	public function realignCenter() {
		this.centerX = this.x - this.width/2;
		this.centerY = this.y - this.height/2;
	}

	public function update(elapsed:Float):Void {
		this.setPosition(this._target.x, this._target.y);
	}
	
	public function set(graphics:Graphics) {
		graphics.pushTranslation(-this.centerX, -this.centerY);
	}

	public function unset(graphics:Graphics) {
		graphics.popTransformation();
	}
}