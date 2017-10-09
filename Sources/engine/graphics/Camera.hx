package engine.graphics;

import kha.math.FastMatrix3;
import kha.Image;
import kha.Color;
import kha.Canvas;
import kha.Scaler;
import kha.System;

import engine.base.Empty;
import engine.state.State;
import engine.base.IEntity;

class Camera extends Empty {
	public var centerX:Float;
	public var centerY:Float;
	public var width:Float;
	public var height:Float;
	public var frame:Image;
	public var ui:Image;
	public var backgroundColor:Color = Color.Black;
	private var _scaleMatrix:FastMatrix3 = FastMatrix3.identity();
	private var _target:IEntity = null;

	public function new(x:Float, y:Float, width:Float, height:Float, state:State, ?target:IEntity = null) {
		super(x, y, state);
		var widthInt:Int = Std.int(width);
		var heightInt:Int = Std.int(height);
		this.frame = Image.createRenderTarget(widthInt, heightInt);
		this.ui = Image.createRenderTarget(widthInt, heightInt);
		this.follow(target);
		this.realignCenter();
	}

	override public function setPosition(x:Float, y:Float) {
		super.setPosition(x, y);
		this.realignCenter();
	}

	public function follow(target:IEntity) {
		this._target = target;
	}

	public function realignCenter() {
		this.centerX = this.x - this.frame.width/2;
		this.centerY = this.y - this.frame.height/2;
	}

	override public function update(elapsed:Float):Void {
		this.setPosition(this._target.x, this._target.y);
	}

	override public function render(canvas:Canvas) {
		Scaler.scale(this.frame, canvas, System.screenRotation);
	}

	public function renderUI(canvas:Canvas) {
		Scaler.scale(this.ui, canvas, System.screenRotation);
	}

	public function begin(?clear:Bool = false, clearColor:Color = null) {
		this.frame.g2.begin(clear, clearColor);
		this.applyTransformations();
	}

	public function end() {
		this.undoTransformations();
		this.frame.g2.end();
	}

	public function applyTransformations() {
		this.frame.g2.pushTranslation(-this.centerX, -this.centerY);
	}

	public function undoTransformations() {
		this.frame.g2.popTransformation();
	}
}