import controlP5.*;

import deadpixel.keystone.*;
import processing.video.*;

Keystone ks;

CornerPinSurface surface1;
PGraphics offscreen1;

CornerPinSurface surface2;
PGraphics offscreen2;

LeftSideGen  leftSide;
RightSideGen rightSide;

void setup() {
  //size(1920, 1080, P3D);
  fullScreen(P3D, 2);
  
  leftSide  = new LeftSideGen(width/2,height);
  rightSide = new RightSideGen(width/2,height);

  ks = new Keystone(this);
  
  surface1 = ks.createCornerPinSurface(width/2, height, 20);
  surface2 = ks.createCornerPinSurface(width/2, height, 20);

  surface2.moveTo(width/2,0);
  
  offscreen1 = createGraphics(width/2, height, P3D);
  offscreen2 = createGraphics(width/2, height, P3D);
  
}




void draw() {
  
  offscreen1 = leftSide.update();
  offscreen2 = rightSide.update();
  
  background(0);
 
  surface1.render(offscreen1);
  surface2.render(offscreen2);

}






void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
  }
}
