package engine.base;

import kha.Framebuffer;

interface IEntity {
	// MAKE X AND Y READONLY
	public var x:Float;
	public var y:Float;
	public var debug:Bool;
	public function update(elapsed:Float):Void;
	public function render(framebuffer:Framebuffer):Void;
	public function setPosition(x:Float, y:Float):Void;
}