package engine.graphics.particle;

import engine.graphics.PhysSprite;
import engine.state.PlayState;

class Particle extends PhysSprite {
	public var lifespan:Float = 2.0;
	public var age:Float = 0.0;

	public function new(x:Float, y:Float, width:Float, height:Float, playState:PlayState, physicsEnabled:Bool = true) {
		super(x, y, width, height, playState, physicsEnabled);
		this.setBody(nape.phys.BodyType.DYNAMIC);
		this.body.mass = 1;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		age += elapsed;
		if (age >= lifespan) {
			this.alive = false;
		}
	}
}