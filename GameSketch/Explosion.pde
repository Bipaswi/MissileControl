public class Explosion extends ForceGenerator{
   
  public int magnitude = 1;
  public Missile missile; 
   
  Explosion(int magnitude, Missile missile){
   this.magnitude = magnitude;
   this.missile = missile;
  }
   
  // Applies the drag force to the given particle
  public void updateForce(Meteor meteor) {
    PVector force = meteor.position.copy();
    force.sub(missile.position);
    force.normalize();
    force.mult(magnitude);
    meteor.addForce(force);
  }
}