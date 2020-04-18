
enum WallDirection{X, Z};

class Wall
{
  
  PVector m_pos;
  PVector m_size;
  float m_h;
  
  String m_pose;
  
  Wall(float startX, float startZ, String pose, float len, float h)
  {
    WallDirection direction = pose.equals("front") || pose.equals("back") ? WallDirection.X : WallDirection.Z;
    m_pos = new PVector(startX, 0.0, startZ);
    m_size = new PVector(0.0, 0.0, 0.0);
    if(direction == WallDirection.X){
      m_size.x = len;
    }else if(direction == WallDirection.Z){
      m_size.z = len;
    }
    m_h = h;
    m_pose = pose;
  }
  
  void updateMap()
  {
    WallDirection direction = m_pose.equals("front") || m_pose.equals("back") ? WallDirection.X : WallDirection.Z;
    float startX = m_pos.x, startZ = m_pos.z;
    float endX = endPos().x, endZ = endPos().z;

    if(startX > endX){ float tmp = startX; startX = endX; endX = tmp; }
    if(startZ > endZ){ float tmp = startZ; startZ = endZ; endZ = tmp; }
    
    //float marginX = CharacterAttr.AABBSize().x, marginZ = CharacterAttr.AABBSize().z;
    float marginX = world.m_meshSize.x, marginZ = world.m_meshSize.z;
    
    // Extend the margin of borders
    if(m_pose.equals("front")){
      startZ += marginZ;

      startX -= marginX;
      endX += marginX;
    }else if(m_pose.equals("back")){
      startZ -= marginZ;

      startX -= marginX;
      endX += marginX;
    }else if(m_pose.equals("left")){
      startX -= marginX;

      startZ -= marginZ;
      endZ += marginZ;
    }else if(m_pose.equals("right")){
      startX += marginX;

      startZ -= marginZ;
      endZ += marginZ + 1;
    }
    
    Coord startCoord = world.mapCoord(startX, startZ), endCoord = world.mapCoord(endX, endZ);
    int startCol = startCoord.m_x, endCol = endCoord.m_x;
    int startRow = startCoord.m_y, endRow = endCoord.m_y;
    //int startCol = floor(map(startX, -world.m_size.x / 2.0, world.m_size.x / 2.0, 0, mapCols)), endCol = floor(map(endX, -world.m_size.x / 2.0, world.m_size.x / 2.0, 0, mapCols));
    //int startRow = floor(map(startZ, -world.m_size.z / 2.0, world.m_size.z / 2.0, 0, mapRows)), endRow = floor(map(endZ, -world.m_size.z / 2.0, world.m_size.z / 2.0, 0, mapRows));
    if(direction == WallDirection.X){
      for(int j = startCol; j <= endCol; j++){
        world.m_map[startRow * world.m_mapCols + j] = 'X';
      }
    }else if(direction == WallDirection.Z){
      for(int j = startRow; j <= endRow; j++){
        world.m_map[j * world.m_mapCols + startCol] = 'X';
      }
    }
  }

  PVector endPos()
  {
    if(m_size.x != 0.0){
      return new PVector(m_pos.x + m_size.x, height - m_h, m_pos.z);
    }else if(m_size.z != 0.0){
      return new PVector(m_pos.x, height - m_h, m_pos.z + m_size.z);
    }
    return new PVector(0.0, 0.0, 0.0);
  }
  
  void onDraw()
  {
    pushStyle();
    shapeMode(CORNER);
    if(m_size.x != 0.0){
      beginShape();
      vertex(m_pos.x, height, m_pos.z);
      vertex(m_pos.x + m_size.x, height, m_pos.z);
      vertex(m_pos.x + m_size.x, height - m_h, m_pos.z);
      vertex(m_pos.x, height - m_h, m_pos.z);
      endShape(CLOSE);
    }else if(m_size.z != 0.0){
      beginShape();
      vertex(m_pos.x, height, m_pos.z);
      vertex(m_pos.x, height, m_pos.z + m_size.z);
      vertex(m_pos.x, height - m_h, m_pos.z + m_size.z);
      vertex(m_pos.x, height - m_h, m_pos.z);
      endShape(CLOSE);
    }
    popStyle();
  }

}

class Obstacle{
  
  Wall[] m_walls;
  PVector m_leftTop;
  PVector m_size;
  
  Obstacle(float x, float z, float w, float d, float h){
    m_leftTop = new PVector(x, height, z);
    m_size = new PVector(w, h, d);
    
    m_walls = new Wall[4];
    m_walls[0] = new Wall(x, z, "back", w, h);
    m_walls[1] = new Wall(x + w, z, "right", d, h);
    m_walls[2] = new Wall(x + w, z + d, "front", -w, h);
    m_walls[3] = new Wall(x, z + d, "left", -d, h);
    
    for(int i = 0; i < m_walls.length; i++){
      m_walls[i].updateMap();
    }
  }
  
  void onDraw()
  {
    for(int i = 0; i < m_walls.length; i++){
      m_walls[i].onDraw();
    }
  }
  
}

class Door extends Wall
{

  Door(float x, float z, String pose, float len)
  {
    super(x, z, pose, len, height);
    //String pose = "";
    //if(x == -world.m_size.x / 2){
    //  super(x, z, "left", len, height);
    //}else if(x == world.m_size.x / 2){
    //  super(x, z, "right", len, height);
    //}else if(z == -world.m_size.z / 2){
    //  super(x, z, "back", len, height);
    //}else if(z == world.m_size.z / 2){
    //  super(x, z, "front", len, height);
    //}
    
  }
  
  void onDraw()
  {
    pushStyle();
    fill(0);
    super.onDraw();
    popStyle();
  }

}
