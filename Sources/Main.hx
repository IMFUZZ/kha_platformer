package;

import kha.System;
import kha.Scheduler;
import kha.Assets;
import kha.WindowOptions;


class Main {
	public static var config:WindowOptions = {
		width: 800,
		height: 600,
        title : 'Platformer',
        windowedModeOptions : {
            resizable:false
        }
	};

	public static function main() {
		System.initEx(
			'Project',
			[config],
			function(val:Int) {}, // On window loaded
			function () { Assets.loadEverything(onAssetsLoaded); } // On init completed
		);
	}

	public static function onAssetsLoaded() {
		var game:Project = new Project();
		System.notifyOnRender(game.render);
		Scheduler.addTimeTask(game.update, 0, 1/60);
	}
}