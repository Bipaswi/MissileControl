public class Explosion extends ForceGenerator{
   
  public int magnitude = 1;
  public Missile missile; 
   
  Explosion(int magnitude, Missile missile){
   this.magnitude = magnitude;
   this.missile = missile;
  }
   
  // Applies the drag force to the given particle
  public void updateForce(Meteor particle) {
    PVector force = particle.position.copy();
    force.sub(missile.position);
    
    //Calculate the final force and apply it
    force.normalize();
    force.mult(magnitude);
    particle.addForce(force);
  }
}