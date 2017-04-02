package engine.state;

import kha.Canvas;
import kha.Assets;

import engine.base.EntityContainer;
import engine.graphics.Camera;

class State extends EntityContainer {
	public var timePaceRatio:Float = 1.0;
	public var camera:Camera;
	public var width:Float;
	public var height:Float;

	override public function new(config:String) {
		super(this);
		this.width = 1280;
		this.height = 720;
		this.camera = new Camera(0, 0, 1280, 720, this);
		this.init(config);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	override public function render(framebuffer:Canvas) {
		this.camera.begin(true, kha.Color.Cyan);
		super.render(this.camera.frame);
		this.camera.end();

		framebuffer.g2.begin();
		this.camera.render(framebuffer);
		this.camera.renderUI(framebuffer);
		framebuffer.g2.end();
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
			this.add(sprite);
		}
	}
}