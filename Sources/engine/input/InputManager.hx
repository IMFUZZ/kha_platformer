package engine.input;

import kha.input.Gamepad;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.Key;

enum Button {
	UP;
	LEFT;
	RIGHT;
	DOWN;
	SELECT;
	START;
	A;
	X;
	B;
	Y;
	R1;
	R2;
	L1;
	L2;
}

class InputManager {
	public var debug:Bool = true;
	public var controllable:IControllable;
	public var previousButtonStates:Array<Map<Button, Float>> = new Array();
	public var buttonStates:Map<Button, Float> = [
		UP => 0.0,
		LEFT => 0.0,
		RIGHT => 0.0,
		DOWN => 0.0,
		START => 0.0,
		SELECT => 0.0,
		A => 0.0,
		X => 0.0,
		B => 0.0,
		Y => 0.0,
		R1 => 0.0,
		R2 => 0.0,
		L1 => 0.0,
		L2 => 0.0
	];
	public var keyboardMapping:Map<String, Button> = [
		"w" => UP,
		"a" => LEFT,
		"d" => RIGHT,
		"s" => DOWN,
		"enter" => START,
		"backspace" => SELECT,
		"j" => A,
		"k" => X,
		"l" => B,
		" " => Y,
		"u" => R1,
		"i" => R2,
		"o" => L1,
		"p" => L2
	];

/*	public var gamepadMapping:Map<GamepadButton, Button> = [
		GamepadButton.A => A,
		GamepadButton.X => X,
		GamepadButton.B => B,
		GamepadButton.Y => Y,
		GamepadButton.RIGHT_SHOULDER => R1,
		GamepadButton.LEFT_SHOULDER => L1,
		GamepadButton.START => START,
		GamepadButton.BACK => SELECT,
	];
	public var gamepadDeadZone = new nape.geom.Vec2(0.2, 0.2);
	private var _gamepadID:Int = -1;*/
	
	public function new(controllable:IControllable) {
		this.controllable = controllable;
		this.setKeyboard();
	}

	// - REMAPPING INPUTS

/*	public function remapKeyboardKey(keycode:Int, button:Button) {
		this.keyboardMapping.set(keycode, button);
	}*/

/*	public function remapGamepadButton(gamepadButton:GamepadButton, button:Button) {
		this.gamepadMapping.set(gamepadButton, button);
	}*/

	// - SETTING KEYBOARD

	public function setKeyboard() {
		Keyboard.get().notify(this.onKeyDown, this.onKeyUp);
	}

	// - SETTING/UNSETTING GAMEPADS

/*	public function setGamepad(gamepad:Gamepad) {
		if (gamepad != null) {
			this._gamepadID = gamepad.id;
			gamepad.onAxisMove.add(this.onGamepadAxisMove);
			gamepad.onButtonDown.add(this.onGamepadButtonDown);
			gamepad.onButtonUp.add(this.onGamepadButtonUp);
		} else {
			this._gamepadID = -1;
		}
	}*/

/*	public function hasGamepad(?gamepadID:Int = -1):Bool {
		var hasGamepad:Bool = (this._gamepadID != -1);
		if (hasGamepad && gamepadID != -1) {
			hasGamepad = (this._gamepadID == gamepadID);
		}
		return hasGamepad;
	}*/

	// -------------------- INPUTS --------------------
	// KEYBOARD

	public function identifyButtonFromKey(key:Key, char:String):Button {
		var id:String = switch (key) {
			case UP: 'up';
			case DOWN: 'down';
			case LEFT: 'left';
			case RIGHT: 'right';
			case BACKSPACE: 'backspace';
			case TAB: 'tab';
			case ENTER: 'enter';
			case SHIFT: 'shift';
			case CTRL: 'ctrl';
			case ALT: 'alt';
			case ESC: 'esc';
			case DEL: 'del';
			case BACK: 'back';
			case CHAR: char;
			default:null;
		};
		return (id != null) ? this.keyboardMapping.get(id) : null;
	}

	public function onKeyDown(key:Key, char:String):Void {
		if (debug) { trace("Key : " + key + " | char : " + char + " down"); }
		var button:Button = identifyButtonFromKey(key, char);
		if (button != null) {
			var state = this.buttonStates.get(button);
			if (state == 0.0) {
				this.setButtonStateIfExist(button, 1.0);
			}
		}
	}

	public function onKeyUp(key:Key, char:String):Void {
		if (debug) { trace("Key : " + key + " | char : " + char + " up"); }
		var button:Button = identifyButtonFromKey(key, char);
		if (button != null) {
			var state = this.buttonStates.get(button);
			if (state != 0.0) {
				this.setButtonStateIfExist(button, 0.0);
			}
		}
	}

	/*// GAMEPAD
	public function onGamepadAxisMove(axis:GamepadAxis, value:Float):Void {
		if (debug) { trace("Axis : " + axis + " moved. Value : " + value); }
		value = (Math.abs(value) > this.gamepadDeadZone.length) ? value : 0;
		var state:Float = 1.0; // ###########
		var button:Button = null;
		switch (axis) {
			case GamepadAxis.LEFT_X:
				if (value > 0) {
					button = LEFT;
					this.buttonStates.set(RIGHT, 0.0);
					this.buttonStates.set(button, 1.0);
				} else if (value < 0) {
					button = RIGHT;
					this.buttonStates.set(LEFT, 0.0);
					this.buttonStates.set(button, 1.0);
				} else {
					this.buttonStates.set(LEFT, 0.0);
					this.buttonStates.set(RIGHT, 0.0);
				}
			case GamepadAxis.LEFT_Y:
				if (value > 0) {
					button = DOWN;
					this.buttonStates.set(UP, 0.0);
					this.buttonStates.set(DOWN, 1.0);
				} else if (value < 0) {
					button = UP;
					this.buttonStates.set(DOWN, 0.0);
					this.buttonStates.set(UP, 1.0);
				} else {
					this.buttonStates.set(DOWN, 0.0);
					this.buttonStates.set(UP, 0.0);
				}
			default:
		}
		this.setButtonStateIfExist(button, Math.abs(value), state);
	}
	public function onGamepadButtonDown(button:GamepadButton):Void {
		if (debug) { trace("Button : " + button + " pressed"); }
		var button:Button = this.gamepadMapping.get(button);
		var state = this.buttonStates.get(button);
		if (state != 1.0) {
			state = (state == JUST_PRESSED) ? 1.0 : JUST_PRESSED;
			this.setButtonStateIfExist(button, state);
		}
	}
	public function onGamepadButtonUp(button:GamepadButton):Void {
		if (debug) { trace("Button : " + button + " 0.0"); }
		var button:Button = this.gamepadMapping.get(button);
		var state = this.buttonStates.get(button);
		if (state != 0.0) {
			state = (state == JUST_RELEASED) ? 0.0 : JUST_RELEASED;
			this.setButtonStateIfExist(button, 0, state);
		}
	}*/

	public function setButtonStateIfExist(button:Button, state:Float) {
		if (button != null) { 
			this.buttonStates.set(button, state); 
			this.previousButtonStates.push([button => state]);
			if (this.previousButtonStates.length > 10) {
				this.previousButtonStates.shift();
			}
			this.controllable.onButtonStateChange(this, button, state);
		}
	}

/*	public static function assignGamepad(gamepad:Gamepad) {
		for (player in Shared.players) {
			if (!player.hasGamepad()) {
				player.setGamepad(gamepad);
				break;
			}
		}
	}

	public static function unassignGamepad(gamepad:Gamepad) {
		for (player in Shared.players) {
			if (player.hasGamepad(gamepad.id)) {
				player.setGamepad(null);
				break;
			}
		}
	}

	public static function onGamepadConnect(gamepad:Gamepad) {
		InputManager.assignGamepad(gamepad);
		gamepad.onDisconnect.add(InputManager.onGamepadDisconnect.bind(gamepad));
	}

	public static function onGamepadDisconnect(gamepad:Gamepad) {
		InputManager.unassignGamepad(gamepad);
		trace("A gamepad disconnected : " + gamepad.name);
	}*/
}