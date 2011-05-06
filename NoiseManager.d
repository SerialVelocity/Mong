module NoiseManager;

import std.math;
import IManager;
import INoise;
import PerlinNoise;

class NoiseManager : IManager {
	INoise noiseGen;
	bool init() {
		noiseGen = new PerlinNoise();
		noiseGen.setOctaveCount(5);
		noiseGen.setLacunarity(2.3f);
		noiseGen.setPersistence(5.0f);
		return true;
	}
	
	float generateNoise(float x, float y, float z) {
		return noiseGen.getValue(x, y, z);
	}
	
	bool update(float delta) {
		return true;
	}
	
	void cleanup() {
	}
}