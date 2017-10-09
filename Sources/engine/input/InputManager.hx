package engine.input;

import kha.input.Gamepad;
import kha.input.Keyboard;
import kha.input.KeyCode;
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
	public var debug:Bool = false;
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
	public var keyboardMapping:Map<KeyCode, Button> = [
		KeyCode.W => UP,
		KeyCode.Return => START,
		KeyCode.Backspace => SELECT,
		KeyCode.Space => Y,
		KeyCode.A => LEFT,
		KeyCode.D => RIGHT,
		KeyCode.S => DOWN,
		KeyCode.J => A,
		KeyCode.L => B,
		KeyCode.K => X,
		KeyCode.U => R1,
		KeyCode.I => R2,
		KeyCode.O => L1,
		KeyCode.P => L2
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
	public function remapKeyboardKey(keyCode:KeyCode, button:Button) {
		this.keyboardMapping.set(keyCode, button);
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
	public function identifyButtonFromKey(keyCode:KeyCode):Button {
		return this.keyboardMapping.get(keyCode);
	}

	public function onKeyDown(keyCode:KeyCode):Void {
		if (debug) { trace("KeyCode : " + keyCode + " down"); }
		var button:Button = this.identifyButtonFromKey(keyCode);
		if (button != null) {
			var state = this.buttonStates.get(button);
			if (state == 0.0) {
				this.setButtonStateIfExist(button, 1.0);
			}
		}
	}

	public function onKeyUp(keyCode:KeyCode):Void {
		if (debug) { trace("KeyCode : " + keyCode + " up"); }
		var button:Button = this.identifyButtonFromKey(keyCode);
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