import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;

Arduino arduino;
int[] pins = {2, 3, 4, 5};
int ldrPin = 0;

enum Direction{Left, Right, Up, Down}
 
class Node{
  
public

  Node        m_before = null;
  Node        m_after = null;
  
  Direction   m_direction = null;
  
  float       m_w = 20;
  float       m_h = 20;
   
  float       m_x = m_w / 2;
  float       m_y = m_h / 2;
  
  float       m_vel;
  
  Node()
  {
    return;
  }
  
  Node(Node before)
  {
    m_before = before;
    before.m_after = this;
    
    if(before.m_direction == Direction.Left){
      m_x = m_before.m_x + m_w / 2; m_y = m_before.m_y;
    }else if(before.m_direction == Direction.Right){
      m_x = m_before.m_x - m_w / 2; m_y = m_before.m_y;
    }else if(before.m_direction == Direction.Up){
      m_x = m_before.m_x; m_y = m_before.m_y + m_h / 2;
    }else if(before.m_direction == Direction.Down){
      m_x = m_before.m_x; m_y = m_before.m_y - m_h / 2;
    }
  }
  
  //Direction direction()
  //{
  //  Direction ret = null;
  //  if(m_before.m_x == m_x && m_before.m_y < m_y){
  //    ret = Direction.Up;
  //  }else if(m_before.m_x == m_x && m_before.m_y > m_y){
  //    ret = Direction.Down;
  //  }else if(m_before.m_x < m_x && m_before.m_y == m_y){
  //    ret = Direction.Left;
  //  }else if(m_before.m_x > m_x && m_before.m_y == m_y){
  //    ret = Direction.Right;
  //  }
  //  return ret;
  //}
  
  void move(float x, float y)
  {
    if(m_after != null){
      m_after.move(m_x, m_y);
    }
    m_x = x;
    m_y = y;
  }
  
  void collisionDetection()
  {
    for(int i = 0; i < foods.size(); i++){
      Food food = foods.get(i);
      if(abs(m_x - food.m_x) < m_w / 2 + food.m_w / 2 && abs(m_y - food.m_y) < m_h / 2 + food.m_h / 2){
        int pin = pins[food.m_colorIndx];
        for(int j = 0; j < pins.length; j++){
          arduino.digitalWrite(pins[j], pins[j] == pin ? Arduino.HIGH : Arduino.LOW);
        }
        foods.remove(food);
      }
    }
  }
  
  void update()
  {  
    float x = m_x, y = m_y;
    if(m_before != null){
      if(m_direction != m_before.m_direction){
        m_direction = m_before.m_direction;
      }
    }else{
      if(m_direction == Direction.Left){
        x -= m_vel;
      }else if(m_direction == Direction.Right){
        x += m_vel;
      }else if(m_direction == Direction.Up){
        y -= m_vel;
      }else if(m_direction == Direction.Down){
        y += m_vel;
      }
      move(x, y);
      collisionDetection();
    }
    
    if(m_after != null) m_after.update();
    
    if(m_before == null){
      fill(255, 0, 0);
    }else{
      fill(0, 255, 0);
    }
    noStroke();
    rectMode(CENTER);
    rect(m_x, m_y, m_w, m_h);
  }
}

class Food
{
  
public

  float m_x;
  float m_y;
  
  float m_w;
  float m_h;
  
  color m_c;
  int   m_colorIndx;
  float m_vel;

public

  void draw()
  {
    noStroke();
    fill(m_c);
    rectMode(CENTER);
    rect(m_x, m_y, m_w, m_h);
  }

}

int numOfFood = 100;
int lengthOfSnake = 60;
Node head = new Node();
ArrayList<Food> foods = new ArrayList<Food>();
color[] availableColors = {color(255, 0, 0), color(255, 255, 0), color(0, 255, 0), color(255, 255, 255)};

void setup()
{
  head.m_direction = Direction.Right;

  Node before = head;
  for(int i = 0; i <lengthOfSnake; i++){
    Node n = new Node(before);
    before = n;
  }

  for(int i = 0; i < numOfFood; i++){
    Food food = new Food();
    food.m_x = random(0, width);
    food.m_y = random(0, height);
    food.m_w = 50;
    food.m_h = 50;
    food.m_colorIndx = floor(random(0, 4));
    food.m_c = availableColors[food.m_colorIndx];
    foods.add(food);
  }

  size(800, 800);
  println(Arduino.list());
  
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  for(int i = 0; i < pins.length; i++){
    arduino.pinMode(pins[i], Arduino.OUTPUT);
  }
}

int time = 0;
void draw()
{
  background(0);
  for(int i = 0; i < foods.size(); i++){
    Food food = foods.get(i);
    food.draw();
  }
  
  int ldr = arduino.analogRead(ldrPin);
  head.m_vel = map(ldr, 1000, 0, 0, 15);
  println(ldr, head.m_vel);
  head.update();
}

void keyPressed()
{
  if(key == 'w'){
    head.m_direction = Direction.Up;
  }else if(key == 's'){
    head.m_direction = Direction.Down;
  }else if(key == 'a'){
    head.m_direction = Direction.Left;
  }else if(key == 'd'){
    head.m_direction = Direction.Right;
  }
}
