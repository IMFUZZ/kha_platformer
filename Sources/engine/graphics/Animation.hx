package engine.graphics;

import kha.math.Vector2;
import kha.Framebuffer;

import engine.graphics.Sprite;

class Animation extends Sprite {
	public var frameIndexes:Array<Vector2> = new Array<Vector2>();
	public var nbFrames:Int;
	public var frameWidth:Float;
	public var frameHeight:Float;
	public var index:Int = 0;
	public var nbFramesWithoutChange:Int = 0;
	public var isFlippedVertically:Bool = false;

	public function new(x, y, width, height, state, filename, nbFrames) {
		super(x, y, width, height, state);
		this.frameWidth = this.width;
		this.frameHeight = this.height;
		this.nbFrames = nbFrames;
		this.loadGraphics(filename);
		this.initFrameIndexes(0, nbFrames);
	}

	override public function update() {
		this.nbFramesWithoutChange++;
		this.index = (this.index+1)%this.nbFrames;
	}

	public function resetFrameIndex() {
		this.nbFramesWithoutChange = this.index = 0;
	}

	public function initFrameIndexes(start:Int, end:Int) {
		for (i in start...end) {
			var tileWidthTimesIndex:Float = this.frameWidth*i;
			var imageWidth:Float = this.frameWidth*end;
			this.frameIndexes.push(new Vector2(
				(tileWidthTimesIndex%imageWidth),
				(Std.int(tileWidthTimesIndex/imageWidth)*this.frameHeight)
			));
		}
	}

	override public function render(framebuffer:Framebuffer) {
		if (this._image != null) {
			var graphics = framebuffer.g2;
			var framePosition:Vector2 = this.frameIndexes[this.index];
			graphics.pushRotation(this.rotation.angle, this.x, this.y);
			if (isFlippedVertically) {
				graphics.drawScaledSubImage(this._image, framePosition.x, framePosition.y, this.width, this.height, this.x+this.width, this.y, -this.width, this.height);
			} else {
				graphics.drawScaledSubImage(this._image, framePosition.x, framePosition.y, this.width, this.height, this.x, this.y, this.width, this.height);
			}
			graphics.popTransformation();
			
		}
	}
}