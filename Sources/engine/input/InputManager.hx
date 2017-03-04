package engine.input;

import kha.input.Gamepad;
import kha.input.Keyboard;
import kha.Key;

import kha.math.Vector2;

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

	public var gamepadMapping:Map<Int, Button> = [
		1 => A,
		2 => X,
		3 => B,
		4 => Y,
		5 => R1,
		6 => L1,
		7 => START,
		8 => SELECT,
	];

	public var gamepadDeadZone = new Vector2(0.2, 0.2);
	private var _gamepadID:Int = -1;
	
	public function new(controllable:IControllable) {
		this.controllable = controllable;
		this.setKeyboard(Keyboard.get());
		this.setGamepad(Gamepad.get());
	}

	// - REMAPPING INPUTS
	public function remapKeyboardKey(char:String, button:Button) {
		this.keyboardMapping.set(char, button);
	}

	public function remapGamepadButton(gamepadButton:Int, button:Button) {
		this.gamepadMapping.set(gamepadButton, button);
	}

	// - SETTING KEYBOARD
	public function setKeyboard(keyboard:Keyboard) {
		keyboard.notify(this.onKeyDown, this.onKeyUp);
	}

	// - SETTING GAMEPADS
	public function setGamepad(gamepad:Gamepad) {
		gamepad.notify(onGamepadAxisMove, onGamepadButton);
	}

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
			default: null;
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

	// GAMEPAD
	public function identifyButtonsFromAxis(axis:Int, value:Float):Array<Button> {
		var buttons:Array<Button> = new Array<Button>();
		switch (axis) {
			// 0 LEFT ANALOG STICK (LEFT/RIGHT)
			case 0: 
				if (value > 0) {
					buttons.push(RIGHT);
				} else if (value < 0) {
					buttons.push(LEFT);
				} else {
					buttons.push(RIGHT);
					buttons.push(LEFT);
				}
			// 1 LEFT ANALOG STICK (UP/DOWN)
			case 1:
				if (value > 0) {
					buttons.push(UP);
				} else if (value < 0) {
					buttons.push(DOWN);
				} else {
					buttons.push(UP);
					buttons.push(DOWN);
				}
			// 3 RIGHT ANALOG STICK (LEFT/RIGHT)
			// 4 RIGHT ANALOG STICK (UP/DOWN)
			
			// 2 LEFT TRIGGER
			// 5 LEFT TRIGGER
			default: null;
		}
		return buttons;
	}

	public function onGamepadAxisMove(axis:Int, value:Float):Void {
		if (debug) { trace("Axis : " + axis + " moved. Value : " + value); }
		value = (Math.abs(value) > this.gamepadDeadZone.length) ? value : 0;
		var buttons:Array<Button> = this.identifyButtonsFromAxis(axis, value);
		if (buttons.length > 0) {
			for (button in buttons) {
				this.setButtonStateIfExist(button, Math.abs(value));
			}
		}
	}

	public function onGamepadButton(gamepadButton:Int, value:Float):Void {
		if (debug) { trace("Button : " + gamepadButton + " pressed"); }
		var button:Button = this.gamepadMapping.get(gamepadButton);
		if (button != null) {
			this.setButtonStateIfExist(button, Math.abs(value));
		}
	}

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
}