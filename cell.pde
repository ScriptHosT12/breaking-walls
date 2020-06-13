class Cell
{
  Polygon2D polygon;
  Plane plane;
  Vec2D falloff_vertex;
  float rotation;
  float initial_rotation;
  float rotation_momentum;
  float momentum;
  float y;
  boolean pendulum;
  boolean fell_off;
  boolean dead;
  
  Cell(Polygon2D polygon, Plane plane)
  {
    this.plane = plane;
    this.polygon = new Polygon2D();
    falloff_vertex = polygon.vertices.get((int)random(polygon.vertices.size())).copy();
    for(Vec2D v: polygon)
    {
      this.polygon.add(v.sub(falloff_vertex));
    }
    
    Vec2D c = this.polygon.getCentroid();
    
    initial_rotation = atan2(c.x, c.y);
    rotation = initial_rotation;
  }
  
  void show()
  {
    if(dead) return;
    push();
    translate(falloff_vertex.x, falloff_vertex.y + y);
    // translate(falloff_vertex.x + (random(shake) * 2 - shake), falloff_vertex.y + y + (random(shake) * 2 - shake));
    translate((noise(falloff_vertex.x, falloff_vertex.y, frameCount / 1000.0) * 2 - 1) * shake, (noise(falloff_vertex.x, falloff_vertex.y, frameCount / 1000.0 + 100) * 2 - 1) * shake,
              (noise(falloff_vertex.x, falloff_vertex.y, frameCount / 1000.0 + 200) * 2 - 1) * shake);
    noFill();
    rotateZ(initial_rotation-rotation);
    fill(map(plane.z + zind, -3000, 0, 0, 255));
    if(pendulum)
    {
      stroke(0);
    }
    else
    {
      noStroke();
    }
    gfx.polygon2D(polygon);
    pop();
  }
  
  void update(float fall_off_p)
  {
    if(dead) return;
    if(plane.rem_cells > 10 && random(100) < fall_off_p)
    {
      start_pendulum();
    }
    if(pendulum)
    {
      Vec2D c = this.polygon.getCentroid().getRotated(initial_rotation - rotation);
      if(fell_off && abs(rotation_momentum) < 0.01)
      {
        momentum += abs(polygon.getArea() / 3000.0);
        y += momentum;
        
        if(y > height * 2)
        {
          shake += 2;
          dead = true;
        }
      }
      else
      {
        rotation_momentum -= c.x / 10000;
      
        rotation_momentum *= 0.98;
      }
      rotation += rotation_momentum;
      
      if(random(10) < 0.1)
      {
        fell_off = true;
      }
    }
  }
  
  void start_pendulum()
  {
    if(!pendulum)
    {
      pendulum = true;
      plane.rem_cells--;
    }
  }
}
