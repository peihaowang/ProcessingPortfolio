
class Leaf
{

  PVector    m_pos;
  PVector    m_spin;

  float      m_w;
  float      m_h;
  
  PVector    m_velLinear;
  PVector    m_velSpin;
  
  Leaf()
  {
    m_w = 0.0;
    m_h = 0.0;
    
    m_pos = new PVector(0.0, 0.0, 0.0);
    m_spin = new PVector(0.0, 0.0, 0.0);
    m_velLinear = new PVector(0.0, 0.0, 0.0);
    m_velSpin = new PVector(0.0, 0.0, 0.0);
  }
  
  void move()
  {
    m_pos.add(m_velLinear);
    //m_pos.y += (noise(m_pos.y) - 1.0) * 2;
    //m_pos.z += (noise(m_pos.z) - 1.0) * 2;
    m_spin.add(m_velSpin);
  }
  
  void draw(PGraphics g)
  {
    g.pushMatrix();
    g.translate(m_pos.x, m_pos.y, m_pos.z);
    g.rotateX(m_spin.x); g.rotateY(m_spin.y); g.rotateZ(m_spin.z);
    g.noStroke();
    g.fill(205, 52, 115);
    g.rectMode(CENTER);
    g.rect(0, 0, m_w, m_h);
    g.popMatrix();
  }

}
