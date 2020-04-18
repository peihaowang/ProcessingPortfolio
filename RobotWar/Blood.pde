
class Blood
{
  PShape m_shape;
  PVector m_pos;
  
  Blood(float x, float z)
  {
    m_pos = new PVector(x, height, z);
    
    m_shape = createShape();
    m_shape.setStroke(color(255, 0, 0, 80));
    m_shape.setFill(color(255, 0, 0, 80));
    m_shape.beginShape();
    int steps = 100;
    for(int i = 0; i < steps; i++){
      float a = TWO_PI / steps * i;
      float r = abs(noise(a) * 100) + 100;
      m_shape.vertex(m_pos.x + r * cos(a), m_pos.y, m_pos.z + r * sin(a));
    }
    m_shape.endShape(CLOSE);
  }

  void onDraw()
  {
    pushStyle();
    shapeMode(CENTER);
    shape(m_shape);
    popStyle();
  }
  
}
