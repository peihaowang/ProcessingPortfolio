
PImage texture;

class Fragment
{

public

  color m_color;

  PVector m_originPos;
  PVector m_position;
  PVector m_rotation;
  PVector m_spin;

  PVector m_linearVel;
  PVector m_angularVel;
  PVector m_spinVel;
  
  float m_size;
  
public

  Fragment(PVector originPos)
  {
    m_originPos = originPos.copy();
    m_position = originPos.copy();
    m_rotation = new PVector();
    m_spin = new PVector();
    m_linearVel = new PVector();
    m_angularVel = new PVector();
    m_spinVel = new PVector();
    
    m_size = 10;
    m_color = texture.get(round(originPos.x), round(originPos.y));
  }
  
  void move()
  {
    float dt = 1.0 / frameRate;
    

    if(!mousePressed){
      m_position.add(PVector.mult(m_linearVel, dt));
      m_spin.add(PVector.mult(m_spinVel, dt));
      
      float diffX = texture.width / 2 - m_position.x;
      float diffY = texture.height / 2 - m_position.y;
      float diffZ = 0 - m_position.z;

    }else{
      float diffX = m_originPos.x - m_position.x;
      float diffY = m_originPos.y - m_position.y;
      float diffZ = m_originPos.z - m_position.z;

      m_position.add(new PVector(diffX * 0.1, diffY * 0.1, diffZ * 0.1));
    }
  }

  void draw()
  {
    pushMatrix();
    colorMode(RGB);
    fill(m_color);
    colorMode(HSB, 255);
    stroke(hue(m_color), saturation(m_color), brightness(m_color) - 50);
    
    translate(m_position.x, m_position.y, m_position.z);
    rotateX(m_spin.x); rotateY(m_spin.y); rotateZ(m_spin.z);
    box(m_size);
    popMatrix();
  }

}

PShape model;
PImage img;

int numOfParticals = 10000;
Fragment[] particals = new Fragment[numOfParticals]; 

void setup()
{
  size(655, 800, P3D);
  lights();

  texture = loadImage("ducle.jpg");
  
  float maxLinearVel = 300.0, maxAngularVel = PI, maxSpinVel = PI;
  for(int i = 0; i < numOfParticals; i++){
    Fragment p = new Fragment(new PVector(random(0, texture.width), random(0, texture.height), random(0, 0)));
    p.m_linearVel.set(random(-maxLinearVel, maxLinearVel), random(-maxLinearVel, maxLinearVel), random(-maxLinearVel, maxLinearVel));
    p.m_angularVel.set(random(-maxAngularVel, maxAngularVel), random(-maxAngularVel, maxAngularVel), random(-maxAngularVel, maxAngularVel));
    p.m_spinVel.set(random(-maxSpinVel, maxSpinVel), random(-maxSpinVel, maxSpinVel), random(-maxSpinVel, maxSpinVel));

    particals[i] = p;
  }
}

void draw() {
  background(0);
  for(int i = 0; i < numOfParticals; i++){
    Fragment p = particals[i];
    p.draw();
    p.move();
  }
}
