package engine;

import kha.Framebuffer;
import kha.System;
import kha.Scheduler;

import engine.Shared;
import engine.Player;
import engine.factories.GraphicsFactory;
import engine.state.State;


import game.ExperimentLevel1;

class GameManager {
	public var before:Float = 0.0;
	public var elapsed:Float = 0.0;
	public var state:State;
	public var players:Array<Player> = new Array<Player>();

	public function new() {
		this.init();
		this.players.push(new Player(1));
		this.state = new ExperimentLevel1("state");
	}

	public function start() {
		System.notifyOnRender(this.render);
		Scheduler.addTimeTask(this.update, 0, 1/60);
	}

	public function stop() {
		// TODO:
	}

	public function init():Void {
		Shared.init(this);
		GraphicsFactory.init();
	}

	public function update(): Void {
		this.updateElapsedTime();
		if (this.elapsed > 0) this.state.update(this.elapsed);
		this.updatePlayers();
	}

	public function updateElapsedTime() {
		var currentTime:Float = Scheduler.time();
		this.elapsed = currentTime - this.before;
		this.before = currentTime;
	}

	public function updatePlayers() {
		for (player in this.players) player.update();
	}

	public function render(framebuffer:Framebuffer): Void {
		this.state.render(framebuffer);
	}
}
