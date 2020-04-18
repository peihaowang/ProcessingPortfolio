class GradientGen extends GraphicsGenerator
{
  final static int HORIZONTAL = 0;
  final static int VERTICAL   = 1;

  PGraphics gradientCanvas;

  GradientGen(color c1, color c2, int direction, int w, int h)
  {
    gradientCanvas = createGraphics(width, height);
    gradientCanvas.beginDraw();

    if (direction == GradientGen.HORIZONTAL)
    {
      float res = 2;
      gradientCanvas.noStroke();
      for (float y = 0; y < height; y+= res)
      {
        float v = (float)y / (float)height;

        color c = lerpColor(c1, c2, v) ;
        gradientCanvas.fill(c);
        gradientCanvas.rect(0, y, width, res);
      }
    } else if (direction == GradientGen.VERTICAL)
    {
      float res = 2;
      gradientCanvas.noStroke();
      for (float x = 0; x < width; x+= res)
      {
        float v = (float)x / (float)width;

        color c = lerpColor(c1, c2, v) ;
        gradientCanvas.fill(c);
        gradientCanvas.rect(x, 0, res, height);
      }
    }
    gradientCanvas.endDraw();
  }
  
  void update()
  {
    g.beginDraw();
    g.background(0, 255, 255);
    g.image(gradientCanvas, 0, 0);
    g.endDraw();
  }
}
