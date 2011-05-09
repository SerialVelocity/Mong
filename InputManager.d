module InputManager;

import derelict.sdl.sdl;

import IManagers;

class InputManager : IManager {
	
	void delegate(SDL_Event)[SDLKey] keyFunctions;
	void delegate(SDL_Event) onMouseMotion;
	
	bool init() {
		return true;
	}
	
	void bindKey(SDLKey key, void function(SDL_Event) func) {
		bindKey(key, (SDL_Event e) { func(e); return; });
	}
	
	void bindKey(SDLKey key, void delegate(SDL_Event) func) {
		keyFunctions[key] = func;
	}
	
	void bindMouseMotion(void function(SDL_Event) func) {
		bindMouseMotion((SDL_Event e) { func(e); return; });
	}
	
	void bindMouseMotion(void delegate(SDL_Event) func) {
		onMouseMotion = func;
	}
	
	bool update(float delta) {
		SDL_Event event;
		
		while (SDL_PollEvent(&event)) {
			switch(event.type) {
				case SDL_QUIT:
					return false;
				case SDL_KEYDOWN:
				case SDL_KEYUP:
					if(event.key.keysym.sym in keyFunctions)
						keyFunctions[event.key.keysym.sym](event);
					break;
				case SDL_MOUSEMOTION:
					if(onMouseMotion !is null)
						onMouseMotion(event);
				default:
					break;
			}
		}
		return true;
	}
	
	void cleanup() {
	}
}