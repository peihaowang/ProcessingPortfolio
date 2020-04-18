
class World
{
  
  PVector m_size;
  
  PVector m_meshSize;
  
  char[] m_map;
  int m_mapCols;
  int m_mapRows;
  AStar m_aStar;

  ArrayList<Wall> m_walls;
  
  World(float w, float h, float d)
  {
    m_size = new PVector(w, h, d);
    
    m_walls = new ArrayList<Wall>();
    m_walls.add(new Wall(-m_size.x / 2, -m_size.z / 2, "back", m_size.x, m_size.y));
    m_walls.add(new Wall(m_size.x / 2, -m_size.z / 2, "right", m_size.z, m_size.y));
    m_walls.add(new Wall(m_size.x / 2, m_size.z / 2, "front", -m_size.x, m_size.y));
    m_walls.add(new Wall(-m_size.x / 2, m_size.z / 2, "left", -m_size.z, m_size.y));
    
    m_meshSize = new PVector(250, 0, 250);
    
    // Initialize the grid map
    m_mapCols = int(w / m_meshSize.x); m_mapRows = int(d / m_meshSize.z);
    m_map = new char[m_mapCols * m_mapRows];
    for(int i = 0; i < m_map.length; i++){
      m_map[i] = '.';
    }
    m_aStar = new AStar(m_map, m_mapCols, m_mapRows);
  }
  
  Coord mapCoord(float x, float z)
  {
    //int mapX = floor(map(x, -m_size.x / 2.0, m_size.x / 2.0, 0.0, (float)m_mapCols));
    //int mapY = floor(map(z, -m_size.z / 2.0, m_size.z / 2.0, 0.0, (float)m_mapRows));
    int mapX = floor((x - (-m_size.x / 2.0)) / m_meshSize.x);
    int mapY = floor((z - (-m_size.z / 2.0)) / m_meshSize.z);
    return new Coord(mapX, mapY);
  }
  
  Coord mapCoord(PVector pos)
  {
    return mapCoord(pos.x, pos.z);
  }
  
  PVector sceneCoord(int x, int y)
  {
    int sceneX = floor(map(x, 0, m_mapCols, -m_size.x / 2.0, m_size.x / 2.0));
    int sceneZ = floor(map(y, 0, m_mapRows, -m_size.z / 2.0, m_size.z / 2.0));
    return new PVector(sceneX + m_meshSize.x / 2.0, 0.0, sceneZ + m_meshSize.z / 2.0);
  }

  PVector sceneCoord(Coord coord)
  {
    return sceneCoord(coord.m_x, coord.m_y);
  }

  void onDraw()
  {
    
    pushStyle();
    stroke(0);
    
    // Ground
    beginShape();
    vertex(-m_size.x / 2, height, -m_size.z / 2);
    vertex(m_size.x / 2, height, -m_size.z / 2);
    vertex(m_size.x / 2, height, m_size.z / 2);
    vertex(-m_size.x / 2, height, m_size.z / 2);
    endShape(CLOSE);
    
    // Sky
    beginShape();
    vertex(-m_size.x / 2, height - m_size.y, -m_size.z / 2);
    vertex(m_size.x / 2, height - m_size.y, -m_size.z / 2);
    vertex(m_size.x / 2, height - m_size.y, m_size.z / 2);
    vertex(-m_size.x / 2, height - m_size.y, m_size.z / 2);
    endShape(CLOSE);
    
    for(Wall w : m_walls){
      w.onDraw();
    }
    
    //// Surrounding
    //// Left
    //beginShape();
    //vertex(-m_size.x / 2, height - m_size.y, -m_size.z / 2);
    //vertex(-m_size.x / 2, height, -m_size.z / 2);
    //vertex(-m_size.x / 2, height, m_size.z / 2);
    //vertex(-m_size.x / 2, height - m_size.y, m_size.z / 2);
    //endShape(CLOSE);
    //// Right
    //beginShape();
    //vertex(m_size.x / 2, height - m_size.y, -m_size.z / 2);
    //vertex(m_size.x / 2, height, -m_size.z / 2);
    //vertex(m_size.x / 2, height, m_size.z / 2);
    //vertex(m_size.x / 2, height - m_size.y, m_size.z / 2);
    //endShape(CLOSE);
    //// Front
    //beginShape();
    //vertex(-m_size.x / 2, height - m_size.y, m_size.z / 2);
    //vertex(-m_size.x / 2, height, m_size.z / 2);
    //vertex(m_size.x / 2, height, m_size.z / 2);
    //vertex(m_size.x / 2, height - m_size.y, m_size.z / 2);
    //endShape(CLOSE);
    //// Back
    //beginShape();
    //vertex(-m_size.x / 2, height - m_size.y, -m_size.z / 2);
    //vertex(-m_size.x / 2, height, -m_size.z / 2);
    //vertex(m_size.x / 2, height, -m_size.z / 2);
    //vertex(m_size.x / 2, height - m_size.y, -m_size.z / 2);
    //endShape(CLOSE);
    
    popStyle();
  }

}
