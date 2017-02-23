package engine.base;

import kha.Framebuffer;

interface IEntity {
	public var x:Float;
	public var y:Float;
	public var debug:Bool;
	public function update(): Void;
	public function render(framebuffer: Framebuffer): Void;
}