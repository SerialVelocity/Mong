module GlobalVariables;

import ChunkManager;
import InputManager;
import NoiseManager;
import RenderManager;
import TextureManager;
import ThreadManager;

import IPlayer;
import LocalPlayer;

const static float blockHeight = 40.0f;
const static int blockHeightInt = cast(int)blockHeight;
const static float halfBlockHeight = blockHeight/2.0f;

const static int groundLevel = 64;
const static float moveSpeed = blockHeight * 5.0f;

const static int xResolution = 800;
const static int yResolution = 600;
const static int bitsPerPixel = 32;
const static bool fullscreen = false;

const static float fogDensity = blockHeight/40000.0f;
const static float fogColor[4] = [0.5295f, 0.8078f, 0.9804f, 1.0f];

shared NoiseManager noise;
ChunkManager chunk;
RenderManager render;
ThreadManager thread;
InputManager input;
TextureManager texture;
IPlayer[] players;
LocalPlayer localPlayer;

//UGH, UGLY!!! TODO: Find a way around this...
shared ChunkManager chunkShared;

static shared class GV {
	
	static bool init() {
		thread = new ThreadManager();
		render = new RenderManager();
		noise = new shared(NoiseManager)();
		chunk = new ChunkManager();
		texture = new TextureManager();
		input = new InputManager();
		
		chunkShared = cast(shared ChunkManager)chunk;
		
		if(!render.init()) return false;
		if(!input.init()) return false;
		if(!noise.init()) return false;
		if(!texture.init()) return false;
		if(!chunk.init()) return false;
		if(!thread.init()) return false;
		
		return true;
	}
	
}