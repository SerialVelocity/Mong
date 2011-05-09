module INoise;

enum NoiseQuality {
	FAST,
	NORMAL,
	BEST
}

shared interface INoise {
	void setFrequency(float frequency);
	void setLacunarity(float lacunarity);
	void setNoiseQuality(NoiseQuality quality);
	void setOctaveCount(int octaves);
	void setPersistence(float persistence);
	void setSeed(int seed);
	float getFrequency();
	float getLacunarity();
	NoiseQuality getNoiseQuality();
	int getOctaveCount();
	float getPersistence();
	int getSeed();
	float getValue(float x, float y, float z);
}