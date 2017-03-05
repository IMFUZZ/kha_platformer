package engine.character;

import nape.geom.Vec2;
import nape.phys.*;
import kha.Framebuffer;

import engine.state.PlayState;
import engine.graphics.PhysSprite;
import engine.input.InputManager;
import engine.character.actions.*;
import engine.graphics.animation.Animation;
import engine.graphics.animation.AnimationManager;

class Character extends PhysSprite {
	public var isRunning:Bool = false;
	public var walkSpeed:Int = 512;
	public var runRatio:Float = 1.25;
	public var movement:Vec2 = new Vec2(0, 0);
	public var player:Player;
	public var pendingActions:Array<CharacterAction> = new Array<CharacterAction>();
	public var animationManager:AnimationManager;
	
	public var rootAnimation:AnimationManager;
	public var rightArmAnimation:AnimationManager;
	public var LeftArmAnimation:AnimationManager;
	public var legsAnimation:AnimationManager;
	
	private var materials:Map<String, Material> = [
		'noFriction' => new Material(0, 0, 0),
		'normal' => new Material(0, 1, 2)
	];

	override public function new(x:Float, y:Float, width:Float, height:Float, playState:PlayState):Void {
		super(x, y, width, height, playState, true);
		this.animationManager = new AnimationManager(x, y, 'idle', [
			'idle' => new Animation(this.x, this.y, 64, 64, playState, 'idle', 60),
			'run' => new Animation(this.x, this.y, 64, 64, playState, 'run', 60)
		]);
		this.setBody(BodyType.DYNAMIC);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		this.executePendingActions();
		this.move(this.movement);
		this.animationManager.setPosition(this.x, this.y);
		this.animationManager.update(elapsed);
		// DJDUBE - MAKE THE CAMERA INDEPENDENT FROM IT'S TARGET (HAS TO BE UPDATED RIGHT AFTER THE TARGET)
		this.state.camera.update(elapsed);
	}

	override public function render(framebuffer:Framebuffer) {
		super.render(framebuffer);
		this.animationManager.render(framebuffer);
	}

	override public function setBody(bodyType:BodyType):Void {
		super.setBody(bodyType);
		this.body.allowRotation = false;
		this.body.userData.name = "character";
		this.body.userData.character = this;
		this.body.cbTypes.add(cast(this.state, PlayState).characterCbType);
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
			this.body.setShapeMaterials(this.materials.get('noFriction'));
		} else {
			this.body.setShapeMaterials(this.materials.get('normal'));
		}
	}

	public function setXMovement(val:Float):Void {
		this.movement.x = val;
		this.updateAnimationForXMovement();
		if (val > 1) { this.movement.normalise(); }
	}

	public function updateAnimationForXMovement():Void {
		if (this.movement.x > 0) {
			this.animationManager.isFlippedVertically = false;
			this.animationManager.set('run');
		} else if (this.movement.x < 0) {
			this.animationManager.isFlippedVertically = true;
			this.animationManager.set('run');
		} else {
			this.animationManager.set('idle');
		}
	}

	public function jump():Void {
		if (this.isGrounded) {
			this.body.applyImpulse(new Vec2(0, -5000));
		}
	}
}