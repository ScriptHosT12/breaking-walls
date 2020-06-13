import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.processing.*;
import toxi.util.*;
import toxi.util.datatypes.*;

ToxiclibsSupport gfx;
Plane[] p;
PolygonClipper2D clip;
int zind = 0;
int next_plane_pos;
float shake;

void setup()
{
  size(1000, 1000, P3D);
  next_plane_pos = -1000;
  clip = new SutherlandHodgemanClipper(new Rect(0, 0, width, height));
  gfx = new ToxiclibsSupport(this);
  p = new Plane[3];
  for(int i = 0; i < p.length; i++)
  {
    p[i] = new Plane(next_plane_pos);
    next_plane_pos -= 1000;
  }
}

void draw()
{
  background(0);
  
  for(int i = 0; i < p.length; i++)
  {
    p[i].update((constrain(p[i].z + zind, -2500, 100) + 2500) / 100000.0);
    p[i].show();
    if(p[i].z + zind > 1000)
    {
      print("recycle");
      p[i].threaded_populate();
      p[i].z = next_plane_pos;
      next_plane_pos -= 1000;
    }
  }
  zind+=1;
  shake *= 0.7;
}
