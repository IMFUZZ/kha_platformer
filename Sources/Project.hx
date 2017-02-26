package;

import kha.Framebuffer;
import kha.Color;

import engine.Shared;
import engine.Player;
import engine.state.State;

import game.ExperimentLevel1;

class Project {
	public var state:State;
	public var players:Array<Player> = new Array<Player>();

	public function new() {
		Shared.init(this);
		this.players.push(new Player(1));
		this.state = new ExperimentLevel1();
	}

	public function update(): Void {
		this.state.update();
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
