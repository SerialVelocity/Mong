module Chunk;

import std.container : SList;

import derelict.opengl.gl;

import Block;
import GlobalVariables;

class Chunk {
	Block[16][128][16] blocks;
	SList!Block blockList;
	int[3] pos;
	
	uint vbo;
	uint texVBO;
	uint vboLen;
	bool vboReady = false;
	
	float[] vertexList;
	float[] textureCoordList;
	
	void resetVBO() {
		vertexList.length = 0;
		textureCoordList.length = 0;
		vboReady = false;
	}
	
	void addBlockToVBO(Block b) {
		float coords[2][] = b.getVertArray();
		vertexList ~= coords[0];
		textureCoordList ~= coords[1];
		vboReady = false;
	}
	
	void addBlock(int x, int y, int z) {
		blocks[x][y][z] = new Block([x, y, z], this);
		blockList.insertFront(blocks[x][y][z]);
	}
	
	this(int[3] pos) {
		this.pos[0] = pos[0];
		this.pos[1] = pos[1];
		this.pos[2] = pos[2];
		
		resetVBO();
		
		foreach(x; 0..blocks.length)
			foreach(y; 0..blocks[x].length)
				foreach(z; 0..blocks[x][y].length)
					if(pos[1]*1024+(y-groundLevel)*32+noise.generateNoise(pos[0]/32.0f+x/512.0f, pos[1]/16.0f+y/256.0f, pos[2]/32.0f+z/512.0f) < 0)
						addBlock(x, y, z);
		
		foreach(block; blockList)
			addBlockToVBO(block);
	}
	
	void vboify() {
		glGenBuffers(1, &vbo);
		glBindBuffer(GL_ARRAY_BUFFER, vbo);
		glBufferData(GL_ARRAY_BUFFER, vertexList.length * float.sizeof, vertexList.ptr, GL_STATIC_DRAW);
		glGenBuffers(1, &texVBO);
		glBindBuffer(GL_ARRAY_BUFFER, texVBO);
		glBufferData(GL_ARRAY_BUFFER, textureCoordList.length * float.sizeof, textureCoordList.ptr, GL_STATIC_DRAW);
		vboLen = vertexList.length / 3;
		vertexList.length = 0;
		textureCoordList.length = 0;
		vboReady = true;
	}
	
	uint getVBO() {
		if(!vboReady)
			vboify();
		return vbo;
	}
	
	uint getTexVBO() {
		if(!vboReady)
			vboify();
		return texVBO;
	}
	
	uint getVBOLen() {
		if(!vboReady)
			vboify();
		return vboLen;
	}
}