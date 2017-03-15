package engine.state;

import kha.Framebuffer;
import kha.Assets;
import engine.base.EntityContainer;
import engine.graphics.Camera;

class State extends EntityContainer {
	public var timePaceRatio:Float = 1.0;
	public var camera:Camera;
	public var width:Float;
	public var height:Float;

	override public function new(x:Float, y:Float, width:Float, height:Float) {
		super(x, y);
		this.width = width;
		this.height = height;
		this.init("state");
		this.camera = new Camera(x, y, width, height);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	override public function render(framebuffer:Framebuffer) {
		this.camera.set(framebuffer.g2);
		super.render(framebuffer);
		this.camera.unset(framebuffer.g2);
	}

	public function init(configFilename) {
		var config:Dynamic = haxe.Json.parse(
			Reflect.getProperty(
				Assets.blobs, 
				configFilename+"_json"
			).toString()
		);
		this.loadConfig(config);
	}

	public function loadConfig(config:Dynamic) {
		var elements:Array<Dynamic> = config.stage.elements;
		for (element in elements) {
			var sprite:engine.graphics.Sprite = new engine.graphics.Sprite(
				element.location.x,
				-element.location.y,
				element.dimensions.width,
				element.dimensions.height,
				this
			);
			sprite.debug = true;
			this.add(sprite);
		}
	}
}