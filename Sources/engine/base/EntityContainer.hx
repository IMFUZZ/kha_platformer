package engine.base;

import kha.Framebuffer;
import engine.state.State;

class EntityContainer implements IEntity {
	public var x:Float;
	public var y:Float;
	public var entities:Array<IEntity>;
	public var debug:Bool = false;
	public var state:State;
	public var alive:Bool = true;
	
	public function new(state:State, ?entities:Array<IEntity>) {
		this.x = this.y = 0;
		this.state = state;
		this.entities = (entities != null) ? entities : new Array<IEntity>();
	}

	public function setPosition(x:Float, y:Float) {}

	public function update(elapsed:Float) {
		for (entity in this.entities) {
			if (entity.alive == false) {
				entity.destroy();
			} else {
				entity.update(elapsed);
			}
		}
	}

	public function render(framebuffer:Framebuffer) {
		for (entity in this.entities) {
			entity.render(framebuffer);
		}
	}

	public function add(entity:IEntity) {
		this.entities.push(entity);
	}

	public function remove(entity:IEntity) {
		this.entities.remove(entity);
	}

	public function kill() {
		this.alive = false;
		for (entity in this.entities) {
			entity.kill();
		}
	}

	public function destroy() {
		this.state.remove(this);
	}
}