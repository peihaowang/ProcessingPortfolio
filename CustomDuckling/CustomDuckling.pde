import controlP5.*;

ControlP5 cp5;

Slider sliderEyes;
Slider sliderMouth;
Slider sliderBowknot;


Button buttonAnimated;
boolean animated = true;

void setup()
{
  //size(600, 400);
  fullScreen(P2D);
  frameRate(30);
  
  cp5 = new ControlP5(this);
  
  // create a new button with name 'buttonA'
  sliderEyes = cp5.addSlider("Eye");
  sliderEyes.setPosition(10,50);
  sliderEyes.setRange(20, 40);
  sliderEyes.setSize(200,19);
  sliderEyes.setColorBackground(color(125));  // button color
  sliderEyes.setColorForeground(color(0));    // mouse over button color
  sliderEyes.setColorActive(color(45,116,211));  // button clicked color
  
  sliderMouth = cp5.addSlider("Mouth");
  sliderMouth.setPosition(10,70);
  sliderMouth.setRange(40, 80);
  sliderMouth.setSize(200,19);
  sliderMouth.setColorBackground(color(125));  // button color
  sliderMouth.setColorForeground(color(0));    // mouse over button color
  sliderMouth.setColorActive(color(45,116,211));  // button clicked color
  
  sliderBowknot = cp5.addSlider("Bowknot");
  sliderBowknot.setPosition(10,90);
  sliderBowknot.setRange(80, 140);
  sliderBowknot.setSize(200,19);
  sliderBowknot.setColorBackground(color(125));  // button color
  sliderBowknot.setColorForeground(color(0));    // mouse over button color
  sliderBowknot.setColorActive(color(45,116,211));  // button clicked color
  
  buttonAnimated = cp5.addButton("Animated");
  buttonAnimated.setSwitch(true);
  buttonAnimated.setOn();
  buttonAnimated.setValue(0);
  buttonAnimated.setPosition(10,110);
  buttonAnimated.setSize(200,19);
  buttonAnimated.setColorBackground(color(125));  // button color
  buttonAnimated.setColorForeground(color(0));    // mouse over button color
  buttonAnimated.setColorActive(color(45,116,211));  // button clicked color
}

//float yPos = -1;
float hEye = 50, hMouth = 50;
float xPos = 600, yPos = 60;
int times = 0;

void draw()
{
  background(0);
  
  pushMatrix();
  
  if(animated){
    times += 1;
    if(times < 10){
      hEye -= 4.0;
      hMouth -= 1.0;
    }else if(times > 10 && times < 20){
      hEye += 4.0;
      hMouth += 1.0;
    }
  
    if(times == 100){
      times = 0;
    }
  }

  noStroke();
  fill(255, 255, 0);
  ellipse(width / 2, height / 2, 300, 250);
  
  // Left Eye
  noStroke();
  fill(0, 0, 0);
  ellipseMode(CENTER);
  ellipse(width / 2 - 50, height / 2 - 50, sliderEyes.getValue(), hEye);
  
  // Right Eye
  noStroke();
  fill(0, 0, 0);
  ellipseMode(CENTER);
  ellipse(width / 2 + 50, height / 2 - 50, sliderEyes.getValue(), hEye);

  float bowknot = sliderBowknot.getValue();
  // Bowknot
  strokeWeight(20);
  fill(255, 0, 0);
  shapeMode(CENTER);
  beginShape();
  vertex(width / 2 - (bowknot / 2.0), height / 2 - 120 + (bowknot / 4.0));
  vertex(width / 2, height / 2 - 120);
  vertex(width / 2 - (bowknot / 2.0), height / 2 - 120 - (bowknot / 4.0));
  endShape();

  // Bowknot
  strokeWeight(20);
  fill(255, 125, 0);
  shapeMode(CENTER);
  beginShape();
  vertex(width / 2 + (bowknot / 2.0), height / 2 - 120 + (bowknot / 4.0));
  vertex(width / 2, height / 2 - 120);
  vertex(width / 2 + (bowknot / 2.0), height / 2 - 120 - (bowknot / 4.0));
  endShape();
  
  // Mouth
  strokeWeight(20);
  fill(255, 125, 0);
  shapeMode(CENTER);
  float mouth = sliderMouth.getValue();
  beginShape();
  vertex(width / 2 - mouth, height / 2 + 50);
  vertex(width / 2 - mouth / 3.0, height / 2 + 50 + hMouth);
  vertex(width / 2 + mouth / 3.0, height / 2 + 50 + hMouth);
  vertex(width / 2 + mouth, height / 2 + 50);
  endShape();
  
  popMatrix();
}

public void controlEvent(ControlEvent theEvent) 
{
  if(theEvent.getController() == buttonAnimated){
      animated = !animated;
  }
}
