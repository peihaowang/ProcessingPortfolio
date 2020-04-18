
enum Direction{Left, Right}

PImage imgFish, imgBackground;

class Fish
{

private

  Direction m_direction = Direction.Left;
  
  float m_x = 0;
  float m_y = 0;
  
  float getScale()
  {
    return (float)m_size / 1000.0;
  }

public

  int m_size = 0;

  int m_lastTime = 0;
  int m_keepTime = 0;
  float m_velocityH = 0;
  float m_velocityV = 0;

  Fish(int size)
  {
    m_size = size;
  }

  float getX(){return m_x;}
  float getY(){return m_y;}
  
  void setPos(float x, float y)
  {
    if(m_x > x) m_direction = Direction.Left;
    else if(m_x < x) m_direction = Direction.Right;
    
    m_x = x; m_y = y;
  }
  
  float headPos()
  {
    float head = m_x + width() / 2;
    if(m_direction == Direction.Left) head -= width();
    return head;
  }
  
  float width()
  {
    return getScale() * imgFish.width;
  }
  
  float height()
  {
    return getScale() * imgFish.height;
  }
  
  void update()
  {
    setPos(m_x + m_velocityH, m_y + m_velocityV);
    
    float scale = getScale();
    float scaleX = scale, scaleY = scale;
    if(m_direction == Direction.Right){
      scaleX *= -1.0;
    }

    pushMatrix();
    translate(m_x, m_y);
    scale(scaleX, scaleY);
    imageMode(CENTER);
    image(imgFish, 0, 0);
    popMatrix();
    
    //rectMode(CENTER);
    //noFill();
    //stroke(0);
    //rect(m_x, m_y, width(), height());
  }
}

enum GameState{Prepare, Gaming, GameOver}
GameState gameState = GameState.Prepare;

int time = 0;
int score = 0;

Fish me = new Fish(60);
ArrayList<Fish> fishes = new ArrayList<Fish>();

void addFish(int size)
{
  int leftOrRight = int(random(0, 2)); float yPos = random(height);
  Fish fish = new Fish(size);
  fish.setPos(leftOrRight == 0 ? 0 : width, yPos);
  fishes.add(fish);
}

void addFishSmart()
{
  int max = 7;
  boolean hasFood = false;
  for(int i = 0; i < fishes.size(); i++){
    Fish fish = fishes.get(i);
    if(fish.m_size <= me.m_size){
      hasFood = true;
      break;
    }
  }
  if(!hasFood) max = int(me.m_size / 20) + 1;

  int size = 20 * int(random(2, max));
  addFish(size);
}

void startGame()
{
  fishes.clear();
  for(int i = 0; i < 12; i++){
    addFishSmart();
  }
  
  gameState = GameState.Gaming;
  noCursor();
  me.m_size = 60;
  score = 0;
}

void gameOver()
{
  gameState = GameState.GameOver;
  cursor(ARROW);
}

void setup()
{
  pixelDensity(displayDensity());
  //size(1000, 600);
  fullScreen();
  
  imgFish = loadImage("fish.png");
  imgBackground = loadImage("background.png"); imgBackground.resize(width * displayDensity(), height * displayDensity());
}

void movement()
{ 
  float maxVelocity = 5.0;
  int minKeep = 10, maxKeep = 100;
  
  for(int i = 0; i < fishes.size(); i++){
    Fish fish = fishes.get(i);
    
    if(time - fish.m_lastTime >= fish.m_keepTime){
      fish.m_velocityH = random(-maxVelocity, maxVelocity);
      fish.m_velocityV = random(-maxVelocity, maxVelocity);
      fish.m_keepTime = floor(random(minKeep, maxKeep));
      fish.m_lastTime = time;
    }
    
    boolean atEdge = false;
    if(fish.getX() - fish.width() / 2 <= 0){
      fish.m_velocityH = random(0, maxVelocity);
      atEdge = true;
    }else if(fish.getX() + fish.width() / 2 >= width){
      fish.m_velocityH = random(-maxVelocity, 0); 
      atEdge = true;
    }

    if(fish.getY() - fish.height() / 2 <= 0){
      fish.m_velocityV = random(0, maxVelocity);
      atEdge = true;
    }else if(fish.getY() + fish.height() / 2 >= height){
      fish.m_velocityV = random(-maxVelocity, 0); 
      atEdge = true;
    }
    
    if(atEdge){
      fish.m_keepTime = floor(random(minKeep, maxKeep));
      fish.m_lastTime = time;
    }

    fish.update();
  }

  me.setPos(mouseX, mouseY);
  me.update();
}

boolean canEat(Fish eater, Fish eatee)
{
  return eatee.getX() - eatee.width() / 2 < eater.headPos() && eater.headPos() < eatee.getX() + eatee.width() / 2
      //&& !(eatee.getY() - eatee.height() / 2 > eater.getY() + eater.height() / 2) && !(eatee.getY() + eatee.height() / 2 < eater.getY() - eater.height() / 2)
      && eater.getY() > eatee.getY() - eatee.height() / 2 && eater.getY() < eatee.getY() + eatee.height() / 2
      && eater.m_size >= eatee.m_size
      ;
}

void collision()
{
  // 2018.7.3 Detect if the fish eat the smaller fish;
  ArrayList<Fish> fishesEaten = new ArrayList<Fish>();
  for(int i = 0; i < fishes.size(); i++){
    Fish fish = fishes.get(i);

    if(canEat(fish, me)){
      gameOver();
    }else if(canEat(me, fish)){
      if(me.m_size < 120) me.m_size += 10;
      score += 10;
      fishesEaten.add(fish);
      
      // 2018.7.3 replenish fresh fishes
      addFishSmart();
    }
  }

  for(Fish fishEaten : fishesEaten){
    fishes.remove(fishEaten);
  }
}

void draw()
{
  time++;

  background(imgBackground);
  if(gameState == GameState.Prepare){
    textAlign(CENTER, TOP);
    fill(17, 97, 122);
    textFont(createFont("Monoca", 48));
    text("Big FISH eat Small FISH", width / 2, 50);

    textAlign(CENTER, CENTER);
    textSize(36);
    if(width / 2 - 100 < mouseX && mouseX < width / 2 + 100 && height / 2 - 30 < mouseY && mouseY < height / 2 + 30) fill(255, 255, 255);
    else fill(17, 97, 122);
    text("START", width / 2, height / 2);
  }else if(gameState == GameState.Gaming){
    movement();
    collision();

    textAlign(CENTER, TOP);
    textSize(20);
    text("SCORE:" + score, width / 2, 20);
  }else if(gameState == GameState.GameOver){ 
    textAlign(CENTER, CENTER);
    textSize(36);
    fill(17, 97, 122);
    text("GAME OVER", width / 2, height / 2);
  }
}

void mouseClicked()
{
  if(gameState == GameState.Prepare && width / 2 - 100 < mouseX && mouseX < width / 2 + 100 && height / 2 - 30 < mouseY && mouseY < height / 2 + 30){
     startGame();
  }else if(gameState == GameState.GameOver){
     startGame();
  }
}

void keyTyped()
{
  if(key == 'q') exit();

  if(gameState == GameState.GameOver){
     startGame();
  }
}
