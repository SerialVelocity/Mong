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
	
	float[3] cameraPos;
	float[2] cameraAngle;
	
	debug {
		private StopWatch timer;
		int fps = 0;
	}
	
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
		
		debug timer.start();
		
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
		glDisable(GL_TEXTURE_2D);
		
		SDL_GL_SwapBuffers();
		
		debug {
			++fps;
			if(timer.peek().seconds >= 1) {
				writefln("FPS: %d", fps);
				fps = 0;
				timer.reset();
			}
		}
		return true;
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