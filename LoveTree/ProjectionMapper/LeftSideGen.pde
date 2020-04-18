
ArrayList<Leaf> g_leaves;

class LeftSideGen extends GraphicsGenerator
{

  PImage            m_truck;

  LeftSideGen(int w, int h)
  {
    // This creates the pgraphics object do not change this line
    g = createGraphics(w, h, P3D);

    // This function runs at setup so you can do your initialising code here:
    m_truck = loadImage("truck.png");

    g_leaves = new ArrayList<Leaf>();
    for(int i = 0; i < 100; i++){
        Leaf leaf = incubateLeaf();
        g_leaves.add(leaf);
    }
  }

  Leaf incubateLeaf()
  {
    Leaf leaf = new Leaf();

    PVector center = new PVector(g.width / 2 - 50, g.height / 2 - 80);
    float radiusX = 150.0, radiusY = 150.0;

    float rangeY = 200;
    float yOffset = random(-radiusY, radiusY);

    float rangeX = sqrt((1 - (yOffset * yOffset) / (radiusY * radiusY)) * (radiusX * radiusX));
    float xOffset = random(-rangeX, rangeX);

    float z = random(0, -50);
    leaf.m_pos.set(center.x + xOffset, center.y + yOffset, z);

    float Vx = random(0.0, 2.0);
    float Vy = random(-0.5, 0.1);
    float Vz = random(-0.1, 0.1);
    leaf.m_velLinear.set(Vx, Vy, Vz);
    
    float velSpinRange = random(-PI / 20, PI / 20);
    float Wx = random(-velSpinRange, velSpinRange);
    float Wy = random(-velSpinRange, velSpinRange);
    float Wz = random(-velSpinRange, velSpinRange);
    leaf.m_velSpin.set(Wx, Wy, Wz);

    leaf.m_w = leaf.m_h = 20.0;

    return leaf;
  }

  void update()
  { 
    // make sure the g.beginDraw() is the first line
    g.beginDraw();      

    // All functions need a g. in front of them so they are drawn into the PGraphics object
    g.background(0);
    
    g.stroke(255);
    g.textSize(20);
    g.textAlign(LEFT, TOP);
    g.text("Made by Peter Wang", 0, 0);

    g.imageMode(CENTER);
    g.image(m_truck, g.width / 2, g.height / 2);
    
    for(Leaf l : g_leaves){
      l.draw(g);
      l.move();
    }
    
    if(frameCount % 20 == 0){
      int numOfLeaves = floor(random(2, 15));
      for(int i = 0; i < numOfLeaves; i++){
          Leaf leaf = incubateLeaf();
          g_leaves.add(leaf);
      }
    }

    // make sure g.endDraw() is the final line in the update function
    g.endDraw();
  }
}
