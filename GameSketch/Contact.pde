public class Contact {
  
  Meteor p1;
  City c1;
  Missile m1;
  PVector contactNormal;
  float c;
  
  public Contact(Meteor p1, City c1, Missile m1, float c, PVector contactNormal) {
    this.p1 = p1;
    this.c1 = c1; 
    this.m1 = m1;
    this.c = c;
    this.contactNormal = contactNormal;
  }
  
  public Contact(Meteor p1, City c1) {
    this(p1, c1, null, 0, null);
  }
  
    // Resolve this contact for velocity
  void resolve () {
    resolveVelocity() ;
  }
  
  float calculateSeparatingVelocity() {
    PVector relativeVelocity = p1.velocity.get();
    //relativeVelocity.sub(p2.velocity);
    return relativeVelocity.dot(contactNormal);
  }
  
  // Handle the impulse calculations for this collision
  void resolveVelocity()  {
    //Find the velocity in the direction of the contact
    float separatingVelocity = calculateSeparatingVelocity();
        
    // Calculate new separating velocity
    float newSepVelocity = -separatingVelocity * c;
    
    // Now calculate the change required to achieve it
    float deltaVelocity = newSepVelocity - separatingVelocity;
    
    // Apply change in velocity to each object in proportion inverse mass.
    // i.e. lower inverse mass (higher actual mass) means less change to vel.
    float totalInverseMass = p1.invMass;
    //totalInverseMass += p2.invMass ;
    
    // Calculate impulse to apply
    float impulse = deltaVelocity / totalInverseMass;
        
    // Find the amount of impulse per unit of inverse mass
    PVector impulsePerIMass = contactNormal.get();
    impulsePerIMass.mult(impulse);
    
    // Calculate the p1 impulse
    PVector p1Impulse = impulsePerIMass.get();
    p1Impulse.mult(p1.invMass);
    
    // Apply impulses. They are applied in the direction of contact, proportional
    //  to inverse mass
    p1.velocity.add(p1Impulse);
  }
  
  boolean collision (Meteor p1, City c1) {
    float d = dist(p1.position.x, p1.position.y, c1.position.x, c1.position.y); 
    if ((p1.size/2 + c1.size/2 > d) && c1.col1 == 0) {
    // we have a collision
    return true;
    } else {
    return false;
    }
  }
}