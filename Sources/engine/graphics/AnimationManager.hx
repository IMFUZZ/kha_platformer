package engine.graphics;

import kha.Framebuffer;
import engine.base.IEntity;

class AnimationManager implements IEntity {
	public var debug:Bool = false;
	public var x:Float = 0.0;
	public var y:Float = 0.0;
	public var target:IEntity;
	public var isFlippedVertically:Bool = false;
	public var animations:Map<String, Animation> = new Map<String, Animation>();
	public var animation:Animation;
	
	public function new(x:Float, y:Float, startAnimationKey:String, animations:Map<String, Animation>) {
		this.animations = animations;
		this.animation = this.animations.get(startAnimationKey);
	}

	public function set(animationKey:String) {
		this.animation = this.animations.get(animationKey);
	}

	public function update(elapsed:Float) {
		this.animation.x = this.x;
		this.animation.y = this.y;
		this.animation.isFlippedVertically = this.isFlippedVertically;
		this.animation.update(elapsed);
	}

	public function render(framebuffer:Framebuffer) {
		this.animation.render(framebuffer);
	}
}