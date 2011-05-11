module TextureManager;

import std.string : toStringz;
import std.stdio : writefln;

import derelict.opengl.gl;
import derelict.opengl.extfuncs : glGenerateMipmap;
import derelict.devil.il;

import IManagers;

class TextureManager : IManager {
	uint texture;
	uint font;
	bool init() {
		DerelictIL.load();
		
		ilInit();
		ilEnable(IL_ORIGIN_SET);
		ilOriginFunc(IL_ORIGIN_UPPER_LEFT);
		
		font = loadImage("data\\font.gif", true);
		texture = loadImage("data\\terrain.png");
		return true;
	}
	
	void enableFont() {
		glBindTexture(GL_TEXTURE_2D, font);
	}

	void disableFont() {
		glBindTexture(GL_TEXTURE_2D, texture);
	}

	bool update(float delta) {
		return true;
	}
	
	void cleanup() {
	}
	
	// Function load a image, turn it into a texture, and return the texture ID as a GLuint for use
	GLuint loadImage(const char* theFileName, bool containsAlpha = false)
	{
		ILuint imageID;
		GLuint textureID;
		ilGenImages(1, &imageID);
		ilBindImage(imageID);
		
		if (ilLoadImage(theFileName)) {
			if (!ilConvertImage(containsAlpha ? IL_RGBA : IL_RGB, IL_UNSIGNED_BYTE)) {
				writefln("Image conversion failed - IL reports error: ", ilGetError());
				return 0;
			}
 
			glGenTextures(1, &textureID);
			glBindTexture(GL_TEXTURE_2D, textureID);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR_MIPMAP_LINEAR);
			glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR_MIPMAP_LINEAR);
			glGenerateMipmap(GL_TEXTURE_2D);
			glTexImage2D(GL_TEXTURE_2D, 0, ilGetInteger(IL_IMAGE_BPP), ilGetInteger(IL_IMAGE_WIDTH), ilGetInteger(IL_IMAGE_HEIGHT),
						 0, ilGetInteger(IL_IMAGE_FORMAT), GL_UNSIGNED_BYTE, ilGetData());
 		} else {
			writefln("Image load failed - IL reports error: %d", ilGetError());
			return 0;
  		}
 
 		ilDeleteImages(1, &imageID);
		return textureID;
	}
}