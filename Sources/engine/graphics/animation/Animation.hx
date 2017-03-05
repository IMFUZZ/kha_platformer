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
	public var isFlippedVertically:Bool = false;
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

	override public function update(elapsed:Float) {
		this._nbFramesWithoutChange++;
		this._index = (this._index+1)%this._nbFrames;
	}

	public function resetFrameIndex() {
		this._nbFramesWithoutChange = this._index = 0;
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
			graphics.pushRotation(this.rotation.angle, this.x, this.y);
			if (isFlippedVertically) {
				graphics.drawScaledSubImage(this._image, framePosition.x, framePosition.y, this._FRAMEWIDTH, this._FRAMEHEIGHT, this.x+this.width/2, this.y-this.height/2, -this.width, this.height);
			} else {
				graphics.drawScaledSubImage(this._image, framePosition.x, framePosition.y, this._FRAMEWIDTH, this._FRAMEHEIGHT, this.x-this.width/2, this.y-this.height/2, this.width, this.height);
			}
			graphics.popTransformation();
			
		}
	}
}