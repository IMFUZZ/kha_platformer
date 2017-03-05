package game;

import nape.phys.BodyType;
import nape.geom.Vec2;

import engine.Shared;
import engine.character.Character;
import engine.graphics.PhysSprite;
import engine.state.PlayState;
import game.objects.*;
import game.platforms.*;

class ExperimentLevel1 extends PlayState {
	public function new(x:Float, y:Float, width:Float, height:Float) {
		super(x, y, width, height);
		var character:Character = new Character(100, 100, 32, 64, this);
		Shared.game.players[0].setCharacter(character);
		this.add(character);
		this.camera.follow(character);

		for (i in 0...10) {
			var box:Box = new Box(100+Std.random(32), 1*-32, 32, 32, this);
			this.add(box);
		}

		this.add(new BasicFloor(500, 500, 10000, 128, this));
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}
}