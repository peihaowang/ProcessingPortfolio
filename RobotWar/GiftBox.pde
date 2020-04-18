
class GiftBox
{
  
  PVector m_pos;
  PVector m_size;
  
  GiftBox(float x, float z, float size)
  {
    m_size = new PVector(size, size, size);
    m_pos = new PVector(x, height - m_size.y / 2, z);
  }
  
  void onDraw()
  {
    pushMatrix();
    shapeMode(CENTER);
    translate(m_pos.x, m_pos.y, m_pos.z);
    box(m_size.x, m_size.y, m_size.z);
    popMatrix();
  }
  
}

class Key extends GiftBox
{
  
  Key()
  {
    super(world.m_size.x / 2.0 + 500, 0, 100);
  }
  
  void onDraw()
  {
    pushStyle();
    fill(255, 0, 0);
    super.onDraw();
    popStyle();
  }
  
}
