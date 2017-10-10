package;

import engine.GameManager;

class Project {
	public var gameManager:GameManager;

	public function new() {
		this.gameManager = new GameManager();
		this.gameManager.start();
	}
}
