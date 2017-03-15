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

	public function new(x:Float, y:Float, width:Float, height:Float) {
		super(x, y, width, height);
		this.space.listeners.add(
			new InteractionListener(
				CbEvent.BEGIN, 
				InteractionType.COLLISION, 
				characterCbType, 
				anyCbType, 
				onCharacterBeginCollision
			)
		);
		this.space.listeners.add(
			new InteractionListener(
				CbEvent.END, 
				InteractionType.COLLISION, 
				characterCbType, 
				anyCbType, 
				onCharacterEndCollision
			)
		);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		this.space.step(elapsed*this.timePaceRatio);
	}

	override public function loadConfig(config:Dynamic) {
		var elements:Array<Dynamic> = config.stage.elements;
		this.space = new Space(this.gravity = new Vec2(0, 1200));
		for (element in elements) {
			var sprite:game.platforms.BasicFloor = new game.platforms.BasicFloor(
				element.location.x,
				-element.location.y,
				element.dimensions.width,
				element.dimensions.height,
				this,
				true
			);
			sprite.enablePhysics(false);
			sprite.body.rotation = element.rotationAngle;
			sprite.enablePhysics(true);
			sprite.debug = true;
			if (element.image) {

			}
			this.add(sprite);
		}
	}

	public function onCharacterBeginCollision(collision:InteractionCallback):Void {
		collision.int1.castBody.userData.character.checkIfGrounded();
	}

	public function onCharacterEndCollision(collision:InteractionCallback):Void {
		collision.int1.castBody.userData.character.checkIfGrounded();
	}
}