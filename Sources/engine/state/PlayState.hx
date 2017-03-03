package engine.state;

import nape.space.Space;
import nape.geom.Vec2;
import nape.callbacks.*;

class PlayState extends State {
	public var space:Space;
	public var gravity:Vec2 = new Vec2(0, 1200);

	public var anyCbType:CbType = new CbType();
	public var staticCbType:CbType = new CbType();
	public var dynamicCbType:CbType = new CbType();
	public var characterCbType:CbType = new CbType();

	public function new() {
		super();
		this.space = new Space(gravity);
		this.space.listeners.add(new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, characterCbType, anyCbType, onCharacterBeginCollision));
		this.space.listeners.add(new InteractionListener(CbEvent.END, InteractionType.COLLISION, characterCbType, anyCbType, onCharacterEndCollision));
	}

	public function onCharacterBeginCollision(collision:InteractionCallback):Void {
		collision.int1.castBody.userData.character.checkIfGrounded();
	}

	public function onCharacterEndCollision(collision:InteractionCallback):Void {
		collision.int1.castBody.userData.character.checkIfGrounded();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		this.space.step(elapsed*this.timePaceRatio);
	}
}