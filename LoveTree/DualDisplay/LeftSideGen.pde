
ArrayList<Leaf> g_leaves;

class LeftSideGen extends GraphicsGenerator
{
  PGraphics         g;
  PImage            m_truck;
  PShape            m_shape;

  Slider            m_slider;

  LeftSideGen(int w, int h)
  {
    // This creates the pgraphics object do not change this line
    g = createGraphics(w, h, P3D);

    // This function runs at setup so you can do your initialising code here:
    m_truck = loadImage("truck.png");

    // Create the Cardioid shape
    // Only create the curve once here to improve the efficiency
    // Every time create the leave, pass the Cardioid shape to leaf object
    m_shape = createShape();
    m_shape.beginShape();
    int steps = 24; float a = 5.0;
    for(int i = 0; i < steps; i++){
      float t = i * (2 * PI / steps);
      float x = a * (2 * cos(t) - cos(2 * t));
      float y = a*(2 * sin(t) - sin(2 * t));
      m_shape.vertex(x, y, 0.0);
    }
    m_shape.endShape(CLOSE);

    int numOfLeaves = 100;
    g_leaves = new ArrayList<Leaf>();
    for(int i = 0; i < numOfLeaves; i++){
        Leaf leaf = incubateLeaf();
        g_leaves.add(leaf);
    }
  }

  // create new leaf
  Leaf incubateLeaf()
  {
    Leaf leaf = new Leaf(m_shape);

    PVector center = new PVector(g.width / 2 - 50, g.height / 2 - 80);
    PVector endCenter = new PVector(g.width * 1.5, g.height / 2 - 80);
    float radiusX = 150.0, radiusY = 150.0;

    float rangeY = 200;
    float yOffset = random(-radiusY, radiusY);

    // Calculate the range of x to make the shape of the tree a ellipse by parametric equation
    float rangeX = sqrt((1 - (yOffset * yOffset) / (radiusY * radiusY)) * (radiusX * radiusX));
    float xOffset = random(-rangeX, rangeX);

    float z = random(20, 50);
    leaf.m_pos.set(center.x + xOffset, center.y + yOffset, z);
    leaf.m_endPos.set(endCenter.x + xOffset, endCenter.y + yOffset, z);

    // The velocity of x direction always towards right
    float Vx = random(0.0, 5.0);
    // Provide larger probability to move leaves upwards
    float Vy = random(-1.5, 0.1);
    float Vz = random(-0.2, 0.2);
    leaf.m_velLinear.set(Vx, Vy, Vz);
    
    float velSpinRange = random(-PI / 20, PI / 20);
    float Wx = random(-velSpinRange, velSpinRange);
    float Wy = random(-velSpinRange, velSpinRange);
    float Wz = random(-velSpinRange, velSpinRange);
    leaf.m_velSpin.set(Wx, Wy, Wz);

    return leaf;
  }

  PGraphics update()
  { 
    // make sure the g.beginDraw() is the first line
    g.beginDraw();      

    // All functions need a g. in front of them so they are drawn into the PGraphics object
    g.background(0);
    
    // Print copyright text
    g.fill(205, 52, 115);
    g.textSize(16);
    g.textAlign(LEFT, TOP);
    g.text("Designed by Peter Wang", 0, 0);

    // Draw the truck
    g.imageMode(CENTER);
    g.image(m_truck, g.width / 2, g.height / 2);
    
    for(Leaf l : g_leaves){
      l.penStyle(color(205, 52, 115), color(205, 52, 115, 200));
      l.draw(g);
      // Leaves flutter away
      if(l.m_pos.x <= g.width){
        l.flutter();
      }
    }
    
    // Every 20 frame, replenish the leaves
    if(frameCount % 20 == 0){
      int numOfLeaves = floor(random(8, 15));
      for(int i = 0; i < numOfLeaves; i++){
          Leaf leaf = incubateLeaf();
          g_leaves.add(leaf);
      }
    }

    // make sure g.endDraw() is the final line in the update function
    g.endDraw();
    return g;
  }
}
