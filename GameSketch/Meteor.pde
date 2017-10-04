// a representation of a point mass
final class Meteor {
  
  // Vectors to hold pos, vel
  // I'm allowing public access to keep things snappy.
  public PVector position, velocity;
  
  // Vector to accumulate forces prior to integration
  private PVector forceAccumulator; 
  
  // Store inverse mass to allow simulation of infinite mass
  private float invMass;
  
  private int timer;
  
  private int size;
  color c;
  // If you do need the mass, here it is:
  public float getMass() {return 1/invMass;}
  
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
  
  // update position and velocity
  void integrate() {
    // If infinite mass, we don't integrate
    if (invMass <= 0f) return;
      if (timer > 0){
        timer--;
      }
      if (timer <= 0) {
      // update position
      position.add(velocity);
    
      // NB If you have a constant acceleration (e.g. gravity) start with
      //    that then add the accumulated force / mass to that.
      PVector resultingAcceleration = forceAccumulator.get();
      resultingAcceleration.mult(invMass);
    
      // update velocity
      velocity.add(resultingAcceleration);

      // Clear accumulator
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
}