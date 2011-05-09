module GameManager;

import IManagers;
import GlobalVariables;
import LocalPlayer;

static class GameManager : IManager {
	bool init() {
		GV.init();
		players.length = 1;
		players[0] = new LocalPlayer();
		thread.addPosToBlockLoader([0,0,0]);
		return true;
	}
	
	bool update(float delta) {
		bool retVal = true;
		retVal &= input.update(delta);
		retVal &= thread.update(delta);
		retVal &= chunk.update(delta);
		foreach(player; players)
			retVal &= player.update(delta);
		retVal &= render.update(delta);
		return retVal;
	}
	
	void cleanup() {
	}
}