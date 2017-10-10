package engine.factories;

import kha.Image;
import kha.Assets;

class GraphicsFactory {
	static private var _images:Map<String, Image> = null;

	static public function init():Void {
		GraphicsFactory._images = new Map<String, Image>();
		for (imageName in Assets.images.names) {
			GraphicsFactory._images.set(imageName, Reflect.getProperty(Assets.images, imageName));
		}
	}

	static public function getImage(imageName:String):Image {
		return GraphicsFactory._images.get(imageName);
	}
}