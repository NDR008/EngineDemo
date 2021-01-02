program EngineRollingDemo;

{****h* EngineRollingDemo/engine.pas
* NAME
*	Rolling Engine Demo - See a four cylinder engine run.
* COPYRIGHT
*	    GNU GENERAL PUBLIC LICENSE
*		       Version 2, June 1991
*
* Copyright (z2) 1989, 1991 Free Software Foundation, Inc.
*                       59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*
*    Engine Rollign Demo, an OpenGL rolling demo of how a 4 cylinder engine works.
*    Copyright (z2) 2003  Nadir Syed
*
*    This program is free software; you can redistribute it and/or modify
*    it under the terms of the GNU General Public License as published by
*    the Free Software Foundation; either version 2 of the License, or
*    (at your option) any later version.
*
*    This program is distributed in the hope that it will be useful,
*    but WITHOUT ANY WARRANTY; without even the implied warranty of
*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*    GNU General Public License for more details.
*
*    You should have received a copy of the GNU General Public License
*    along with this program; if not, write to the Free Software
*    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*
*	The GNU GPL 2, is included with the package.
* FUNCTION
*	Learn about an engine, by viewing one run.
*	The idea is to create a rolling demo of 4 cylinders moving in an engine block.
* INPUTS
*	Blend on or not.
* RESULT
*	View demo in transperancy mode or not.
* NOTES
*	To do this program, I was learning C++, OpenGL, and Pascal simultaneously.
* 	Pitty my Linux box wasn't working.
* 	nadir008@yahoo.com, www.toyota.vze.com, Nadir Syed Sammut - NDR008.
*******
*}

{****** engine.pas/units:gl,glu,glut *
* FUNCTION
* 	gl is the main unit for opengl functionality, glu, and glut, aid opengl usage.
* NOTES
*	Requires Opengl32.dll, Glu.dll, and the Glut.dll to run this kind of compiled program.
*******
*}

uses
crt, windows, gl, glu, glut;

var
 quit, RotateState, pause: boolean;	// Whether is rotation mode on/off, and same for piston motion(pause).
 rot: float;			// Rotation angle.
 xwidth, yheight: integer;	// Window's x and y dimensions..
 delay,sl: longint;		// Slow down loop counter - to be removed by some fps system.
 four: integer;			// variable used to determine the stage count of the first piston, from which the rest can be worked out.
 fuelc : ARRAY [0..3, 0..2] of float;	// 2 Dimension Array that will contain the colors for the stages.
 counter1: integer;		// Main loop counter,
 ffile: file of float;		// The file to hold color values.
 cubetria: ARRAY [0..4, 0..3] of float;

const
 fogColor : ARRAY [0..3] of GLfloat = ( 0.1, 0.1, 0.1, 0.9);	// Fog settings.
 steps=24;							// Number of steps the pistons do.

{****f*
* NAME
*	LoadArray
* FUNCTION
*	Loads fuelc's array values.
*******
*}

procedure LoadArray;
var
a,b: integer;
color: float;

begin
  ASSIGN(ffile, 'fuelc.dat');
  RESET(ffile);
  for a:= 0 to 3 do
    for b:= 0 to 2 do
      begin
        read(ffile, color);
        fuelc[a,b]:= color;
      end;
  CLOSE(ffile);
end;

{****f* engine.pas/CentreCamera *
* NAME
*       CentreCamera
* FUNCTION
*       Sets the camera in the middle, out of the screen, ready to draw the next
* object with respect to the centre.
*******
*}

procedure CentreCamera;
begin
  glLoadIdentity;
  glTranslatef(0,0,-25);
  if RotateState = true then rot:=rot+0.2;
  glRotatef(rot, 0.1, 0.3, 0.1); 	//rotates everything by 0.05 degrees relative to each axis.
end;

{****f* engine.pas/SetView *
* NAME
*	SetWiew
* FUNCTION
*	Used to setup what portion of the 3D-world is viewed.
*******
*}

procedure SetView;
begin
  glMatrixMode(GL_PROJECTION);		// Loads the matrix responsable for the projects view.
  glLoadIdentity;			// Initialises view by loading the 'centre'.
  gluPerspective(45, 1.3, 0.1, 100);	// Sets view angle, x:y ratio, near clipping point, far clippin point.
  glMatrixMode(GL_MODELVIEW);		// Sets the position of the camera, by use of glTranslatef, the camera is moved out of the screen to see all objects from a certain distance.
  CentreCamera;
end;

{****f* engine.pas/DrawBox *
* NAME
* 	DrawBox
* FUNCTION
* 	This is used to draw a cube, glut already has its own method of doing so.
*	But making your own procedures gives more flexibility,
*	and in complex engines is probably the only way to make things right.
* INPUTS
* 	x1=width of box,
*	y1=height of box,
*	z1=debth of box.
* 	r,g,b represent red green blue for coloring the box.
*	a represents the alpha blending element (for translucency).
* NOTES
* 	glBegin and glEnd, enclose any OpenGL verteces or objects be drawn.
* glBegin(GL_QUADS), this GL_QUADS informs opengl, that the following verteces are in pairs of 4, thus a a quad. By a combination of 6 squares, a cube is then formed).
*	Note that OpenGL expects the 4 verteces of a square to be told in order rotating clockwise or anti-clockwise.
* glColor is used to tell opengl what color to draw an following verteces, values for a red, green, and blue element, as well as an alpha blending.
*******
*}

procedure DrawBox(x1,y1,z1,r,g,b,a:float);
var
  x2,y2,z2:float;
begin
  x2:=x1 / 2;		// Half width (so that x2 to the left + x2 to the right = 2*x2= x1).
  y2:=y1 / 2;		// Half height (so that y2 up + y2 down = 2*y2= y1).
  z2:=z1 / 2;		// Half tickness (so that z2 in + z2 out = 2*z2= z1).

  cubetria:= ( (-1.0, 1
  glBegin(GL_QUADS);


    glColor4f(r,g,b,a);	// Sets color of the following quads that make the cube, + the alpha component which determinds the blending.

// Back Face
    glVertex3f(-x2,  y2, -z2);
    glVertex3f( x2,  y2, -z2);
    glVertex3f( x2, -y2, -z2);
    glVertex3f(-x2, -y2, -z2);

// Front face
    glVertex3f(-x2,  y2,  z2);
    glVertex3f( x2,  y2,  z2);
    glVertex3f( x2, -y2,  z2);
    glVertex3f(-x2, -y2,  z2);

// Left Face
    glVertex3f(-x2,  y2, -z2);
    glVertex3f(-x2,  y2,  z2);
    glVertex3f(-x2, -y2,  z2);
    glVertex3f(-x2, -y2, -z2);

// Right Face
    glVertex3f( x2,  y2, -z2);
    glVertex3f( x2,  y2,  z2);
    glVertex3f( x2, -y2,  z2);
    glVertex3f( x2, -y2, -z2);

// Top Face
    glVertex3f(-x2,  y2,  z2);
    glVertex3f( x2,  y2,  z2);
    glVertex3f( x2,  y2, -z2);
    glVertex3f(-x2,  y2, -z2);

// Bottom Face
    glVertex3f(-x2,  -y2,  z2);
    glVertex3f( x2,  -y2,  z2);
    glVertex3f( x2,  -y2, -z2);
    glVertex3f(-x2,  -y2, -z2);
  glEnd;
end;

{****f* engine.pas/DrawCyl *
* NAME
* 	DrawCyl
* FUNCTION
* 	This is used to draw a box with 2 open opposite ends.
* INPUTS
* 	x1=width of box,
*	y1=height of box,
*	z1=debth of box.
* 	r,g,b represent red green blue for coloring the box.
*	a represents the alpha blending element (for translucency).
*******
*}

procedure DrawCyl(x1,y1,z1,r,g,b,a:float);
var
  x2,y2,z2:float;
begin
  x2:=x1 / 2;		// Half width (so that x2 to the left + x2 to the right = 2*x2= x1).
  y2:=y1 / 2;		// Half height (so that y2 up + y2 down = 2*y2= y1).
  z2:=z1 / 2;		// Half tickness (so that z2 in + z2 out = 2*z2= z1).
  glBegin(GL_QUADS);
    glColor4f(r,g,b,a);	// Sets color of the following quads that make the cube, + the alpha component which determinds the blending.

// Front face
    glVertex3f(-x2,  y2,  z2);
    glVertex3f( x2,  y2,  z2);
    glVertex3f( x2, -y2,  z2);
    glVertex3f(-x2, -y2,  z2);

// Back Face
    glVertex3f(-x2,  y2, -z2);
    glVertex3f( x2,  y2, -z2);
    glVertex3f( x2, -y2, -z2);
    glVertex3f(-x2, -y2, -z2);

// Left Face
    glVertex3f(-x2,  y2, -z2);
    glVertex3f(-x2,  y2,  z2);
    glVertex3f(-x2, -y2,  z2);
    glVertex3f(-x2, -y2, -z2);

// Right Face
    glVertex3f( x2,  y2, -z2);
    glVertex3f( x2,  y2,  z2);
    glVertex3f( x2, -y2,  z2);
    glVertex3f( x2, -y2, -z2);

  glEnd;
end;

{****f* engine.pas/YValue *
* NAME
*       YValue
* FUNCTION
*       You input the loop counter's value, and it will evaluate by how much must the box be translated.
* NOTES
*	This function took the most to come up with, (2 days), and I had to solve it on paper, by
*	writing down a range of values for the main loop counter, and listing next to it, what Y value
*	would I want for each of these different main loop counter values. Then I made a liner
*	mathematical equation.
*******
*}

FUNCTION YValue(count: integer): integer;
begin
  YValue:= steps-abs(count-(steps div 2));
end;

{****f* engine.pas/FuelExhaust *
* NAME
*	FuelExhaust
* FUNCTION
*	Manages filling the empty space above the piston and draws the fuel/exhaust/explosion.
* INPUTS
*	yanswer: simply half the YValue. The reason this is passed, and not calculated within
*	the procedure, is to minimise the number of times it has to be calculated.
*	i: this indicates which firing order is the piston, thus which colour should the
*	fuel/compression/explossion/exhuast be drawn.
*	c: this is simply just to indicate, if the drawin is for the 2 center pistons or the
*	2 external pistons.
*******
*}

procedure FuelExhaust(yanswer,i,c: real);
var
 fuel: real;
 four2: integer;
 v: integer;
begin
  v:= trunc(c);
  case v of
  0: begin
    four2:= trunc(four +i) mod 4;
    fuel:= (steps / 2 - yanswer) / 2;
    glTranslatef(0, (fuel+1), 0);
    DrawBox(2, (fuel*2),2,fuelc[four2,0], fuelc[four2,1], fuelc[four2,2], 0.5);
    glTranslatef(0, -(fuel+1) ,0);        //return back centre without drastic complication of re-centering view and re translating.
    end;

  1: begin
    four2:= trunc(four +i) mod 4;
    fuel:= (steps / 2 - yanswer) / 2;
    glTranslatef(0, +(3-fuel+1), 0);
    DrawBox(2, (6-(fuel*2)),2,fuelc[four2,0], fuelc[four2,1], fuelc[four2,2], 0.5);
    glTranslatef(0, -(3-fuel+1) ,0);        //return back centre without drastic complication of re-centering view and re translating.
    end;
  end;
end;

{****f* engine.pas/MovingBox *
* NAME
*       MovingBox
* FUNCTION
*       To move the box to represent the moving cylinder.
* NOTES
*	In brief, translates the camera, to draw the different objects, with their centre in different places.
*******
*}

procedure MovingBox;
var
 yanswer: real;
begin
  yanswer:= YValue(counter1 mod steps)/2;

  CentreCamera;
  glTranslatef(-6,-7.5,0);

  glTranslatef(0,yanswer,0);
  DrawBox(2,2,2,0.4,0.4,0.4,0);
  FuelExhaust(yanswer,0,0);
  glTranslatef(12,0,0);
  DrawBox(2,2,2,0.4,0.4,0.4,0);
  FuelExhaust(yanswer,2,0);

  CentreCamera;
  glTranslatef(-2, 10.5,0);

  glTranslatef(0,-yanswer,0);
  DrawBox(2,2,2,0.4,0.4,0.4,0);
  FuelExhaust(yanswer,1,1);
  glTranslatef(4,0,0);
  DrawBox(2,2,2,0.4,0.4,0.4,0);
  FuelExhaust(yanswer,3,1);
end;

{****f* engine.pas/CylinderWall *
* NAME
*	CylinderWall
* FUNCTION
*	To Draw the cylinder 'containers'
*******
*}

procedure CylinderWall;
var
  cyls: integer;
begin
  CentreCamera;
  glTranslatef(-6,1.5,0);
  for cyls := 0 to 3 do
    begin
      DrawCyl(2.2, 8.5, 2.2, 0.3, 0.1, 0.1, 20);
      glTranslatef(4,0,0);
    end;
end;

{****f* engine.pas/ClearScreen *
* NAME
*	ClearScreen
* FUNCTION
*	Clears screen for the next rendering scene
*******
*}

procedure ClearScreen;
begin
  glClearColor(0, 0, 0, 1); //clears the screen with a black color.
  glClearDepth(100.0);
  glClear(GL_COLOR_BUFFER_BIT+GL_DEPTH_BUFFER_BIT);
end;

{****f* engine.pas/keyboardcheck *
* NAME
*	keyboardcheck
* FUNCTION
* 	Checks the keyboard's keys, and alters any varriable if required.
******
*}

procedure keyboardcheck;
begin
  if GetAsyncKeyState(VK_q) <> 0 then quit:=true;		// Check state of key 1
  if GetAsyncKeyState(VK_1) <> 0 then glEnable(GL_BLEND);	// Check state of key 1
  if GetAsyncKeyState(VK_2) <> 0 then glDisable(GL_BLEND);	// Check state of key 2
  if GetAsyncKeyState(vk_r) <> 0 then RotateState := true;	// Check state of key r
  if GetAsyncKeyState(vk_s) <> 0 then RotateState := false; 	// Check state of key s
  if GetAsyncKeyState(vk_f) <> 0 then glutFullscreen;		// Check state of key f
  if (GetAsyncKeyState(vk_v) <> 0) and (delay < 99975000) then delay:=delay+25000; 	// Check state of key b
  if (GetAsyncKeyState(vk_b) <> 0) and (delay > 125000) then delay:=delay-25000;	// Check state of key v
  if (GetAsyncKeyState(vk_p) <> 0) and (counter1 mod 12 <> 0) then pause := true;	// Check state of key p
  if GetAsyncKeyState(vk_c) <> 0 then pause := false;					// Check state of key c
  if GetAsyncKeyState(vk_w) <> 0 then 							// Check state of key w
      begin
        glutReshapeWindow(xwidth, yheight);
        glutPositionWindow(10,30);
    end;
end;

{****f* engine.pas/DisplayWindow *
* NAME
*	DisplayWindow
* FUNCTION
*	This is where all the action happens. (The main loop).
* NOTES
*	Clear screen.
*	Loop pointlessly. (The delay loop).
*	Draw piston + exhuast.
*	Draw Cylinders.
*	Centre Camera.
*	Draw a box as the engine block.
*	Check keyboard.
*	Draw all till now onto screen.
*	Check whether the main counter should be incrimented, and do so if required.
*	Incriment four if required (determines what stage is the 1st piston).
*******
*}

procedure DisplayWindow;
begin
  ClearScreen;
  for sl := 1 to delay do;
  MovingBox;
  CylinderWall;
  CentreCamera;
  DrawBox(18,12,4,0.5,0.5,0.5,0.8);                              //draw engine block
  keyboardcheck;
  glPopMatrix;
  glutSwapBuffers;
  if pause=false then
   inc(counter1);
  if counter1 mod 12 = 0 then
    four:= four + 1;
end;

{****f* engine.pas/do_idle *
* NAME
*	do_idle
* FUNCTION
*	This is the procedure that is called when on idle.
*	Basicaly, it tells it to redisplay the display loop, in our case, DisplayWindow, unless
* 	the boolean variable that states whether the q button has been pressed, in which case
*	the procedure then terminates the application.
*******
*}

procedure do_idle;
begin
  if quit = true then
  halt;
    glutPostRedisplay();
end;

{****f* engine.pas/SetWindow *
* NAME
*	SetWindow
* FUNCTION
*	This is used to setup the window in the windows environment.
*	In a nutshell, the initialisation of the win32 window.
*******
*}

procedure SetWindow;
begin
  glutInitWindowSize(xwidth,yheight);
  glutInitWindowPosition(0,0);
  glutInitDisplayMode(GLUT_RGB or GLUT_DOUBLE or GLUT_DEPTH);
  glutCreateWindow('Pascal-OpenGL, FreePascalCompiler made, Rolling Engine Demo');
  glutIdleFunc( @do_idle );
  glutDisplayFunc(@DisplayWindow);
  glShadeModel(GL_SMOOTH);                              // Set some opengl drawing modes
  glEnable(GL_DEPTH_TEST);                              // Set some opengl drawing modes
  glDepthFunc(GL_LEQUAL);                               // Set some opengl drawing modes
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);    // Set some opengl drawing modes
  glBlendFunc(GL_ONE, GL_SRC_ALPHA);                    // Set How to determine blend value
  glHint(GL_FOG_HINT, GL_DONT_CARE); 	                // Fog Hint Value
  glFogf(GL_FOG_DENSITY, 0);                            // Fog Density
  glFogf(GL_FOG_START, 27.0);				// Fog Start Depth
  glFogf(GL_FOG_END, 10.0);				// Fog End Depth
  glFogi(GL_FOG_MODE, GL_LINEAR);    			// Fog Mode
  glFogfv(GL_FOG_COLOR, fogColor);  	                // Set Fog Color
  glEnable(GL_FOG);                                     // Enables GL_FOG
end;

{****f* engine.pas/ResChoice *
* NAME
*       ResChoice
* FUNCTION
*       Menu to choose at which resolution to run the program.
*******
*}

procedure ResChoice;
var
  ScreenRes:char;

begin
  repeat
    clrscr;
    gotoxy(10,3);
    writeln('Choose Resolution (choice 1to3)');
    gotoxy(11,4);
    writeln('[1] - 640x480');
    gotoxy(11,5);
    writeln('[2] - 800x600');
    gotoxy(11,6);
    writeln('[3] - 1024x800');
    ScreenRes:= readkey;
  until (ScreenRes <= '3') and (ScreenRes >= '1');
  case ScreenRes of
    '1':
      begin
        xwidth:=640;
        yheight:=480;
      end;
    '2':
      begin
        xwidth:=800;
        yheight:=600;
      end;
    '3':
      begin
        xwidth:=1024;
        yheight:=760;
      end;
  end;
  repeat
    CLRSCR;
    writeln('Enter CPU speed delay timer setting 1 to 100');
    readln(delay);
  until (delay <= 100) and (delay >= 1);
  delay:= delay * 1000000;
  CLRSCR;
  gotoxy(4,2);
  writeln('Engine Rolling Demo is about to open in a new window.');
  writeln;
  writeln('Controls:');
  writeln('1: Translucency');
  writeln('2: Solid');
  writeln('r: Rotate objects');
  writeln('s: Stand still for objects');
  writeln('f: Go to fullscreen');
  writeln('w: Go to windowed mode');
  writeln('p: Pause animation');
  writeln('c: Continue animation');
  writeln('b: Speed up animation');
  writeln('v: Slow down animation');
  writeln('q: Quit');
  writeln;
  writeln('Green: Fuel and air in');
  writeln('Organge: Compression');
  writeln('Red: Work done, explosion''s result');
  writeln('Blue: Pushing exhuast out');
  writeln;
  writeln('created by NDR008');
end;

{****f* engine.pas/init *
* NAME
*	Nameless, this is the standard main pascal loop.
* FUNCTION
*	Contains the main source which starts off everything else.
*******
*}

begin
  LoadArray;
  ResChoice;
  SetWindow;
  SetView;
  glutMainLoop;
end.
