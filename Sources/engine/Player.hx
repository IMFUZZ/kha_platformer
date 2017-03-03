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
		this.inputManager = new InputManager(this);
		if (character != null) {
			this.setCharacter(character);
		}
	}

	public function update() {
		
	}

	public function setCharacter(character:Character) {
		this.detachCharacter();	
		this.character = character;
		this.character.player = this;
	}

	public function detachCharacter() {
		if (this.character != null) {
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
		if (this.character != null) {
			this.character.onButtonStateChange(inputManager, button, state);
		}
	}
}