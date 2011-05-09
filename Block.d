module Block;

import Chunk;
import GlobalVariables;

class Block {
	Chunk parent;
	int[3] pos;
	float[3] worldPos;
	
	this(int[3] pos, Chunk parent)
	{
		this.parent = parent;
		this.pos[0] = pos[0];
		this.pos[1] = pos[1];
		this.pos[2] = pos[2];
		worldPos = [pos[0]*blockHeight,pos[1]*blockHeight,pos[2]*blockHeight];
	}
	
	bool blockAbove() {
		return pos[1] < 127 && parent.blocks[pos[0]][pos[1]+1][pos[2]];
	}
	
	bool blockBelow() {
		return pos[1] > 0  && parent.blocks[pos[0]][pos[1]-1][pos[2]];
	}
	
	bool blockRight() {
		return pos[0] > 0 && parent.blocks[pos[0]-1][pos[1]][pos[2]];
	}
	
	bool blockLeft() {
		return pos[0] < 15 && parent.blocks[pos[0]+1][pos[1]][pos[2]];
	}
	
	bool blockBack() {
		return pos[2] > 0 && parent.blocks[pos[0]][pos[1]][pos[2]-1];
	}
	
	bool blockFront() {
		return pos[2] < 15 && parent.blocks[pos[0]][pos[1]][pos[2]+1];
	}
	
	float[][2] getVertArray()
	{
		float[] vertices;
		float[] textureCoords;
		
		float modX = -parent.pos[0]*16*blockHeightInt-worldPos[0];
		float modY = -parent.pos[1]*16*blockHeightInt-worldPos[1];
		float modZ = -parent.pos[2]*16*blockHeightInt-worldPos[2];
		if(!blockAbove) {
			vertices ~= [modX-halfBlockHeight,modY-halfBlockHeight,modZ+halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY-halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY-halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY-halfBlockHeight,modZ+halfBlockHeight];
			textureCoords ~= [0.0f, 0.0625f, 0.0625f, 0.0625f, 0.0625f, 0.0f, 0.0f, 0.0f];
		}
		if(!blockBelow) {
			vertices ~= [modX+halfBlockHeight,modY+halfBlockHeight,modZ+halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY+halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY+halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY+halfBlockHeight,modZ+halfBlockHeight];
			textureCoords ~= [0.125f, 0.0f, 0.125f, 0.0625f, 0.1875f, 0.0625f, 0.1875f, 0.0f];
		}
		if(!blockRight) {
			vertices ~= [modX+halfBlockHeight,modY-halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY+halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY+halfBlockHeight,modZ+halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY-halfBlockHeight,modZ+halfBlockHeight];
			if(blockAbove)
				textureCoords ~= [0.125f, 0.0f, 0.125f, 0.0625f, 0.1875f, 0.0625f, 0.1875f, 0.0f];
			else
				textureCoords ~= [0.1875f, 0.0f, 0.1875f, 0.0625f, 0.25f, 0.0625f, 0.25f, 0.0f];
		}
		if(!blockLeft) {
			vertices ~= [modX-halfBlockHeight,modY-halfBlockHeight,modZ+halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY+halfBlockHeight,modZ+halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY+halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY-halfBlockHeight,modZ-halfBlockHeight];
			if(blockAbove)
				textureCoords ~= [0.125f, 0.0f, 0.125f, 0.0625f, 0.1875f, 0.0625f, 0.1875f, 0.0f];
			else
				textureCoords ~= [0.1875f, 0.0f, 0.1875f, 0.0625f, 0.25f, 0.0625f, 0.25f, 0.0f];
		}
		if(!blockBack) {
			vertices ~= [modX+halfBlockHeight,modY-halfBlockHeight,modZ+halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY+halfBlockHeight,modZ+halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY+halfBlockHeight,modZ+halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY-halfBlockHeight,modZ+halfBlockHeight];
			if(blockAbove)
				textureCoords ~= [0.125f, 0.0f, 0.125f, 0.0625f, 0.1875f, 0.0625f, 0.1875f, 0.0f];
			else
				textureCoords ~= [0.1875f, 0.0f, 0.1875f, 0.0625f, 0.25f, 0.0625f, 0.25f, 0.0f];
		}
		if(!blockFront) {
			vertices ~= [modX-halfBlockHeight,modY-halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX-halfBlockHeight,modY+halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY+halfBlockHeight,modZ-halfBlockHeight];
			vertices ~= [modX+halfBlockHeight,modY-halfBlockHeight,modZ-halfBlockHeight];
			if(blockAbove)
				textureCoords ~= [0.125f, 0.0f, 0.125f, 0.0625f, 0.1875f, 0.0625f, 0.1875f, 0.0f];
			else
				textureCoords ~= [0.1875f, 0.0f, 0.1875f, 0.0625f, 0.25f, 0.0625f, 0.25f, 0.0f];
		}
		return [vertices, textureCoords];
	}
}