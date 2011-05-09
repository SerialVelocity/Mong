module ChunkManager;

import std.conv;

import IManagers;
import GlobalVariables;
import Chunk;

class ChunkManager : IManager {
	
	synchronized private Chunk[string] chunks;
	
	bool init() {
		return true;
	}
	
	void loadChunk(int x, int y, int z) {
		string chunkName = to!string(x) ~ "x" ~ to!string(y) ~ "x" ~ to!string(z);
		
		if(chunkName !in chunks) {
			Chunk c = new Chunk([x, y, z]);
			chunks[chunkName] = c;
		}
	}
	
	bool update(float delta) {
		foreach(chunk; chunks)
			render.renderVBO(chunk.getVBO(), chunk.getTexVBO(), chunk.getVBOLen());
		return true;
	}
	
	void cleanup() {
	}
}