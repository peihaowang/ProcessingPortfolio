class Surface
{
    Surface(GraphicsGenerator gen)
    {
      this.gen = gen;
      surface = ks.createCornerPinSurface(gen.getWidth(), gen.getHeight(), 20);
    }
    
    void draw()
    {
      PGraphics g = gen.getGraphics();
      
      surface.render(g);
    }
    
    CornerPinSurface getSurface()
    {
       return surface; 
    }
    
    GraphicsGenerator gen;
    
    CornerPinSurface surface;
}