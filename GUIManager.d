module GUIManager;

import std.stdio;

import IManagers;
import GlobalVariables;

debug import std.datetime;

class GUIManager : IManager {
	
	debug {
		private StopWatch timer;
		int frames;
		int fps;
	}
	
	bool init() {
		debug timer.start();
		return true;
	}
	
	bool update(float delta) {
		debug {
			++frames;
			if(timer.peek().seconds >= 1) {
				fps = frames;
				frames = 0;
				timer.reset();
			}
			render.renderText("FPS: " ~ std.conv.to!string(fps));
		}
		return true;
	}
	
	void cleanup() {
	}
}