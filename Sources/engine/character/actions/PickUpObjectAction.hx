package engine.character.actions;

class PickUpObjectAction extends CharacterAction {
	override public function new(character:Character) {
		super(character, null);
	}

	override public function execute() {
		var body:nape.phys.Body = this.character.body;
		var reachBoxX:Float = this.character.isFlippedVertically ? body.position.x - this.character.width/2 - this.character.reachDistance : body.position.x + this.character.width/2;
		var reachBoxY:Float = body.position.y;
		var reachBoxWidth:Float = this.character.reachDistance;
		var reachBoxHeight:Float = 32.0;
		var bodiesUnderChar:nape.phys.BodyList = this.character.space.bodiesInAABB(
			new nape.geom.AABB(
				reachBoxX,
				reachBoxY,
				reachBoxWidth,
				reachBoxHeight
			), 
		false, true, null);
		for (bodyUnderChar in bodiesUnderChar) {
			var isObject:Bool = Std.is(bodyUnderChar.userData.entity, engine.objects.Object);
			if (isObject) {
				this.character.takeObject(cast(bodyUnderChar.userData.entity, engine.objects.Object));
			}
		}
		// DJDUBE - SHOULD CHECK FOR A BODY THAT THIS SPRITE CAN 'BOUNCE' FROM (EX : BACKGROUND BODIES SHOULDN'T SET ISGROUNDED)
		// return this.isGrounded = (bodiesUnderChar.length > 1);
	}
} 