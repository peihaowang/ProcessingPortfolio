
import processing.video.*;
import de.voidplus.leapmotion.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

Minim minim;
AudioPlayer songGameOver;
AudioPlayer songBgm;
AudioPlayer songBeginning;

// Leap motion control
LeapMotion leapMotion;
Movie movieEnding;

ArrayList<Character> heldKeys;

World world;
//ArrayList<Wall> walls;
ArrayList<Obstacle> obstacles;
ArrayList<Door> door;
ArrayList<Enemy> enemies;
ArrayList<Bullet> bullets;
ArrayList<Blood> blood;
ArrayList<GiftBox> gift;

Hero me;

boolean WIN = false;

int timer = 0;
int level = 0;
int numOfAddedEnemies = 0;

PImage imgLose;
//PImage imgVictory;
ArrayList<PImage> beginScreens;

void setup()
{
  surface.setTitle("2001");
  //size(1000, 800, P3D);
  fullScreen(P3D);
  noCursor();
  smooth();
  
  leapMotion = new LeapMotion(this);
  
  movieEnding = new Movie(this, "ending.mp4");

  minim = new Minim(this);
  songGameOver = minim.loadFile("GAME_OVER.mp3");
  songBgm = minim.loadFile("Blue.mp3");
  songBeginning = minim.loadFile("Beginning.mp3");
  songBeginning.play();
  
  heldKeys = new ArrayList<Character>();
  
  imgLose = loadImage("lose.png");
  //imgVictory = loadImage("victory.png");

  beginScreens = new ArrayList<PImage>();
  for(int i = 1; i <= 6; i++){
    PImage img = loadImage("s" + i + ".png");
    img.resize(width, height);
    beginScreens.add(img);
  }

  //walls = new ArrayList<Wall>();
  obstacles = new ArrayList<Obstacle>();
  door = new ArrayList<Door>();
  blood = new ArrayList<Blood>();
  gift = new ArrayList<GiftBox>();

  JSONArray array = loadJSONArray("scene.json");
  for(int i = 0; i < array.size(); i++){
    JSONObject obj = array.getJSONObject(i);
    if(obj.getString("type").equals("world")){
      float w = obj.getFloat("width"), h = obj.getFloat("height"), d = obj.getFloat("depth");
      world = new World(w, h, d);
      gift.add(new Key());
      door.add(new Door(-world.m_size.x / 2.0, 0, "left", 1000));
      //door.add(new Door(world.m_size.x / 2.0, 0, "right", 1000));
      door.add(new Door(0, -world.m_size.z / 2.0, "back", 1000));
      door.add(new Door(0, world.m_size.z / 2.0, "front", 1000));
    }else if(obj.getString("type").equals("obstacle")){
      float x = obj.getFloat("x"), z = obj.getFloat("z");
      float w = obj.getFloat("w"), d = obj.getFloat("d");
      obstacles.add(new Obstacle(x, z, w, d, 800));
    }
  }

  me = new Hero();
  me.m_pos.set(0, height - CharacterAttr.focus().y, 0);
  me.m_orientation.y = PI;

  enemies = new ArrayList<Enemy>();
  bullets = new ArrayList<Bullet>();

}

void draw()
{
  timer++;
  if(timer < 100 * beginScreens.size()){
    int i = timer / 100;
    if(i < beginScreens.size()){
      background(beginScreens.get(i));
    }
    return;
  }else if(timer == 100 * beginScreens.size()){
    songBeginning.pause();
    songBgm.loop();
  }
  
  if(WIN){
    image(movieEnding, 0, 0, width, height);
    return;
  }
  
  // Game Scene
  if(timer % 100 == 0){
    if(enemies.isEmpty()){
      level++;
      numOfAddedEnemies = 5 * level;
    }
    if(numOfAddedEnemies > 0){
      Enemy c = new Enemy();
      int n = floor(random(0, 3));
      if(n == 0){
        c.m_pos.set(-world.m_size.x / 2 + 500, height - CharacterAttr.focus().y, 0);
      }else if(n == 1){
        c.m_pos.set(0, height - CharacterAttr.focus().y, -world.m_size.z / 2 + 500);
      }else if(n == 2){
        c.m_pos.set(0, height - CharacterAttr.focus().y, world.m_size.z / 2 - 500);
      }
      //c.m_orientation.y = PI / 6;
      enemies.add(c);
      numOfAddedEnemies--;
    }
  }

  background(0);

  beginCamera();
  pushMatrix();
  
  strokeWeight(2);

  float eyeX = me.m_pos.x, eyeY = me.m_pos.y - CharacterAttr.m_szBody.y / 2.0 - CharacterAttr.m_szHead.y / 2.0, eyeZ = me.m_pos.z;
  float centerX = eyeX + 30 * cos(me.m_orientation.x) * sin(me.m_orientation.y);
  float centerY = eyeY + 30 * sin(me.m_orientation.x);
  float centerZ = eyeZ + 30 * cos(me.m_orientation.x) * cos(me.m_orientation.y);
  camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, 0.0, 1.0, 0.0);
  perspective(PI / 3, width / height, (height/2.0) / tan(PI*60.0/360.0) / 10, (height/2.0) / tan(PI*60.0/360.0) * 100000);
  
  fill(255);
  
  world.onDraw();
  
  for(Obstacle o : obstacles){
    o.onDraw();
  }
  
  for(Door d : door){
    d.onDraw();
  }
  
  for(Blood b : blood){
    b.onDraw();
  }

  if(me.m_hp > 0 && !WIN){
    me.onHandleKeyboard();
    me.onPick();
  }
  me.onAnimated();
  me.onDraw();
    
  for(int i = enemies.size() - 1; i >= 0; i--){
    Enemy e = enemies.get(i);
    e.onAnimated();
    if(e.m_hp > 0.0){
      e.onChase();
    }else{
      if(e.m_nextStatus != Status.Dying || e.m_status != Status.Dying) e.setStatus(Status.Dying);
    }
    e.onDraw();
    if(e.done()){
      enemies.remove(e);
    }
  }
  
  for(int i = bullets.size() - 1; i >= 0; i--){
    Bullet b = bullets.get(i);
    b.onMove();
    b.onDraw();
    if(b.done()){
      bullets.remove(b);
    }
  }
  
  for(GiftBox g : gift){
    g.onDraw();
  }

  popMatrix();
  endCamera();
  
  camera(); perspective();
  pushStyle();
  stroke(0);
  fill(255);
  translate(0, 0, 500);
  final float meshSize = 1.5;
  float x = width * 0.55, y = height * 0.37;
  rect(x, y, meshSize * world.m_mapCols, meshSize * world.m_mapRows);
  for(int i = 0; i < world.m_mapRows; i++){
    for(int j = 0; j < world.m_mapCols; j++){
      if(world.m_map[i * world.m_mapCols + j] == 'X'){
        fill(0);
        rect(x + j * meshSize, y + i * meshSize, meshSize, meshSize);
      }
    }
  }
  ArrayList<CharacterBody> totalChars = new ArrayList<CharacterBody>(); totalChars.add(me); totalChars.addAll(enemies);
  for(CharacterBody c : totalChars){
    
    Coord coord = world.mapCoord(c.m_pos.x, c.m_pos.z);
    if(c == me) fill(0, 255, 0);
    else fill(255, 0, 0);
    rect(x + coord.m_x * meshSize, y + coord.m_y * meshSize, meshSize, meshSize);
  }
  popStyle();
  
  pushStyle();
  stroke(0, 255, 0);
  line(width / 2 - 10, height / 2, width / 2 + 10, height / 2);
  line(width / 2, height / 2 - 10, width / 2, height / 2 + 10);
  popStyle();
  
  pushStyle();
  fill(0, 255, 0);
  if(me.m_hp > 0) rect(width * 0.4, height * 0.37, me.m_hp / 2, 5);
  popStyle();

  pushStyle();
  for(Enemy e : enemies){
    if(e.m_attackFinished && e.canHit()){
      fill(255, 0, 0, 50);
      rect(0, 0, width, height);
    }
  }
  popStyle();
  

  if(me.m_hp <= 0){
    imageMode(CENTER);
    image(imgLose, width / 2, height / 2, 200, 200);
  }

  for(Hand hand : leapMotion.getHands()){
    PVector handPosition = hand.getPosition();
    float handGrab = hand.getGrabStrength();
    println(handPosition.x, handPosition.y);
  
    // Keep tweak the range of x, y to make the operation better
    float handX = map(handPosition.x, -200, 900, 0, width);
    float handY = map(handPosition.y, 200, 800, 0, height);
    
    onCursorMoved(handX, handY);
    if(handGrab >= 0.6){
      onCursorPressed();
    }else{
      onCursorReleased();
    }
  }
}

void onCursorMoved(float x, float y)
{
  if(lastMousePos.x >= 0 && lastMousePos.y >= 0){
    float diffX = x - lastMousePos.x, diffY = y - lastMousePos.y;
    me.spin(-atan2(diffX, 500)); me.shake(atan2(diffY, 1500));
  }
  lastMousePos.set(x, y);
}

void movieEvent(Movie m) 
{
  m.read();
}

void keyPressed()
{
  //if(key == 'j'){
  //  c.setStatus(Status.Attack);
  //}else if(key == 'k'){
  //  c.setStatus(Status.Dying);
  //}
  heldKeys.add(key);
}

void keyReleased()
{
  heldKeys.remove(new Character(key));
  if(key == 'f'){
    me.onFire();
  }
}

PVector lastMousePos = new PVector(-1.0, -1.0);
boolean cursorPressed = false;

void onCursorPressed()
{
  cursorPressed = true;
}

void onCursorReleased()
{
  if(cursorPressed){
    me.onFire();
    cursorPressed = false;
  }
}

void mouseMoved()
{
  onCursorMoved(mouseX, mouseY);
  //if(lastMousePos.x >= 0 && lastMousePos.y >= 0){
  //  float diffX = mouseX - lastMousePos.x, diffY = mouseY - lastMousePos.y;
  //  me.spin(-atan2(diffX, 500)); me.shake(atan2(diffY, 1500));
  //}
  //lastMousePos.set(mouseX, mouseY);
}

void mousePressed()
{
  onCursorPressed();
}

void mouseReleased()
{
  onCursorReleased();
}
