class Plane
{
  int z;
  int rem_cells;
  Voronoi v;
  ArrayList<Cell> cells;
  ArrayList<Cell> cells_obstructor;
  boolean calculating = false;
  
  Plane(int z)
  {
    this.z = z;
    this.populate();
  }
  
  void populate()
  {
    v = new Voronoi();
    rem_cells = 0;
    cells = new ArrayList<Cell>();
    cells_obstructor = new ArrayList<Cell>();
    
    for (int i = 0; i < 1000; i++) {
      v.addPoint(new Vec2D(random(width), random(height)));
    }
    
    for (Polygon2D poly : v.getRegions()) {
      Cell cell = new Cell(clip.clipPolygon(poly), this);
      loop:
      for(int x = -70; x < 70; x += 10)
      for(int y = -70; y < 70; y += 10)
      {
        if(poly.containsPoint(new Vec2D(width / 2 + x, height / 2 + y)))
        {
          cells_obstructor.add(cell);
          break loop;
        }
      }
      
     cells.add(cell);
     rem_cells++;
    }
  }
  
  void threaded_populate()
  {
    new PopulateThread(this).start();
  }
  
  void show()
  {
    if(calculating) return;
    push();
    translate(0, 0, z + zind);
    for (Cell cell : cells) {
      cell.show();
    }
    pop();
  }
  
  void update(float fall_off_p)
  {
    if(calculating) return;
    for (Cell cell : cells) {
      cell.update(fall_off_p);
    }
    if(z + zind > 500)
    {
      for (Cell cell : cells_obstructor) {
        if(random(10) < 1)
        {
          cell.start_pendulum();
          if(z + zind > 600)
          {
            cell.fell_off = true;
          }
        }
      }
    }
  }
  
  class PopulateThread extends Thread {
         Plane owner;
         PopulateThread(Plane owner) {
             this.owner = owner;
         }

         public void run() {
             owner.calculating = true;
             owner.populate();
             owner.calculating = false;
         }
     }
}
