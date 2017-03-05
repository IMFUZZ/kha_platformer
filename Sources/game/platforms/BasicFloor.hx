package game.platforms;

import engine.graphics.PhysSprite;
import engine.state.PlayState;
import nape.phys.BodyType;

class BasicFloor extends PhysSprite {
	public function new(x:Float, y:Float, width:Float, height:Float, playState:PlayState, physicsEnabled:Bool = true) {
		super(x, y, width, height, playState, physicsEnabled);
		this.setBody(BodyType.STATIC);
	}
}