package game;

import nape.phys.BodyType;
import nape.geom.Vec2;

import engine.Shared;
import engine.character.Character;
import engine.graphics.PhysSprite;
import engine.state.PlayState;

import engine.graphics.Animation;

class ExperimentLevel1 extends PlayState {
	public function new() {
		super();
		var character:Character = new Character(100, 100, 64, 64, this);
		character.loadGraphics('crate');
		character.setBody(BodyType.DYNAMIC, new Vec2(character.x, character.y));
		Shared.game.players[0].setCharacter(character);
		character.addAnimation(new Animation(character.x, character.y, 64, 64, this, 'run', 60));
		this.add(character);
		for (x in 0...10) {
			var physSprite:PhysSprite = new PhysSprite(100+Std.random(32), x*-32, 32, 32, this);
			physSprite.loadGraphics('crate');
			physSprite.setBody(BodyType.DYNAMIC, new Vec2(physSprite.x, physSprite.y));
			this.add(physSprite);
		}

		var physSprite:PhysSprite = new PhysSprite(100+Std.random(32), x*-32, 128, 128, this);
		physSprite.loadGraphics('crate');
		physSprite.setBody(BodyType.DYNAMIC, new Vec2(physSprite.x, physSprite.y));
		this.add(physSprite);
		
		var floor:PhysSprite = new PhysSprite(500, 500, 1000, 128, this);
		floor.loadGraphics('crate');
		floor.setBody(BodyType.STATIC, new Vec2(floor.x, floor.y));
		this.add(floor);
	}

	override public function update() {
		super.update();
	}
}