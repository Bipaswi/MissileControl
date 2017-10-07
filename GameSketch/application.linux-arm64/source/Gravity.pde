//example from lecture
/**
 * A force generator that applies a gravitational force.
 * One instance can be used for multiple particles.
 */
public final class Gravity extends ForceGenerator {
  
  // Holds the acceleration due to gravity
  private PVector gravity;
  
  // Constructs the generator with the given acceleration
  Gravity(PVector gravity) {
    this.gravity = gravity;
  }

  void updateForce(Meteor particle) {
    PVector resultingForce = gravity.get();
    resultingForce.mult(particle.getMass());
    particle.addForce(resultingForce);
  }
}