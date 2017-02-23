package;

import kha.System;
import kha.Scheduler;

class Main {
	public static function main() {
		System.init({title: "Project", width: 1024, height: 768}, function () {
			var game = new Project();
			System.notifyOnRender(game.render);
			Scheduler.addTimeTask(game.update, 0, 1/128);
		});
	}
}
