package engine.character.actions;

class JumpAction extends CharacterAction {
	override public function new(character:Character) {
		super(character, null);
	}

	override public function execute() {
		this.character.jump();
	}
}