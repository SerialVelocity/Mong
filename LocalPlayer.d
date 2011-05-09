module LocalPlayer;

import std.math;

import derelict.sdl.sdl;

import IPlayer;
import GlobalVariables;

class LocalPlayer : IPlayer {
	
	float[3] pos;
	float[2] angle;
	bool moveUp;
	bool moveDown;
	bool moveForward;
	bool moveBackward;
	bool moveLeft;
	bool moveRight;
	
	this() {
		pos = [-20.0f, blockHeight * (groundLevel + 3), 10.0f];
		angle = [265.0f, 180.0f];
		render.setCameraPosition(pos);
		render.setCameraAngle(angle);
		input.bindKey(SDLK_w, &onMoveForward);
		input.bindKey(SDLK_s, &onMoveBackward);
		input.bindKey(SDLK_a, &onMoveLeft);
		input.bindKey(SDLK_d, &onMoveRight);
		input.bindKey(SDLK_UP, &onMoveUp);
		input.bindKey(SDLK_DOWN, &onMoveDown);
		input.bindMouseMotion(&onMouseMotion);
	}
	
	void onMoveUp(SDL_Event event) {
		moveUp = event.type == SDL_KEYDOWN;
	}
	
	void onMoveDown(SDL_Event event) {
		moveDown = event.type == SDL_KEYDOWN;
	}
	
	void onMoveForward(SDL_Event event) {
		moveForward = event.type == SDL_KEYDOWN;
	}
	
	void onMoveBackward(SDL_Event event) {
		moveBackward = event.type == SDL_KEYDOWN;
	}
	
	void onMoveLeft(SDL_Event event) {
		moveLeft = event.type == SDL_KEYDOWN;
	}
	
	void onMoveRight(SDL_Event event) {
		moveRight = event.type == SDL_KEYDOWN;
	}
	
	void onMouseMotion(SDL_Event event) {
		angle[0] += event.motion.xrel;
		angle[1] += event.motion.yrel;
		render.setCameraAngle(angle);
	}
	
	void setPosition(float[3] pos) {
		this.pos = pos;
	}
	
	bool update(float delta) {
		if(moveUp || moveDown) {
			pos[1] += (moveUp ? delta : -delta) * moveSpeed;
		}
		
		if(moveLeft || moveRight) {
			pos[0] -= (moveLeft ? delta : -delta) * moveSpeed * cos(angle[0] * PI / 180.0f);
			pos[2] += (moveLeft ? delta : -delta) * moveSpeed * sin(angle[0] * PI / 180.0f);
		}
		
		if(moveForward || moveBackward) {
			pos[0] += (moveForward ? delta : -delta) * moveSpeed * sin(angle[0] * PI / 180.0f);
			pos[2] += (moveForward ? delta : -delta) * moveSpeed * cos(angle[0] * PI / 180.0f);
		}
		
		if(moveUp || moveDown || moveLeft || moveRight || moveForward || moveBackward) {
			render.setCameraPosition(pos);
		}
		
		return true;
	}
	
	float[3] getPosition() {
		return pos;
	}
}