
enum Status{None, Stop, Walk, Attack, Dying, Dead};

static class CharacterAttr
{
  static PVector m_szHead = new PVector(100, 100, 100);
  static PVector m_szBody = new PVector(180, 300, 150);
  static PVector m_szArm = new PVector(50, 180, 50);
  static PVector m_szLeg = new PVector(50, 200, 50);

  static PVector focus()
  {
    return new PVector(m_szBody.x / 2.0, m_szLeg.y + m_szBody.y / 2.0, m_szBody.z / 2.0);
  }

  static PVector AABBSize()
  {
    //float w = m_szBody.x, d = m_szArm.y + m_szBody.z / 2.0;
    float w = m_szBody.x, d = m_szArm.y * 2;
    float a = max(w, d);
    return new PVector(a, m_szLeg.y + m_szBody.y + m_szHead.y, a);
  }

}

class CharacterBody
{

  int m_timer;
  
  PVector m_pos;
  PVector m_orientation;
  
  float m_rotBody;
  float m_rotArm;
  float m_rotLeg;
  
  Status m_status;
  Status m_nextStatus;
  
  boolean m_attackFinished;

  float m_hp;

  CharacterBody()
  {
    m_timer = 0;

    m_pos = new PVector(0.0, 0.0, 0.0);
    m_orientation = new PVector(0.0, 0.0, 0.0);
    
    m_rotBody = 0.0;
    m_rotArm = HALF_PI;
    m_rotLeg = 0.0;
    
    m_status = Status.Stop;
    m_nextStatus = Status.None;
    
    m_attackFinished = false;
    
    m_hp = 100.0;

  }

  void setStatus(Status status) { if(m_status != status) m_nextStatus = status; }
  
  boolean done() { return m_status == Status.Dead; }
  
  boolean wallCollision()
  {
    return false;
    //boolean collision = false;
    //ArrayList<Wall> totalWalls = new ArrayList<Wall>(); totalWalls.addAll(walls); totalWalls.addAll(world.m_walls);
    //for(Wall w : totalWalls){
    //  float startX = w.m_pos.x, startZ = w.m_pos.z;
    //  float endX = w.endPos().x, endZ = w.endPos().z;
    //  if(startX > endX){ float tmp = startX; startX = endX; endX = tmp; }
    //  if(startZ > endZ){ float tmp = startZ; startZ = endZ; endZ = tmp; }
    //  if(w.m_size.x != 0.0){
    //    collision = m_pos.z - CharacterAttr.AABBSize().z / 2 < startZ && startZ < m_pos.z + CharacterAttr.AABBSize().z / 2
    //      && !(m_pos.x + CharacterAttr.AABBSize().x / 2 < startX || m_pos.x - CharacterAttr.AABBSize().x / 2 > endX)
    //      ;
    //  }else if(w.m_size.z != 0.0){
    //    collision = m_pos.x - CharacterAttr.AABBSize().x / 2 < w.m_pos.x && w.m_pos.x < m_pos.x + CharacterAttr.AABBSize().x / 2
    //      && !(m_pos.z + CharacterAttr.AABBSize().z / 2 < startZ || m_pos.z - CharacterAttr.AABBSize().z / 2 > endZ)
    //      ;
    //  }
      
    //  if(collision) break;
    //}
    
    //Coord coord = world.mapCoord(m_pos.x, m_pos.z);
    //return world.m_map[coord.m_y * world.m_mapCols + coord.m_x] == 'X';
  }

  boolean bodyCollision()
  {
    return false;
    //boolean collision = false;
    //ArrayList<CharacterBody> totalChars = new ArrayList<CharacterBody>(); totalChars.add(me); totalChars.addAll(enemies);
    //for(CharacterBody c : totalChars){
    //  if(c == this) continue;
    //  collision = abs(m_pos.x - c.m_pos.x) < CharacterAttr.AABBSize().x / 2 + CharacterAttr.AABBSize().x / 2
    //    && abs(m_pos.z - c.m_pos.z) < CharacterAttr.AABBSize().z / 2 + CharacterAttr.AABBSize().z / 2
    //    ;

    //  if(collision) break;
    //}
    //return collision;
  }
  
  boolean doorCollision()
  {
    return false;
  }
  
  boolean AABBCollision()
  {
    boolean collision = false;
    if(doorCollision()) return false;
    if(!collision) collision = wallCollision();
    if(!collision) collision = bodyCollision();
    return collision;
  }

    //if(!collision){
    //  ArrayList<CharacterBody> totalChars = new ArrayList<CharacterBody>(); totalChars.add(me); totalChars.addAll(enemies);
    //  for(CharacterBody c : totalChars){
    //    if(c == this) continue;
    //    collision = abs(m_pos.x - c.m_pos.x) < CharacterAttr.AABBSize().x / 2 + CharacterAttr.AABBSize().x / 2
    //      && abs(m_pos.z - c.m_pos.z) < CharacterAttr.AABBSize().z / 2 + CharacterAttr.AABBSize().z / 2
    //      ;

    //    if(collision) break;
    //  }
    //}


    //if(!collision){
    //  Coord coord = world.mapCoord(m_pos.x, m_pos.z);
    //  if(world.m_map[coord.m_y * world.m_mapCols + coord.m_x] == 'X'){
    //    collision = true;
    //  }
    //}
    //return collision;
  //}
  
  void forward(float dist)
  {
    float dx = dist * sin(m_orientation.y);
    float dz = dist * cos(m_orientation.y);
    m_pos.x += dx; m_pos.z += dz;

    //if(this instanceof Enemy) println("Dectect", AABBCollision(), wallCollision());
    if(AABBCollision()){
      m_pos.x -= dx; m_pos.z -= dz;
    }
  }
  
  void shift(float dist)
  {
    float dx = dist * cos(m_orientation.y);
    float dz = dist * sin(m_orientation.y);
    m_pos.x += dx; m_pos.z -= dz;
      
    if(AABBCollision()){
      m_pos.x -= dx; m_pos.z += dz;
    }
  }
  
  void spin(float angle)
  {
    m_orientation.y += angle;
  }
  
  void shake(float angle)
  {
    m_orientation.x += angle;
    if(!(-PI / 6 < m_orientation.x && m_orientation.x < PI / 6)){
      m_orientation.x -= angle;
    }
  }
  
  void onHit()
  {
    forward(-50.0);

    if(m_hp <= 0){
      setStatus(Status.Dying);
    }
    
    Blood b = new Blood(m_pos.x, m_pos.z);
    blood.add(b);
  }
  
  void onAttackFinished() { return; }

  void onAnimated()
  {
    if(m_status == Status.Walk){
      m_rotLeg = (PI / 6) * sin(float(m_timer) / 20.0);
      if(m_nextStatus != Status.None){
        if(m_rotLeg < 0.01){
          m_rotLeg = 0.0;
          m_status = m_nextStatus;
          m_nextStatus = Status.None;
          m_timer = 0;
        }
      }
    }else if(m_status == Status.Attack){
      float t = float(m_timer) / 20.0;
      m_rotArm += (PI / 60) * cos(t);
      if(t >= TWO_PI){
        if(m_nextStatus != Status.None){
          m_status = m_nextStatus;
          m_nextStatus = Status.None;
        }else{
          m_status = Status.None;
        }
        m_rotArm = HALF_PI;
        m_timer = 0;
        m_attackFinished = false;
      }else if(t >= HALF_PI * 3 && !m_attackFinished){
        m_attackFinished = true;
        onAttackFinished();
      }
    }else if(m_status == Status.Dying){
      float t = float(m_timer) / 40.0 + HALF_PI;
      float a = HALF_PI * (1.0 - sin(t));
      m_rotBody = (t > PI ? HALF_PI : a);
      if(m_timer >= 100){
        m_status = Status.Dead;
        m_timer = 0;
        if((this instanceof Enemy) && random(1.0) > 0.5){
          gift.add(new GiftBox(m_pos.x, m_pos.z, 80));
        }else if(this instanceof Hero){
          songBgm.pause();
          songGameOver.play();
        }
      }
    }else if(m_status == Status.Stop){
      if(m_nextStatus != Status.None){
        m_status = m_nextStatus;
        m_nextStatus = Status.None;
        m_timer = 0;
      }
    }
  }
  
  void onDraw()
  {
    m_timer++;

    shapeMode(CENTER);

    pushMatrix();
    pushStyle();

    translate(m_pos.x, m_pos.y, m_pos.z);
    //noFill();
    //box(CharacterAttr.AABBSize().x, CharacterAttr.AABBSize().y, CharacterAttr.AABBSize().z);
    rotateY(m_orientation.y);
    
    translate(0.0, CharacterAttr.m_szBody.y / 2.0 + CharacterAttr.m_szLeg.y, 0.0);
    rotateX(m_rotBody);
    translate(0.0, -CharacterAttr.m_szBody.y / 2.0 - CharacterAttr.m_szLeg.y, 0.0);
    
    // Draw body
    box(CharacterAttr.m_szBody.x, CharacterAttr.m_szBody.y, CharacterAttr.m_szBody.z);
    
    // Draw head
    pushMatrix();
    translate(0.0, -CharacterAttr.m_szBody.y / 2.0 - CharacterAttr.m_szHead.y / 2.0, 0.0);
    box(CharacterAttr.m_szHead.x, CharacterAttr.m_szHead.y, CharacterAttr.m_szHead.z);
    popMatrix();
    
    // Draw arms
    // Left
    pushMatrix();
    translate(-CharacterAttr.m_szBody.x / 2.0 - CharacterAttr.m_szArm.x / 2.0, -CharacterAttr.m_szArm.y / 2.0, 0.0);
    rotateX(m_rotArm);
    translate(0.0, CharacterAttr.m_szArm.y / 2.0, 0.0);
    box(CharacterAttr.m_szArm.x, CharacterAttr.m_szArm.y, CharacterAttr.m_szArm.z);
    popMatrix();
    // Right
    pushMatrix();
    translate(CharacterAttr.m_szBody.x / 2.0 + CharacterAttr.m_szArm.x / 2.0, -CharacterAttr.m_szArm.y / 2.0, 0.0);
    rotateX(m_rotArm);
    translate(0.0, CharacterAttr.m_szArm.y / 2.0, 0.0);
    box(CharacterAttr.m_szArm.x, CharacterAttr.m_szArm.y, CharacterAttr.m_szArm.z);
    popMatrix();
    
    // Draw legs
    // Left
    pushMatrix();
    translate(-CharacterAttr.m_szBody.x / 2.0 + CharacterAttr.m_szLeg.x / 2.0, CharacterAttr.m_szBody.y / 2.0, 0.0);
    rotateX(-m_rotLeg);
    translate(0.0, CharacterAttr.m_szLeg.y / 2.0, 0.0);
    box(CharacterAttr.m_szLeg.x, CharacterAttr.m_szLeg.y, CharacterAttr.m_szLeg.z);
    popMatrix();
    // Right
    pushMatrix();
    translate(CharacterAttr.m_szBody.x / 2.0 - CharacterAttr.m_szLeg.x / 2.0, CharacterAttr.m_szBody.y / 2.0, 0.0);
    rotateX(m_rotLeg);
    translate(0.0, CharacterAttr.m_szLeg.y / 2.0, 0.0);
    box(CharacterAttr.m_szLeg.x, CharacterAttr.m_szLeg.y, CharacterAttr.m_szLeg.z);
    popMatrix();
    
    popStyle();
    popMatrix();
  }
  
}

class Hero extends CharacterBody
{
  
  boolean doorCollision()
  {
    boolean collision = false;
    for(Door d : door){
      float startX = d.m_pos.x, startZ = d.m_pos.z;
      float endX = d.endPos().x, endZ = d.endPos().z;
      WallDirection direction = d.m_pose.equals("front") || d.m_pose.equals("back") ? WallDirection.X : WallDirection.Z;

      if(d.m_pose.equals("left")){
        endX += 500 ;
      }else if(d.m_pose.equals("right")){
        endX -= 500;
      }else if(d.m_pose.equals("front")){
        endZ -= 500;
      }else if(d.m_pose.equals("back")){
        endZ += 500;
      }
      if(startX > endX){ float tmp = startX; startX = endX; endX = tmp; }
      if(startZ > endZ){ float tmp = startZ; startZ = endZ; endZ = tmp; }
      
      if(direction == WallDirection.X){
        collision = startX < m_pos.x - CharacterAttr.AABBSize().x / 2 && m_pos.x + CharacterAttr.AABBSize().x / 2 < endX
          && !(m_pos.z + CharacterAttr.AABBSize().z / 2 < startZ || m_pos.z - CharacterAttr.AABBSize().z / 2 > endZ)
          ;
      }else if(direction == WallDirection.Z){
        collision = startZ < m_pos.z - CharacterAttr.AABBSize().z / 2 && m_pos.z + CharacterAttr.AABBSize().z / 2 < endZ
          && !(m_pos.x + CharacterAttr.AABBSize().x / 2 < startX || m_pos.x - CharacterAttr.AABBSize().x / 2 > endX)
          ;
      }

      if(collision) break;
    }
    return collision;
  }

  boolean wallCollision()
  {
    final int margin = 1;
    Coord coord = world.mapCoord(m_pos.x, m_pos.z);
    if(world.m_aStar.availableCoord(coord)){
      return world.m_map[coord.m_y * world.m_mapCols + coord.m_x] == 'X' || coord.m_x <= margin || coord.m_x >= world.m_mapCols - margin || coord.m_y <= margin || coord.m_y >= world.m_mapRows - margin;
    }
    return false;
  }

  boolean bodyCollision()
  {
    boolean collision = false;
    ArrayList<CharacterBody> totalChars = new ArrayList<CharacterBody>(); totalChars.add(me); totalChars.addAll(enemies);
    for(CharacterBody c : totalChars){
      if(c == this) continue;
      collision = abs(m_pos.x - c.m_pos.x) < CharacterAttr.AABBSize().x / 2 + CharacterAttr.AABBSize().x / 2
        && abs(m_pos.z - c.m_pos.z) < CharacterAttr.AABBSize().z / 2 + CharacterAttr.AABBSize().z / 2
        ;

      if(collision) break;
    }
    return collision;
  }

  void onHandleKeyboard()
  {
    boolean move = false;
    if(heldKeys.contains('q')){
      spin(PI / 100);
      move = true;
    }
    if(heldKeys.contains('e')){
      spin(-PI / 100);
      move = true;
    }
    if(heldKeys.contains('2')){
      shake(-PI / 100);
      move = true;
    }
    if(heldKeys.contains('x')){
      shake(PI / 100);
      move = true;
    }
    if(heldKeys.contains('w')){
      forward(10.0);
      move = true;
    }
    if(heldKeys.contains('s')){
      forward(-10.0);
      move = true;
    }
    if(heldKeys.contains('a')){
      shift(10.0);
      move = true;
    }
    if(heldKeys.contains('d')){
      shift(-10.0);
      move = true;
    }
    if(move){
      setStatus(Status.Walk);
    }else{
      setStatus(Status.Stop);
    }
    
    Coord current = world.mapCoord(m_pos.x, m_pos.z);
    world.m_aStar.setGoal(current);
  }

  void onFire()
  {
    if(m_hp > 0){
      Bullet b = new Bullet();
      b.m_pos.set(m_pos.x, m_pos.y - CharacterAttr.m_szBody.y / 2.0, m_pos.z);
  
      float v = 500.0;
      float x = v * cos(m_orientation.x) * sin(m_orientation.y);
      float y = v * sin(m_orientation.x);
      float z = v * cos(m_orientation.x) * cos(m_orientation.y);
      b.m_vel.set(x, y, z);
      bullets.add(b);
    }
  }
  
  void onHit()
  {
    m_hp -= 30;
    super.onHit();
  }
  
  void onPick()
  {
    for(int i = gift.size() - 1; i >= 0; i--){
      GiftBox g = gift.get(i);
      boolean collision = abs(m_pos.x - g.m_pos.x) < CharacterAttr.AABBSize().x / 2 + g.m_size.x / 2
        && abs(m_pos.z - g.m_pos.z) < CharacterAttr.AABBSize().z / 2 + g.m_size.z / 2
        ;

      if(collision){
        if(g instanceof Key){
          WIN = true;
          songBgm.pause();
          songBeginning.play();
          movieEnding.play();
        }else{
          m_hp += 20;
          if(m_hp > 100) m_hp = 100;
        }
        gift.remove(g);
      }
    }
  }

}

class Enemy extends CharacterBody
{
  
  ArrayList<Coord> m_path;
  float m_attackRange;

  float m_targetOrientation;
  
  Enemy()
  {
    PVector size = CharacterAttr.AABBSize();
    m_attackRange = sqrt(size.x * size.x + size.z * size.z) * 1.05;
    m_targetOrientation = Float.NaN;
  }
  
  boolean wallCollision()
  {
    boolean collision = false;
    ArrayList<Wall> totalWalls = new ArrayList<Wall>(); totalWalls.addAll(world.m_walls); // totalWalls.addAll(walls); 
    for(Obstacle o : obstacles){
      for(int i = 0; i < o.m_walls.length; i++){
        totalWalls.add(o.m_walls[i]);
      }
    }
    for(Wall w : totalWalls){
      float startX = w.m_pos.x, startZ = w.m_pos.z;
      float endX = w.endPos().x, endZ = w.endPos().z;
      if(startX > endX){ float tmp = startX; startX = endX; endX = tmp; }
      if(startZ > endZ){ float tmp = startZ; startZ = endZ; endZ = tmp; }
      if(w.m_size.x != 0.0){
        collision = m_pos.z - CharacterAttr.AABBSize().z / 2 < startZ && startZ < m_pos.z + CharacterAttr.AABBSize().z / 2
          && !(m_pos.x + CharacterAttr.AABBSize().x / 2 < startX || m_pos.x - CharacterAttr.AABBSize().x / 2 > endX)
          ;
      }else if(w.m_size.z != 0.0){
        collision = m_pos.x - CharacterAttr.AABBSize().x / 2 < w.m_pos.x && w.m_pos.x < m_pos.x + CharacterAttr.AABBSize().x / 2
          && !(m_pos.z + CharacterAttr.AABBSize().z / 2 < startZ || m_pos.z - CharacterAttr.AABBSize().z / 2 > endZ)
          ;
      }
      
      if(collision) break;
    }
    return collision;
  }
  
  boolean bodyCollision()
  {
    return false;
  }
  
  void onHit()
  {
    m_hp -= 20;
    super.onHit();
  }
  
  boolean canHit() { return sqrt(pow(m_pos.x - me.m_pos.x, 2.0) + pow(m_pos.z - me.m_pos.z, 2.0)) <= m_attackRange; }
  void onAttackFinished()
  {
    if(canHit()) me.onHit();
  }

  void onChase()
  {
    if(m_hp <= 0) return;

    if(canHit()){
      setStatus(Status.Attack);
      float diffX = me.m_pos.x - m_pos.x, diffZ = me.m_pos.z - m_pos.z;
      //m_targetOrientation = atan2(diffX, diffZ);
      m_orientation.y = atan2(diffX, diffZ);
    }else if(AABBCollision()){
      setStatus(Status.Stop);
    }else{
      Coord current = world.mapCoord(m_pos.x, m_pos.z);
      
      world.m_aStar.setSearcher(this); ArrayList<Coord> path = world.m_aStar.search(current);
      if(path.size() >= 2) { m_path = path; m_path.remove(m_path.size() - 1); }
      if(!m_path.isEmpty()){
        setStatus(Status.Walk);
        PVector next = world.sceneCoord(m_path.get(m_path.size() - 1));

        
        float diffX = next.x - m_pos.x, diffZ = next.z - m_pos.z;
        m_orientation.y = atan2(diffX, diffZ);
        float dist = sqrt(diffX * diffX + diffZ * diffZ);
        if(dist < 5.0){
          m_path.remove(m_path.size() - 1);
        }else{
          forward(5.0);
        }
      }else{
        setStatus(Status.Stop);
        //m_targetOrientation = Float.NaN;
      }
    }
  }

}
