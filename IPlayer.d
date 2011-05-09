module IPlayer;

interface IPlayer {
	float[3] getPosition();
	bool update(float delta);
	void setPosition(float[3] pos);
}