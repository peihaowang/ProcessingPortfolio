
class Bullet
{

  PVector m_pos;
  PVector m_vel;
  
  Bullet()
  {
    m_pos = new PVector();
    m_vel = new PVector();
  }
  
  boolean done()
  {
    PVector aabbSize = CharacterAttr.AABBSize(); 
    for(Enemy e : enemies){
      if(e.m_pos.x - aabbSize.x / 2 < m_pos.x && m_pos.x < e.m_pos.x + aabbSize.x / 2
        && e.m_pos.y - aabbSize.y / 2 < m_pos.y && m_pos.y < e.m_pos.y + aabbSize.y / 2
        && e.m_pos.z - aabbSize.z / 2 < m_pos.z && m_pos.z < e.m_pos.z + aabbSize.z / 2
      ){
        e.onHit();
        return true;
      }
    }
     
    for(Obstacle o : obstacles){
      if(o.m_leftTop.x < m_pos.x && m_pos.x < o.m_leftTop.x + o.m_size.x
        && o.m_leftTop.y < m_pos.y && m_pos.y < o.m_leftTop.y + o.m_size.y / 2
        && o.m_leftTop.z < m_pos.z && m_pos.z < o.m_leftTop.z + o.m_size.z / 2
      ){
        return true;
      }
    }
    
    if(m_pos.x < -world.m_size.x / 2 || m_pos.x > world.m_size.x / 2 || m_pos.z < -world.m_size.z / 2 || m_pos.z > world.m_size.z / 2){
      return true;
    }
    return false;
  }
  
  void onMove()
  {
    m_pos.x += m_vel.x;
    m_pos.y += m_vel.y;
    m_pos.z += m_vel.z;
  }
  
  void onDraw()
  {
    pushStyle();
    strokeWeight(10);
    stroke(0);
    fill(0);
    point(m_pos.x, m_pos.y, m_pos.z);
    popStyle();
  }
  
}
