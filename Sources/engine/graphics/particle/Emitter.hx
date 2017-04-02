package engine.graphics.particle;

import engine.base.Empty;
import engine.state.PlayState;

class Emitter extends Empty {
	public var particle:Particle;
	public var emitionSpeed:Float = 30/60; // 30 particle per 60 frames 
	private var emitionCycle:Float = 0;

	public function new(x:Float, y:Float, playState:PlayState) {
		super(x, y, playState);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		this.emitionCycle += this.emitionSpeed;
		while (this.emitionCycle - 1.0 > 0) {
			this.emitionCycle -= 1.0;
			this.emit();
		}
	}

	public function emit() {
		var particle:Particle = new Particle(
			this.x,
			this.y,
			10,
			10,
			cast(this.state, PlayState),
			true
		);
		particle.loadGraphics("crate");
		this.state.add(particle);
	}
}