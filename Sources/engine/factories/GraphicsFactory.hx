package engine.factories;

import kha.Image;
import kha.Assets;

class GraphicsFactory {
	static public function getImage(filename:String):Image {
		return Reflect.getProperty(Assets.images, filename);
	}
}