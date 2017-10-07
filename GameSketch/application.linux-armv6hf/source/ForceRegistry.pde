import java.util.Iterator ;
//example given in lectures
class ForceRegistry {
  
  /**
   * Keeps track of one force generator and the particle
   *  it applies to.
   */
  class ForceRegistration {
    public final Meteor meteor;
    public final ForceGenerator forceGenerator;
    ForceRegistration(Meteor p, ForceGenerator fg) {
      meteor = p;
      forceGenerator = fg; 
    }
  }
  
  // Holds the list of registrations
  ArrayList<ForceRegistration> registrations = new ArrayList();
  
  /**
   * Register the given force to apply to the given particle
   */
  void add(Meteor p, ForceGenerator fg) {
    registrations.add(new ForceRegistration(p, fg)) ; 
  }

  /**
   * Calls all force generators to update the forces of their
   *  corresponding particles.
   */
  void updateForces() {
    Iterator<ForceRegistration> itr = registrations.iterator() ;
    while(itr.hasNext()) {
      ForceRegistration fr = itr.next() ;
      fr.forceGenerator.updateForce(fr.meteor) ;
    }
  }
}