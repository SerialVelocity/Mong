module RenderManager;

import std.math;
import std.string;
import std.datetime;
import std.container;
import std.stdio : writefln;

import derelict.sdl.sdl;
import derelict.opengl.gl;

import IManagers;
import GlobalVariables;

class RenderManager : IManager {

	struct VBOData {
		uint vbo;
		uint texVBO;
		uint vboLen;
	}
	
	SList!VBOData vbos;
	
	string[] text;
	uint font;

	float[3] cameraPos;
	float[2] cameraAngle;
	
	bool init() {
		// initialize SDL, GL and GLU Derelict modules
		DerelictSDL.load();
		DerelictGL.load();
		
		// initialize SDL's VIDEO module
		SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER);

		// enable double-buffering
		SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

		// create our OpenGL window
		SDL_SetVideoMode(xResolution, yResolution, bitsPerPixel, SDL_OPENGL | SDL_HWSURFACE | (fullscreen ?  SDL_FULLSCREEN : 0));
		SDL_WM_SetCaption(toStringz("Mong"), null);
		
		try {
			DerelictGL.loadClassicVersions(GLVersion.GL32);
			DerelictGL.loadModernVersions(GLVersion.GL32);
			DerelictGL.loadExtensions();
		} catch (Exception e) {
			std.stdio.writefln("OpenGL is not a high enough version: %d", DerelictGL.maxVersion());
			return false;
		}
		
		glViewport(0, 0, xResolution, yResolution);
		glMatrixMode(GL_PROJECTION);
		glLoadIdentity();
		glMultMatrixd(getGluPerspective(45.0, 4.0/3.0, 1.0, 10000.0).ptr);
		glMatrixMode(GL_MODELVIEW);
		
		glEnable(GL_CULL_FACE);
		glEnable(GL_DEPTH_TEST);
		
		glClearColor(0.5295f, 0.8078f, 0.9804f, 1.0f);
		
		glEnable (GL_FOG);
		glFogi (GL_FOG_MODE, GL_EXP2);
		glFogfv (GL_FOG_COLOR, fogColor.ptr);
		glFogf (GL_FOG_DENSITY, fogDensity);
		glHint (GL_FOG_HINT, GL_FASTEST);
		
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glEnable(GL_BLEND);
		
		return true;
	}
	
	bool update(float delta) {
		glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		glLoadIdentity();
		
		glRotatef(cameraAngle[1], 1.0f, 0.0f, 0.0f);
		glRotatef(cameraAngle[0], 0.0f, 1.0f, 0.0f);
		glRotatef(180.0f, 0.0f, 0.0f, 1.0f);
		glTranslatef(cameraPos[0], cameraPos[1], cameraPos[2]);
		
		glEnable(GL_TEXTURE_2D);
		glEnableClientState(GL_VERTEX_ARRAY);
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);
		glColor4f(1.0f, 1.0f, 1.0f, 1.0f);
		foreach(vbo; vbos) {
			glBindBuffer(GL_ARRAY_BUFFER, vbo.vbo);
			glVertexPointer( 3, GL_FLOAT, 0, null);
			glBindBuffer( GL_ARRAY_BUFFER, vbo.texVBO );
			glTexCoordPointer( 2, GL_FLOAT, 0, null);
			glDrawArrays(GL_QUADS, 0, vbo.vboLen);
		}
		vbos.clear();
		glDisableClientState(GL_VERTEX_ARRAY);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);

		switchToOrthoMatrix();
		glDisable(GL_DEPTH_TEST);
		if(text.length > 0) {
			texture.enableFont();
			glColor3f(1.0f, 0.0f, 0.0f);
			glTranslatef(0, yResolution - 16, 0);
			glListBase(font);
			foreach(string line; text) {
				glCallLists(line.length,GL_UNSIGNED_BYTE,line.ptr);
				glTranslatef(cast(int)line.length*-16, -16, 0);
			}
			texture.disableFont();
			text.length = 0;
		}
		glDisable(GL_TEXTURE_2D);
		glColor3f(1.0f, 1.0f, 1.0f);
		glLoadIdentity();
		glBegin(GL_LINES);
		{
			glVertex2f(xResolution / 2.0f        , yResolution / 2.0f - 20.0f);
			glVertex2f(xResolution / 2.0f        , yResolution / 2.0f + 20.0f);
			glVertex2f(xResolution / 2.0f - 20.0f, yResolution / 2.0f);
			glVertex2f(xResolution / 2.0f + 20.0f, yResolution / 2.0f);
		}
		glEnd();
		glEnable(GL_DEPTH_TEST);
		revertProjectionMatrix();
		
		SDL_GL_SwapBuffers();
		return true;
	}

	void generateFont()
	{
		font = glGenLists(256);
		texture.enableFont();
		foreach(y; 0..16) {
			foreach(x; 0..16) {
				glNewList(font+y*16+x, GL_COMPILE);
					glBegin(GL_QUADS);
						glTexCoord2f(0.0625*(x+1), 0.0625*(y + 1));
						glVertex2i(16, 0);
						glTexCoord2f(0.0625*(x + 1), 0.0625*y);
						glVertex2i(16, 16);
						glTexCoord2f(0.0625*x, 0.0625*y);
						glVertex2i(0, 16);
						glTexCoord2f(0.0625*x, 0.0625*(y + 1));
						glVertex2i(0, 0);
					glEnd();
					glTranslated(16,0,0);
				glEndList();
			}
		}
		texture.disableFont();
	}

	static void switchToOrthoMatrix()
	{
		glMatrixMode (GL_PROJECTION);
		glPushMatrix();
		glLoadIdentity();
		glOrtho (0.0, xResolution, 0.0, yResolution, -1.0, 1.0);
		glMatrixMode(GL_MODELVIEW);
		glPushMatrix();
		glLoadIdentity();
	}

	static void revertProjectionMatrix()
	{
		glPopMatrix();
		glMatrixMode(GL_PROJECTION);
		glPopMatrix();
		glMatrixMode(GL_MODELVIEW);
	}
	
	void setCameraPosition(float[3] pos) {
		this.cameraPos = pos;
	}
	
	void setCameraAngle(float[2] angle) {
		this.cameraAngle = angle;
	}
	
	void renderVBO(uint vbo, uint texVBO, uint vboLen) {
		if(vboLen > 0) {
			VBOData vboData;
			vboData.vbo = vbo;
			vboData.texVBO = texVBO;
			vboData.vboLen = vboLen;
			vbos.insertFront(vboData);
		}
	}
	
	void renderText(string line) {
		text.length = text.length + 1;
		text[$-1] = line;
	}

	pure GLdouble[16] getGluPerspective(GLdouble fovx, GLdouble aspect, GLdouble zNear, GLdouble zFar)
	{
	   // This code is based off the MESA source for gluPerspective
	   // *NOTE* This assumes GL_PROJECTION is the current matrix

	   GLdouble xmin, xmax, ymin, ymax;
	   GLdouble m[16] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	   xmax = zNear * tan(fovx * PI / 360.0);
	   xmin = -xmax;
	   
	   ymin = xmin / aspect;
	   ymax = xmax / aspect;

	   // Set up the projection matrix
	   m[0] = (2.0 * zNear) / (xmax - xmin);
	   m[2] = (xmax + xmin) / (xmax - xmin);
	   m[5] = (2.0 * zNear) / (ymax - ymin);
	   m[6] = (ymax + ymin) / (ymax - ymin);
	   m[10] = -(zFar + zNear) / (zFar - zNear);
	   m[11] = -(2.0 * zFar * zNear) / (zFar - zNear);
	   m[14] = -1.0;
	   
	   // Add to current matrix
	   return m;
	}
	
	void cleanup() {
	}
}