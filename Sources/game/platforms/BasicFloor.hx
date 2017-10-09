package game.platforms;

import kha.Color;
import kha.Canvas;

import engine.graphics.PhysSprite;
import engine.state.PlayState;
import nape.phys.BodyType;

class BasicFloor extends PhysSprite {
	public var color:Color = Color.Black;

	public function new(x:Float, y:Float, width:Float, height:Float, playState:PlayState, physicsEnabled:Bool = true) {
		super(x, y, width, height, playState, physicsEnabled);
		this.setBody(BodyType.STATIC);
	}

	override public function render(canvas:Canvas) {
		super.render(canvas);
		var imageX:Float = this.x - this.width/2;
		var imageY:Float = this.y - this.height/2;
		var graphics:kha.graphics2.Graphics = canvas.g2;
		var initialColor:Color = graphics.color;
		graphics.color = this.color;
		graphics.drawRect(imageX, imageY, this.width, this.height, 1);
		graphics.color = initialColor;
	}
}