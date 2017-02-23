package engine;

class Shared {
	static public var game:Project;
	static public function init(game:Project) {
		Shared.game = game;
	}
}