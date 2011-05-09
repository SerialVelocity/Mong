module main;

import std.datetime;

import GameManager;
import GlobalVariables;

int main(string[] args)
{
	GameManager game = new GameManager();
	if(!game.init())
		return -1;

	StopWatch timer;
	timer.start();

	float delta;

	while(game.update(delta)) {
		delta = timer.peek().msecs / 1000.0f;
		timer.reset();
	}

	game.cleanup();

	return 0;
}
