package engine.character;

import nape.geom.Vec2;
import nape.phys.*;
import kha.Framebuffer;

import engine.state.PlayState;
import engine.graphics.PhysSprite;
import engine.input.InputManager;
import engine.character.actions.*;
import engine.graphics.Animation;

class Character extends PhysSprite {
	public var isRunning:Bool = false;
	public var walkSpeed:Int = 512;
	public var runRatio:Float = 1.25;
	public var movement:Vec2 = new Vec2(0, 0);
	public var player:Player;
	public var pendingActions:Array<CharacterAction> = new Array<CharacterAction>();
	public var animations:Array<Animation> = new Array<Animation>();
	public var animation:Animation;

	override public function new(x:Float, y:Float, width:Float, height:Float, playState:PlayState):Void {
		super(x, y, width, height, playState, true);
	}

	override public function update():Void {
		super.update();
		this.executePendingActions();
		this.move(this.movement);
		if (this.animation != null && this.rotation != null) {
			this.animation.x = this.x - this.rotation.center.x;
			this.animation.y = this.y - this.rotation.center.y;
			this.animation.update();
		}
	}

	override public function render(framebuffer:Framebuffer) {
		super.render(framebuffer);
		if (this.animation != null) {
			this.animation.render(framebuffer);
		}
	}

	override public function setBody(bodyType:BodyType, position:Vec2):Void {
		super.setBody(bodyType, position);
		this.body.allowRotation = false;
		this.body.userData.name = "character";
		this.body.userData.character = this;
		this.body.cbTypes.add(cast(this.state, PlayState).characterCbType);
	}

	public function addAnimation(animation:Animation) {
		this.animations.push(animation);
		if (this.animation == null) {
			this.animation = animation;
		}
	}

	public function executePendingActions():Void {
		while (this.pendingActions.length > 0) {
			var action:CharacterAction = pendingActions.shift();
			action.execute();
		}
	}

	public function onButtonStateChange(inputManager:InputManager, button:Button, state:Float):Void {
		var action:CharacterAction = null;
		if ([LEFT, RIGHT].indexOf(button) != -1) {
			action = new SetXMovementAction(this, inputManager);
		} else {
			// If button is pressed
			if (state != 0.0) {
				switch (button) {
					case Y: action = new JumpAction(this);
					case UP: this.state.timePaceRatio *= 2;
					case DOWN: this.state.timePaceRatio /= 2;
					default: null;
				};
			} else {
				switch (button) {
					case Y: null;
					default: null;
				};
			}
		}
		if (action != null) { this.pendingActions.push(action); }
	}

	public function move(movement:Vec2):Void {
		if (movement.length > 0) {
			var adjustedImpulse:Vec2 = movement.mul((this.isRunning ? walkSpeed*runRatio : walkSpeed), true);
			// If 'movement' is going in the same direction as the body's velocity
			if ((movement.x < 0 && this.body.velocity.x < 0) || (movement.x >= 0 && this.body.velocity.x >= 0)) {
				// If the 'adjustedImpulse' is greather than the current velocity, apply the force equal to the distance between the two 
				adjustedImpulse.x = (Math.abs(adjustedImpulse.x) > Math.abs(this.body.velocity.x)) ? (adjustedImpulse.x - this.body.velocity.x) : 0;
			}
			this.body.applyImpulse(adjustedImpulse);
			this.body.setShapeMaterials(new Material(0, 0, 0));
		} else {
			this.body.setShapeMaterials(new Material(0, 1, 2));
		}
	}

	public function setXMovement(val:Float):Void {
		this.movement.x = val;
		if (val > 1) { this.movement.normalise(); }
	}

	public function jump():Void {
		if (this.isGrounded) {
			this.body.applyImpulse(new Vec2(0, -5000));
		}
	}
}