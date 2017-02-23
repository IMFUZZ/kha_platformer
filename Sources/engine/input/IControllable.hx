package engine.input;

import engine.input.InputManager;

interface IControllable {
	public function onButtonStateChange(inputManager:InputManager, button:Button, state:Float):Void;
}