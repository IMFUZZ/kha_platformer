package;

import kha.Framebuffer;
import kha.Color;
import kha.Scheduler;

import engine.Shared;
import engine.Player;
import engine.state.State;

import game.ExperimentLevel1;

class Project {
	public var before:Float = 0.0;
	public var elapsed:Float = 0.0;
	public var state:State;
	public var players:Array<Player> = new Array<Player>();

	public function new() {
		Shared.init(this);
		this.players.push(new Player(1));
		this.state = new ExperimentLevel1();
	}

	public function update(): Void {
		var currentTime:Float = Scheduler.time();
		this.elapsed = currentTime - this.before;
		this.before = currentTime;
		if (this.elapsed > 0) {
			this.state.update(this.elapsed);
		}
	}

	public function updatePlayers() {
		for (player in this.players) {
			player.update();
		}
	}

	public function render(framebuffer:Framebuffer): Void {
		framebuffer.g2.begin();
		framebuffer.g2.clear(Color.Cyan);
		this.state.render(framebuffer);
		framebuffer.g2.end();
	}
}
