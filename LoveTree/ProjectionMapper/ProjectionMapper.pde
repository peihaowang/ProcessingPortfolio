/*
  Creative coding class projection mapping project
 
 Please DO NOT change any code in any files other than LeftSideGen or RightSideGen
 
 Requirements
 ------------
 - No libraries (other than Minim sound library)
 - It can use the mouse for interaction but please not the projection mapping will effect the mouse position so you won’t be able to click on things on the screen.
 - No keyboard interaction
 - Please use comments to tell me what is happening in the code and structure the code clearly
 - Can be 2D or 3D
 
 Marking
 --------
 Code works and program runs:                     25%
 Code is well organised and easy to follow:       35%
 Creativity:                                      30%
 Presentation during class                        10%
 
 Questions?
 ----------
 Please email mail@jaysonh.com or wechat me jaysonhhh
 
 */

import deadpixel.keystone.*;
  
PMapper pMapper;
LeftSideGen leftSide;
RightSideGen rightSide;

Keystone ks;

void setup()
{
  fullScreen(P3D, 2); // second parameter is which screen to display on (1 for current screen, 2 for projector/second screen)

  ks = new Keystone(this); 

  pMapper = new PMapper();
  noCursor(); 
  
  leftSide = new LeftSideGen(width/2, height);
  rightSide = new RightSideGen(width/2, height);

  pMapper.addSurface(leftSide);
  pMapper.addSurface(rightSide);  
  ks.load();
}

void draw()
{
  background(0);

  pMapper.draw();
}

void keyPressed()
{
  if (key=='\t')
  {
    pMapper.nextSurface();
  }

  if (key== 'd')
  {
    pMapper.deleteSurface();
  }

  if (key== 'c')
  {
    ks.toggleCalibration();

    if (ks.isCalibrating())
    {
      cursor();
    } else
    {
      noCursor();
    }
  }

  if (key== 'l')
  {
    // loads the saved layout
    ks.load();
  }

  if (key== 's')
  {
    // saves the layout
    ks.save();
  }

}
