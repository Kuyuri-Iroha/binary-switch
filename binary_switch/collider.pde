// collider.pde
// Kuyuri Iroha



interface ICollider
{ 
  final int CIRCLE = 1;
  final int RECT = 2;
  
  int getForm();
  boolean hit(CircleCollider cc);
  boolean hit(RectCollider rc);
}

abstract class Collider implements ICollider
{ 
  float x, y;
  float scale;
}


/**
 * 円と矩形の当たり判定
 */
boolean hitCircleRect(CircleCollider cc, RectCollider rc)
{
  float rx1 = rc.x - rc.w/2.0;
  float ry1 = rc.y - rc.h/2.0;
  float rx2 = rc.x + rc.w/2.0;
  float ry2 = rc.y + rc.h/2.0;
  boolean a = (rx1 <= cc.x && cc.x <= rx2 && ry1-cc.r <= cc.y && cc.y <= ry2+cc.r);
  boolean b = (rx1-cc.r <= cc.x && cc.x <= rx2+cc.r && ry1 <= cc.y && cc.y <= ry2);
  boolean c = (dist(rx1, ry1, cc.x, cc.y) <= cc.r || dist(rx2, ry1, cc.x, cc.y) <= cc.r || dist(rx2, ry2, cc.x, cc.y) <= cc.r || dist(rx1, ry2, cc.x, cc.y) <= cc.r);

  return a || b || c;
}


/**
 * 円の衝突形状
 */
class CircleCollider extends Collider
{
  float r;
  
  CircleCollider(float x, float y, float r)
  {
    this.x = x;
    this.y = y;
    this.r = r;
  }
  
  int getForm()
  {
    return Collider.CIRCLE;
  }
  
  boolean hit(CircleCollider cc)
  {
    return dist(this.x, this.y, cc.x, cc.y) <= this.r + cc.r;
  }
  
  boolean hit(RectCollider rc)
  {
    return hitCircleRect(this, rc);
  }
}


/**
 * 長方形の衝突形状
 */
class RectCollider extends Collider
{
  float w, h;
  
  RectCollider(float x, float y, float w, float h)
  {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  int getForm()
  {
    return Collider.RECT;
  }
  
  boolean hit(RectCollider rc)
  { 
    return abs(this.x - rc.x) <= this.w/2.0 + rc.w/2.0 && abs(this.y - rc.y) <= this.h/2.0 + rc.h/2.0;
  }

  boolean hit(CircleCollider cc)
  {
    return hitCircleRect(cc, this);
  }
}
