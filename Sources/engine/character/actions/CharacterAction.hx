package engine.character.actions;

class CharacterAction {
	public var character:Character;
	public var param:Dynamic;
	public function new(character:Character, ?param:Dynamic = null) {
		this.character = character;
		this.param = param;
	}

	public function execute() {}
}