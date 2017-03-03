package engine.graphics;

import kha.Framebuffer;
import nape.space.Space;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import nape.geom.Vec2;

import engine.state.PlayState;

class PhysSprite extends Sprite {
	public var body:Body;
	public var physicsEnabled:Bool = true;
	public var space:Space;
	public var isGrounded:Bool;

	override public function new(x:Float, y:Float, width:Float, height:Float, playState:PlayState, physicsEnabled:Bool = true) {
		super(x, y, width, height, playState);
		this.physicsEnabled = physicsEnabled;
		this.space = playState.space;
	}

	override public function update(elapsed:Float): Void {
		super.update(elapsed);
		if (this.body != null) {
			this.x = this.body.position.x;
			this.y = this.body.position.y;
			if (this.rotation != null) {
				this.rotation.angle = this.body.rotation;
			}
		}	
	}

	override public function render(framebuffer: Framebuffer): Void {
		super.render(framebuffer);
	}

	public function setBody(bodyType:BodyType, position:Vec2) {
		this.body = new Body(bodyType, position);
		this.body.cbTypes.add(cast(this.state, PlayState).anyCbType);
		this.body.shapes.add(new Polygon(Polygon.box(this.width, this.height)));
		this.body.align();
		this.body.mass = 10;
		this.body.userData.name = "any";
		this.body.userData.entity = this;
		this.enablePhysics(physicsEnabled);
	}

	public function enablePhysics(isEnable:Bool):Bool {
		if (this.body != null) {
			this.body.space = isEnable ? this.space : null;	
		}
		return this.physicsEnabled = isEnable;
	}

	public function checkIfGrounded() {
		var bodiesUnderChar:nape.phys.BodyList = this.space.bodiesInAABB(
			new nape.geom.AABB(
				this.body.bounds.x, 
				this.body.bounds.y+this.body.bounds.height, 
				this.body.bounds.width, 
				1), 
			false, true, null);
		return this.isGrounded = (bodiesUnderChar.length > 1);
	}
}
