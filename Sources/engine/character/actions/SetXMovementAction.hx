package engine.character.actions;

import engine.input.InputManager;

class SetXMovementAction extends CharacterAction {
	public var adjustedXAxisValue:Float = 0.0;
	override public function new(character:Character, inputManager:InputManager) {
		super(character, inputManager);
		this.adjustedXAxisValue = (-inputManager.buttonStates.get(LEFT) + inputManager.buttonStates.get(RIGHT));
	}

	override public function execute() {
		this.character.setXMovement(this.adjustedXAxisValue);
	}
}