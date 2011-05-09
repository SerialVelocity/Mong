module ThreadManager;

import std.concurrency;

import IManagers;
import GlobalVariables;

class ThreadManager : IManager {
	
	Tid blockLoaderTid;
	
	bool init() {
		blockLoaderTid = spawnLinked(&blockLoader);
		return true;
	}
	
	bool update(float delta) {
		return true;
	}
	
	void addPosToBlockLoader(int[3] pos) {
		blockLoaderTid.send(pos);
	}
	
	void cleanup() {
	}
	
}

//TODO: Make it synchronized. Possibility of crashing atm
void blockLoader() {
	const int modifier = 1;
	for(;;) {
		receive((int[3] pos) {
				foreach(x; pos[0]-modifier..pos[0]+modifier+1)
					foreach(z; pos[2]-modifier..pos[2]+modifier+1)
						(cast(ChunkManager)chunkShared).loadChunk(x, pos[1], z);
			}
		);
	}
}