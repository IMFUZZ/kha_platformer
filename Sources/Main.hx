package;

import kha.System;
import kha.Scheduler;
import kha.Assets;
import kha.WindowOptions;

class Main {
	public static var config:WindowOptions = {
		width: 1920,
		height: 1080,
		mode : Mode.Fullscreen,
        title : 'Project',
        windowedModeOptions : {
            resizable:false
        }
	};

	public static function main() {
		System.initEx(
			'Project', 
			[config],
			function(val:Int) {},
			function () { Assets.loadEverything(onAssetsLoaded); }
		);
	}

	public static function onAssetsLoaded() {
		var game:Project = new Project();
		System.notifyOnRender(game.render);
		Scheduler.addTimeTask(game.update, 0, 1/60);
	}
}