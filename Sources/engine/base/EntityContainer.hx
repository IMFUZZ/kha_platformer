package engine.base;

import kha.Framebuffer;

class EntityContainer implements IEntity {
	public var x:Float;
	public var y:Float;
	public var entities:Array<IEntity>;
	public var debug:Bool = false;
	
	public function new(?x:Float = 0, ?y:Float = 0, ?entities:Array<IEntity>) {
		this.x = x;
		this.y = y;
		this.entities = (entities != null) ? entities : new Array<IEntity>();
	}

	public function update(elapsed:Float) {
		for (entity in this.entities) {
			entity.update(elapsed);
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
}