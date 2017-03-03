package;

import kha.System;
import kha.Scheduler;
import kha.Assets;

class Main {
	public static var config:Dynamic = {
		title: "Project",
		width: 1024,
		height: 768
	};

	public static function main() {
		System.init(config, function () {
			Assets.loadEverything(onAssetsLoaded);
		});
	}

	public static function onAssetsLoaded() {
		var game:Project = new Project();
		System.notifyOnRender(game.render);
		Scheduler.addTimeTask(game.update, 0, 1/60);
	}
}