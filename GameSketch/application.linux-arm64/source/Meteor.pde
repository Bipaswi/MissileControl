final class Meteor {
  
  public PVector position;
  public PVector velocity;
  private PVector forceAccumulator;
  private float invMass;
  private int timer;
  public int explosionTimer = 60;
  public int transparency = 255;
  public int explosionSize = 50;
  private int size;
  color c;
  
  public float getMass() {
     return 1/invMass;
  }
  
  Meteor(int x, int y, float xVel, float yVel, float invM, int timer, int size) {
    position = new PVector(x, y);
    velocity = new PVector(xVel, yVel);
    forceAccumulator = new PVector(0, 0);
    invMass = invM;
    this.timer = timer;
    this.size = size;
    c = color(random(255),random(255),random(255));
  
  }
  // Add a force to the accumulator 
  void addForce(PVector force) {
    forceAccumulator.add(force);
  }
  
  void fall() {
    if (invMass <= 0f) return;
      if (timer > 0){
        timer--;
      }
      if (timer <= 0) {
        position.add(velocity);
    
        PVector resultingAcceleration = forceAccumulator.get();
        resultingAcceleration.mult(invMass);
        velocity.add(resultingAcceleration);
        forceAccumulator.x = 0;
        forceAccumulator.y = 0;
    
        if (invMass <= 0.002f) fill(138, 160, 166);
        else if (invMass <= 0.003f) fill(108, 129, 130);
        else if (invMass <= 0.004f) fill(92, 175, 181);
        else fill(52, 82, 92);
        noStroke();
        ellipse(position.x, position.y, size, size); 
    }
  }
  
  void explode(){
   if (explosionTimer > 0){
       explosionTimer-=5;
       explosionSize+=4;
       transparency-=25;
    }
    noStroke();
    c = color(255, 255, 0);
    fill(c, transparency);
    ellipse(position.x, 575, explosionSize, explosionSize); 
  }
}