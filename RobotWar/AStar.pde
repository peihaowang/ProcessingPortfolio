// Refer to https://en.wikipedia.org/wiki/A*_search_algorithm#Pseudocode

import java.util.Map;

class Coord
{
  int  m_x;
  int  m_y;

  Coord()
  {
    m_x = 0; m_y = 0;
  }
  
  Coord(int x, int y)
  {
    m_x = x; m_y = y;
  }

  @Override
  public boolean equals(Object o)
  {
    if(this == o) return true;
    if(!(o instanceof Coord)) return false;

    Coord coord = (Coord)o;
    return coord.m_x == m_x && coord.m_y == m_y;
  }
    
}

class AStar{
  
  char[] m_map;
  int m_cols;
  int m_rows;
  Coord m_goal;
  
  CharacterBody m_searcher;
  
  AStar(char[] map, int cols, int rows)
  {
    m_map = map;
    m_cols = cols; m_rows = rows;
    m_goal = new Coord(0, 0);
  }
  
  void setGoal(Coord coord)
  {
    m_goal.m_x = coord.m_x; m_goal.m_y = coord.m_y;
  }
  
  void setSearcher(CharacterBody seacher)
  {
    m_searcher = seacher;
  }
  
  int indx(Coord p) { return p.m_y * m_cols + p.m_x; }
  
  Coord coord(int index)
  {
    int x = index % m_cols;
    int y = floor(index / m_cols);
    return new Coord(x, y);
  }
  
  Coord[] neighbors(Coord p)
  {
    return new Coord[]{ new Coord(p.m_x - 1, p.m_y), new Coord(p.m_x - 1, p.m_y + 1), new Coord(p.m_x, p.m_y + 1), new Coord(p.m_x + 1, p.m_y + 1)
      , new Coord(p.m_x + 1, p.m_y), new Coord(p.m_x + 1, p.m_y - 1), new Coord(p.m_x, p.m_y - 1), new Coord(p.m_x - 1, p.m_y - 1)
    };
  }
  
  float dist_between(Coord current, Coord neighbor)
  {
    int diffX = current.m_x - neighbor.m_x, diffY = current.m_y - neighbor.m_y;
    return sqrt(diffX * diffX + diffY * diffY);
  }
  
  float heuristic_cost_estimate(Coord current)
  {
    if(m_map[indx(current)] == 'X'){
      return Float.POSITIVE_INFINITY;
    }else{
      for(CharacterBody c : enemies){
        if(c == m_searcher) continue;
        Coord coord = world.mapCoord(c.m_pos.x, c.m_pos.z);
        if(current.equals(coord)) return Float.POSITIVE_INFINITY;
      }
      return dist_between(current, m_goal);
    }
  }
  
  boolean availableCoord(Coord p) { return 0 <= p.m_x && p.m_x < m_cols && 0 <= p.m_y && p.m_y < m_rows; }
  
  ArrayList<Coord> reconstruct_path(HashMap<Integer, Integer> cameFrom, Coord current)
  {
    ArrayList<Coord> total_path = new ArrayList<Coord>(); total_path.add(current);
    int val = indx(current);
    while(cameFrom.keySet().contains(val)){
      val = cameFrom.get(val);
      total_path.add(coord(val));
    }
    return total_path;
  }

  ArrayList<Coord> search(Coord start)
  {
    // The set of nodes already evaluated
    ArrayList<Coord> closedSet = new ArrayList<Coord>();

    // The set of currently discovered nodes that are not evaluated yet.
    // Initially, only the start node is known.
    ArrayList<Coord> openSet = new ArrayList<Coord>(); openSet.add(start);

    // For each node, which node it can most efficiently be reached from.
    // If a node can be reached from many nodes, cameFrom will eventually contain the
    // most efficient previous step.
    HashMap<Integer, Integer> cameFrom = new HashMap<Integer, Integer>();

    // For each node, the cost of getting from the start node to that node.
    float[] gScore = new float[m_cols * m_rows];
    for(int i = 0; i < gScore.length; i++){
      gScore[i] = Float.POSITIVE_INFINITY;
    }

    // The cost of going from start to start is zero.
    gScore[indx(start)] = 0;

    // For each node, the total cost of getting from the start node to the goal
    // by passing by that node. That value is partly known, partly heuristic.
    float[] fScore = new float[m_cols * m_rows];
    for(int i = 0; i < fScore.length; i++){
      fScore[i] = Float.POSITIVE_INFINITY;
    }

    // For the first node, that value is completely heuristic.
    fScore[indx(start)] = heuristic_cost_estimate(start);

    while(!openSet.isEmpty()){
      // find the node in openSet having the lowest fScore[] value
      Coord current = openSet.get(0);
      for(Coord p : openSet){
        if(fScore[indx(p)] < fScore[indx(current)]) current = p;
      }

      if(current.equals(m_goal)) return reconstruct_path(cameFrom, current);

      openSet.remove(current);
      closedSet.add(current);

      Coord[] neighbors = neighbors(current);
      for(int i = 0; i < neighbors.length; i++){
        Coord neighbor = neighbors[i];
        if(!availableCoord(neighbor)) continue;
        if(closedSet.contains(neighbor)) continue;    // Ignore the neighbor which is already evaluated.
        
        // The distance from start to a neighbor
        float tentative_gScore = gScore[indx(current)] + dist_between(current, neighbor);
  
        if(!openSet.contains(neighbor)) openSet.add(neighbor);           // Discover a new node
        else if(tentative_gScore >= gScore[indx(neighbor)]) continue;    // This is not a better path.
  
        // This path is the best until now. Record it!
        cameFrom.put(indx(neighbor), indx(current));
        gScore[indx(neighbor)] = tentative_gScore;
        fScore[indx(neighbor)] = gScore[indx(neighbor)] + heuristic_cost_estimate(neighbor);
      }
    }
    return new ArrayList<Coord>();
  }

}
