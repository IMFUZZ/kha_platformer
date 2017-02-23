package engine;
import engine.character.Character;
import engine.input.InputManager;
import engine.input.IControllable;

class Player implements IControllable {
	public var id:Int;
	public var inputManager:InputManager;
	public var character:Character;

	public function new(id:Int, ?character:Character = null) {
		this.id = id;
		this.setCharacter(character);
		this.inputManager = new InputManager(this);
	}

	public function update() {}

	public function setCharacter(character:Character) {
		if (character != null) {
			this.detachCharacter();	
			this.character = character;
			this.character.player = this;
		}
	}

	public function hasCharacterAttached() {
		return (this.character != null);
	}

	public function detachCharacter() {
		if (this.hasCharacterAttached()) {
			this.character.player = null;
			this.character = null;
		}
	}

/*	public function setGamepad(gamepad:Gamepad):Void {
		this.inputManager.setGamepad(gamepad);
	}

	public function hasGamepad(?gamepadID:Int = -1):Bool {
		return this.inputManager.hasGamepad(gamepadID);
	}*/

	public function onButtonStateChange(inputManager:InputManager, button:Button, state:Float):Void {
		if (this.hasCharacterAttached()) {
			this.character.onButtonStateChange(inputManager, button, state);
		}
	}
}