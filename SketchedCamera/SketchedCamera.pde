import gab.opencv.*;
import processing.video.*;

import java.awt.Rectangle;

Movie movie;
Capture camera;

void setup()
{
  size(1280, 720);
  
  String[] cameraList = Capture.list();
  for(int i = 0; i < cameraList.length; i++){
    println(cameraList[i]);
  }
  
  camera = new Capture(this, cameraList[0]);
  camera.start();
}

void draw()
{
  if(camera.available()) camera.read();
  
  PImage img = camera;
  float[] gray = new float[img.width * img.height];
  for(int x = 0; x < img.width; x++){
    for(int y= 0; y < img.height; y++){
      color c = img.get(x, y);
      gray[y * img.width + x] = (red(c) + green(c) + blue(c)) / 3.0;
    }
  }
    
  PImage output = createImage(img.width, img.height, RGB);
  output.loadPixels();
  
  for(int x = 1; x < img.width - 1; x++){
    for(int y= 1; y < img.height - 1; y++){
      /*
      Sobel Operator: https://en.wikipedia.org/wiki/Sobel_operator
           |+1 0 -1|              |+1 +2 +1|
      Gx = |+2 0 -2| * A     Gy = | 0  0  0| * A
           |+1 0 -1|              |-1 -2 -1|
      */
      float Gx = -gray[(y - 1) * width + x - 1] + gray[(y - 1) * width + x + 1]
        - gray[y * width + x - 1] - gray[y * width + x - 1] + gray[y * width + x + 1] + gray[y * width + x + 1]
        - gray[(y + 1) * width + x - 1] + gray[(y + 1) * width + x + 1]
        ;
      float Gy = -gray[(y - 1) * width + x - 1] - gray[(y - 1) * width + x] - gray[(y - 1) * width + x] - gray[(y - 1) * width + x + 1]
        + gray[(y + 1) * width + x - 1] + gray[(y + 1) * width + x] + gray[(y + 1) * width + x] + gray[(y + 1) * width + x + 1]
        ;
      float gradient = sqrt(Gx * Gx + Gy * Gy);

      // threashold suppression here to make more efficient
      if(gradient > 160){
        output.pixels[y * width + x] = color(255);
      }else if(gradient > 50){
        output.pixels[y * width + x] = color(gradient);
      }else{
        output.pixels[y * width + x] = color(0);
      }
    }
  }
  output.updatePixels();
  image(output, 0, 0);
}
