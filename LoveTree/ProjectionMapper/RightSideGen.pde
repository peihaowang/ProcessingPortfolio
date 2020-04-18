
import processing.video.*;

import java.awt.Rectangle;

Capture g_camera = new Capture(this, Capture.list()[0]);

class RightSideGen extends GraphicsGenerator
{
  
  RightSideGen(int w, int h)
  {
    // This creates the pgraphics object do not change this line
    g = createGraphics(w, h, P3D);

    // This function runs at setup so you can do your initialising code here:
    String[] cameraList = Capture.list();
    for(int i = 0; i < cameraList.length; i++){
      println(cameraList[i]);
    }

    g_camera.start();
  }
  
  void update()
  {
    
    // make sure the g.beginDraw() is the first line
    g.beginDraw();

    // All functions need a g. in front of them so they are drawn into the PGraphics object
    if(g_camera.available()) g_camera.read();
    PImage img = g_camera; 

    if(img.width > 0 && img.height > 0){
      //img.resize(g.width, g.height);
      //g.image(img, 0, 0);
      
      float aspectRatio = (float)img.height / (float)img.width;
      if(g.width * aspectRatio < g.height){
        int w = int((float)img.height * (float)g.width / (float)g.height);
        PImage bg = img.get((img.width - w) / 2, 0, w, img.height);
        bg.resize(g.width, g.height);
        g.background(bg);
      }else if(img.height / aspectRatio > g.width){
        int h = int((float)img.width * (float)g.height / (float)g.width);
        PImage bg = img.get(0, (img.height - h) / 2, img.width, h);
        bg.resize(g.width, g.height);
        g.background(bg);
      }
      
    }
    g.pushMatrix();
    g.translate(-g.width, 0, 0);
    for(Leaf l : g_leaves){
      l.draw(g);
    }
    g.popMatrix();
  
    // Canny processing
    g.loadPixels();

    // Obtain the gray scale of each pixel
    float[] gray = new float[g.width * g.height];
    for(int x = 0; x < g.width; x++){
      for(int y= 0; y < g.height; y++){
        color c = g.pixels[y * g.width + x];
        gray[y * g.width + x] = (red(c) + green(c) + blue(c)) / 3.0;
      }
    }
    
    // Apply sobel operator
    for(int x = 1; x < g.width - 1; x++){
      for(int y= 1; y < g.height - 1; y++){
        /*
        Sobel Operator: https://en.wikipedia.org/wiki/Sobel_operator
             |+1 0 -1|              |+1 +2 +1|
        Gx = |+2 0 -2| * A     Gy = | 0  0  0| * A
             |+1 0 -1|              |-1 -2 -1|
        */
        float Gx = -gray[(y - 1) * g.width + x - 1] + gray[(y - 1) * g.width + x + 1]
          - gray[y * g.width + x - 1] - gray[y * g.width + x - 1] + gray[y * g.width + x + 1] + gray[y * g.width + x + 1]
          - gray[(y + 1) * g.width + x - 1] + gray[(y + 1) * g.width + x + 1]
          ;
        float Gy = -gray[(y - 1) * g.width + x - 1] - gray[(y - 1) * g.width + x] - gray[(y - 1) * g.width + x] - gray[(y - 1) * g.width + x + 1]
          + gray[(y + 1) * g.width + x - 1] + gray[(y + 1) * g.width + x] + gray[(y + 1) * g.width + x] + gray[(y + 1) * g.width + x + 1]
          ;
        float gradient = sqrt(Gx * Gx + Gy * Gy);
        // Faster way
        //float gradient = (abs(Gx) + abs(Gy));
  
        // threashold suppression here to make more efficient
        if(gradient > 160){
          g.pixels[y * g.width + x] = color(255);
        }else if(gradient > 50){
          g.pixels[y * g.width + x] = color(gradient);
        }else{
          g.pixels[y * g.width + x] = color(0);
        }
      }
    }
    g.updatePixels();

    // make sure g.endDraw() is the final line in the update function
    g.endDraw();
  }
}
