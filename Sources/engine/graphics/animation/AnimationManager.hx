package engine.graphics.animation;

import kha.Framebuffer;
import engine.base.IEntity;
import engine.state.State;
import engine.base.Empty;

class AnimationManager extends Empty {
	public var isFlippedVertically:Bool = false;
	public var animations:Map<String, Animation> = new Map<String, Animation>();
	public var animation:Animation;
	
	public function new(x:Float, y:Float, state:State, startAnimationKey:String, animations:Map<String, Animation>) {
		super(x, y, state);
		this.animations = animations;
		this.animation = this.animations.get(startAnimationKey);
	}

	public function setVerticalFlip(isFlippedVertically) {
		this.isFlippedVertically = isFlippedVertically;
	}

	override public function setPosition(x:Float, y:Float) {
		super.setPosition(x, y);
		this.animation.setPosition(this.x, this.y);
	}

	public function set(animationKey:String) {
		this.animation = this.animations.get(animationKey);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		this.animation.isFlippedVertically = this.isFlippedVertically;
		this.animation.update(elapsed);
	}

	override public function render(framebuffer:Framebuffer) {
		super.render(framebuffer);
		this.animation.render(framebuffer);
	}
}