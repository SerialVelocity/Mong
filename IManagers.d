module IManagers;

interface IManager
{
	bool init();				//Returns true if initialisation succeeds
	bool update(float delta);	//Returns false if game should end
	void cleanup();				//Runs when program is exiting
}

shared interface IManagerShared
{
	bool init();				//Returns true if initialisation succeeds
	bool update(float delta);	//Returns false if game should end
	void cleanup();				//Runs when program is exiting
}