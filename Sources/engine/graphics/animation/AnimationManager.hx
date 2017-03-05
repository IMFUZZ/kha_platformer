package engine.graphics.animation;

import kha.Framebuffer;
import engine.base.IEntity;

class AnimationManager implements IEntity {
	public var debug:Bool = false;
	public var x:Float;
	public var y:Float;
	public var isFlippedVertically:Bool = false;
	public var animations:Map<String, Animation> = new Map<String, Animation>();
	public var animation:Animation;
	
	public function new(x:Float, y:Float, startAnimationKey:String, animations:Map<String, Animation>) {
		this.animations = animations;
		this.animation = this.animations.get(startAnimationKey);
	}

	public function setVerticalFlip(isFlippedVertically) {
		this.isFlippedVertically = isFlippedVertically;
	}

	public function setPosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function set(animationKey:String) {
		this.animation = this.animations.get(animationKey);
	}

	public function update(elapsed:Float) {
		this.animation.setPosition(this.x, this.y);
		this.animation.isFlippedVertically = this.isFlippedVertically;
		this.animation.update(elapsed);
	}

	public function render(framebuffer:Framebuffer) {
		this.animation.render(framebuffer);
	}
}