void setup()
{
  size(600, 800);
  background(255);
}

int time = 0;

boolean pressed = false;
boolean go = false;

int getColor1()
{
  int c = 0;
  if(time % 100 < 50){
    c = time % 100 + 205;
  }else{
    c = 255 - (time % 100 - 50);
  }
  return c;
}

int getColor2()
{
  int c = 0;
  if(time % 140 < 70){
    c = time % 140 + 185;
  }else{
    c = 255 - (time % 140 - 70);
  }
  return c;
}

int getColor3()
{
  int c = 0;
  if(time % 120 < 60){
    c = 255 - time % 120;
  }else{
    c = (time % 120 - 60) + 195;
  }
  return c;
}

void draw()
{
  time++;
  
  rectMode(CORNER);
  
  strokeWeight(5);
  stroke(0); //<>//
  
  fill(getColor1(), 0, 0, getColor1());
  rect(50, 50, 250, 250);
  
  fill(getColor3(), 0, 0, getColor1());
  arc(50 + 250, 50 + 250, 200, 200, PI, HALF_PI * 3, PIE);
  
  fill(getColor2(), getColor2(), 0, getColor1());
  rect(300, 50, 250 * 0.618, 250 / 2);

  fill(getColor1(), getColor1(), getColor1(), getColor1());
  rect(300, 50 + 250 / 2, 250 * 0.618 / 2, 250 / 2);

  fill(getColor2(), getColor2(), getColor2(), getColor1());
  rect(300 + 250 * 0.618 / 2, 50 + 250 / 2, 250 * 0.618 / 2, 250 / 2);
  
  fill(0, 0, 0, getColor1());
  rect(50, 50 + 250, 125, 125);
  
  fill(getColor1(), getColor1(), getColor1(), getColor1());
  rect(50 + 125, 250 + 50, 125, 125 / 2);
  
  fill(getColor3(), getColor3(), getColor3(), getColor1());
  rect(50 + 125, 250 + 50 + 125 / 2, 125, 125 / 2);
  
  fill(getColor1(), getColor1(), getColor1(), getColor1());
  rect(50 + 125, 250 + 50, 125, 125 / 2);
  
  fill(getColor3(), getColor3(), getColor3(), getColor1());
  rect(50 + 250, 250 + 50, 250 * 0.618, 125 / 2);
  
  fill(0, 0, getColor2(), getColor1());
  rect(50 + 250, 250 + 50 + 125 / 2, 250 * 0.618, 250 * 0.618  - 125 / 2);
  
  fill(getColor3(), getColor3(), getColor3(), getColor2());
  rect(50, 250 + 125 + 50, 125, 250 * (0.618 - 0.5));
  
  fill(0, 0, 0, getColor1());
  rect(125 + 50, 250 + 125 + 50, 125, 250 * (0.618 - 0.5));
    
  fill(getColor2(),getColor2(), getColor2(), getColor3());
  arc(50 + 250 - 100, 50 + 250, 200, 200, 0, PI, PIE);
  
  noStroke();
  
  int i = 0;
  while(i < 5){
    float x = random(600);
    float y = random(800);
    rectMode(CENTER);
    fill(x % 255, y % 255, (x + y) % 255);
    ellipse(x, y, x / 10, x / 10);
    i++;
  }
}

void mousePressed()
{
  pressed = true;
}

void mouseReleased()
{
  pressed = false;
}

void mouseClicked()
{
  go = true;
}
