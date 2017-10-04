public class Missile {
  
  public PVector position;
  public PVector start;
  public PVector velocity;
  public int xS;
  public int yS;
  public int x;
  public int y;
  public float size = 20;
  public color c;
  public boolean transparencyOn;
  public int transparency;
  public int timer = 60;
  public int magnitude = 2;
  
  Missile(int x, int y, boolean transparencyOn, int xS, int yS) {
    start = new PVector(x, y);
    position = new PVector(xS, yS);
    this.transparencyOn = transparencyOn;
    c = color(169, 169, 169);
    transparency = 255;
  }
 
  void update() {
    //velocity = new PVector(position.x - start.x, position.y - start.y);
    //velocity.normalize();
    //velocity.mult(magnitude);
    //start.add(velocity);
   
    if (timer > 0){
          timer-=1;
          size+=2.5;
          transparency-=2;
      }
    
  }
 
  void display() {
    noStroke();
    fill(c,transparency);
    //ellipse(start.x, start.y,size,size);
    ellipse(position.x, position.y,size,size);
  }
}