abstract class GraphicsGenerator
{
  GraphicsGenerator()
  {
    println("graphgen");
    g = createGraphics(width, height, P3D);
  }

  int getWidth()
  {
    return g.width;
  }

  int getHeight()
  {
    return g.height;
  }
  
  abstract void update();

  PGraphics getGraphics()
  {
    update();
    return g;
  }

  PGraphics g;
}
