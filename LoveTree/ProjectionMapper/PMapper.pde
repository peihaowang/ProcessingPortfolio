class PMapper
{
  PMapper()
  {
    selectOverlay = createGraphics(width, height, P3D);
    selectOverlay.beginDraw();
    selectOverlay.background(0, 0, 0, 0);
    selectOverlay.strokeWeight(2);
    selectOverlay.stroke(255);
    selectOverlay.noFill();
    selectOverlay.rect(1, 1, width-1, height-1);
    selectOverlay.line(1, 1, width-1, height-1);
    selectOverlay.line(width-1, 1, 1, height-1);
    selectOverlay.endDraw();
  }

  void draw()
  {
    for (int i = 0; i < surfaceList.size(); i++)
    {
      Surface s=surfaceList.get(i);


      s.draw(); 
      if (i == selectedSurface)
      {
        s.getSurface().render( selectOverlay );
      }
    }
  }

  void deleteSurface()
  {
    if (surfaceList.size() >=0)
    {
      surfaceList.remove(selectedSurface);
    }
  }
  void nextSurface()
  {
    selectedSurface++;
    if (selectedSurface >= surfaceList.size())
      selectedSurface = -1;
  }

  void addSurface(GraphicsGenerator gen)
  {
    surfaceList.add(new Surface(gen));
  }
  PGraphics selectOverlay;
  int selectedSurface=-1;
  ArrayList <Surface> surfaceList = new <Surface>ArrayList();
}
