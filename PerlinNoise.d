module PerlinNoise;

import INoise;
import GenericNoise;

shared class PerlinNoise : INoise {

	float frequency;
	float lacunarity;
	NoiseQuality quality;
	int octaves;
	float persistence;
	int seed;
	
	this(float frequency = 1.0, float lacunarity = 2.0, NoiseQuality quality = NoiseQuality.NORMAL, int octaves = 6, float persistence = 0.5, int seed = 0) {
		this.frequency = frequency;
		this.lacunarity = lacunarity;
		this.quality = quality;
		this.octaves = octaves;
		this.persistence = persistence;
		this.seed = seed;
	}
	
	float getValue(float x, float y, float z) {
		float value = 0.0;
		float signal = 0.0;
		float curPersistence = 1.0;
		float nx, ny, nz;
		int seed;

		x *= frequency;
		y *= frequency;
		z *= frequency;

		for (int curOctave = 0; curOctave < octaves; curOctave++) {

			// Get the coherent-noise value from the input value and add it to the
			// final result.
			seed = (this.seed + curOctave) & 0xffffffff;
			value += (GenericNoise).GradientCoherentNoise3D (x, y, z, seed, quality) * curPersistence;

			// Prepare the next octave.
			x *= lacunarity;
			y *= lacunarity;
			z *= lacunarity;
			curPersistence *= persistence;
		}

		return value;
	}
	
	void setFrequency(float frequency) {
		this.frequency = frequency;
	}
	
	void setLacunarity(float lacunarity) {
		this.lacunarity = lacunarity;
	}
	
	void setNoiseQuality(NoiseQuality quality) {
		this.quality = quality;
	}
	
	void setOctaveCount(int octaves) {
		this.octaves = octaves;
	}
	
	void setPersistence(float persistence) {
		this.persistence = persistence;
	}
	
	void setSeed(int seed) {
		this.seed = seed;
	}
	
	float getFrequency() {
		return frequency;
	}
	
	float getLacunarity() {
		return lacunarity;
	}
	
	NoiseQuality getNoiseQuality() {
		return quality;
	}
	
	int getOctaveCount() {
		return octaves;
	}
	
	float getPersistence() {
		return persistence;
	}
	
	int getSeed() {
		return seed;
	}
}