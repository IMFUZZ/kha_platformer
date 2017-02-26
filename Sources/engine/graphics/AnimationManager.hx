package engine.graphics;

import kha.Framebuffer;
import engine.base.IEntity;

class AnimationManager implements IEntity {
	public var debug:Bool = false;
	public var x:Float = 0.0;
	public var y:Float = 0.0;
	public var target:IEntity;
	public var animations:Map<String, Animation> = new Map<String, Animation>();
	
	public function new(x:Float, y:Float, startAnimationKey:String, animations:Map<String, Animation>) {
		
		this.animations = animations;
		this.animation = this.animations.get(startAnimationKey);
	}

	public function update() {
		this.animation.update();
	}

	public function render(frambuffer:Framebuffer) {
		this.animation.render(framebuffer);
	}
}