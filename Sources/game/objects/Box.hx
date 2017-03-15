package game.objects;

import engine.objects.Object;
import engine.state.PlayState;
import nape.phys.BodyType;

class Box extends Object {
	public function new (x:Float, y:Float, width:Float, height:Float, playState:PlayState, physicsEnabled:Bool = true) {
		super(x, y, width, height, playState, physicsEnabled);
		this.loadGraphics('crate');
		this.setBody(BodyType.DYNAMIC);
		this.body.mass = 2;
	}
}