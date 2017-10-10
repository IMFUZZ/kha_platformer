package engine;

import engine.GameManager;

class Shared {
	static public var gameManager:GameManager;

	static public function init(gameManager:GameManager) {
		Shared.gameManager = gameManager;
	}
}