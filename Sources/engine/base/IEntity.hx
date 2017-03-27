package engine.base;

import kha.Canvas;
import engine.state.State;

interface IEntity {
	// MAKE X AND Y READONLY
	public var x:Float;
	public var y:Float;
	public var debug:Bool;
	public var alive:Bool = true;
	public var state:State;
	public function update(elapsed:Float):Void;
	public function render(canvas:Canvas):Void;
	public function setPosition(x:Float, y:Float):Void;
	public function kill():Void;
	public function destroy():Void;
}