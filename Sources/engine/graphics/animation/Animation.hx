package engine.graphics.animation;

import kha.math.Vector2;
import kha.Framebuffer;

import engine.graphics.Sprite;

typedef AnimationData =  {
	var id:String;
	var filename:String;
	var anchors:Map<String, Array<Float>>;
}

class Animation extends Sprite {
	private var frameIndexes:Array<Vector2> = new Array<Vector2>();
	private var _nbFrames:Int;
	private var _index:Int = 0;
	private var _nbFramesWithoutChange:Int = 0;
	private var _FRAMEWIDTH:Float;
	private var _FRAMEHEIGHT:Float;

	public function new(x, y, width, height, state, filename, nbFrames) {
		super(x, y, width, height, state);
		this._FRAMEWIDTH = width;
		this._FRAMEHEIGHT = height;
		this._nbFrames = nbFrames;
		this.loadGraphics(filename);
		this.initFrameIndexes(0, nbFrames);
	}

	override public function setPosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	override public function update(elapsed:Float) {
		this._nbFramesWithoutChange++;
		if (this.state.timePaceRatio > 0 && this._nbFramesWithoutChange >= (1/this.state.timePaceRatio)) {
			this._nbFramesWithoutChange = 0;
			this._index = (this._index+1)%this._nbFrames;
		}
	}

	public function initFrameIndexes(start:Int, end:Int) {
		for (i in start...end) {
			var frameWidthTimesIndex:Float = this._FRAMEWIDTH*i;
			var spriteSheetWidth:Float = this._FRAMEWIDTH*end;
			this.frameIndexes.push(new Vector2(
				(frameWidthTimesIndex%spriteSheetWidth),
				(Std.int(frameWidthTimesIndex/spriteSheetWidth)*this._FRAMEHEIGHT)
			));
		}
	}

	override public function render(framebuffer:Framebuffer) {
		if (this._image != null) {
			var graphics = framebuffer.g2;
			var framePosition:Vector2 = this.frameIndexes[this._index];
			var rotationX:Float = this.x - this.state.camera.centerX;
			var rotationY:Float = this.y - this.state.camera.centerY;
			var imageX:Float = this.isFlippedVertically ? this.x+this.width/2 : this.x-this.width/2;
			var imageY:Float = this.isFlippedVertically ? this.y-this.height/2 : this.y-this.height/2;
			var imageWidth:Float = this.isFlippedVertically ? -this.width : this.width;
			var imageHeight:Float = this.height;
			graphics.pushRotation(this.rotationAngle, rotationX, rotationY);
			graphics.drawScaledSubImage(
					this._image,
					framePosition.x,
					framePosition.y,
					this._FRAMEWIDTH,
					this._FRAMEHEIGHT,
					// USE IMAGEX AND IMAGEY (The delay between update and render causes the positions to be incorrect)
					imageX,
					imageY,
					imageWidth,
					imageHeight
				);
			graphics.popTransformation();
		}
	}
}