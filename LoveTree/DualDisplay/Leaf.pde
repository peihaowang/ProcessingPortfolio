
class Leaf
{

  PVector    m_pos;
  PVector    m_endPos;
  PVector    m_spin;

  float      m_w;
  float      m_h;
  
  color      m_stroke;
  color      m_fill;
  
  PVector    m_velLinear;
  PVector    m_velSpin;
  
  PShape     m_shape;
  
  Leaf(PShape shape)
  {
    m_w = 0.0;
    m_h = 0.0;
    
    m_shape = shape;
    m_stroke = color(0.0, 0.0, 0.0, 0.0);
    m_fill = color(0.0, 0.0, 0.0, 0.0);
    
    m_pos = new PVector(0.0, 0.0, 0.0);
    m_endPos = new PVector(0.0, 0.0, 0.0);
    m_spin = new PVector(0.0, 0.0, 0.0);
    m_velLinear = new PVector(0.0, 0.0, 0.0);
    m_velSpin = new PVector(0.0, 0.0, 0.0);
  }
  
  void flutter()
  {
    m_pos.add(m_velLinear);
    //m_pos.y += (noise(m_pos.y) - 1.0) * 2;
    //m_pos.z += (noise(m_pos.z) - 1.0) * 2;
    m_spin.add(m_velSpin);
  }
  
  void regress()
  {
    PVector diff = PVector.sub(m_endPos, m_pos); diff.mult(0.01);
    m_pos.add(diff);
    m_spin.add(m_velSpin);

    //float dist = sqrt(pow(m_endPos.x - m_pos.x, 2.0) + pow(m_endPos.y - m_pos.y, 2.0) + pow(m_endPos.z - m_pos.z, 2.0));
    //float mag = 1000 / (dist * dist);
    //PVector a = new PVector(m_endPos.x - m_pos.x, m_endPos.y - m_pos.y, m_endPos.z - m_pos.z); a.setMag(mag);
    //m_velLinear.add(a);
  }
  
  void accelerate(PVector acc)
  {
    m_velLinear.add(acc);
  }
  
  void penStyle(color stroke, color fill)
  {
    m_stroke = stroke;
    m_fill = fill;
  }
  
  void draw(PGraphics g)
  {
    g.pushMatrix();
    g.translate(m_pos.x, m_pos.y, m_pos.z);
    g.rotateX(m_spin.x); g.rotateY(m_spin.y); g.rotateZ(m_spin.z);
    g.shapeMode(CENTER);
    m_shape.setStroke(m_stroke);
    m_shape.setFill(m_fill);
    g.shape(m_shape, 0.0, 0.0);
    g.popMatrix();
  }

}
