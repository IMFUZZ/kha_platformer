package engine.objects;

import engine.graphics.PhysSprite;
import engine.state.PlayState;

class Object extends PhysSprite {
	public function new (x:Float, y:Float, width:Float, height:Float, playState:PlayState, physicsEnabled:Bool = true) {
		super(x, y, width, height, playState, physicsEnabled);
	}
}