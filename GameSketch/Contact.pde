public class Contact {
  
  Meteor p1;
  City c1;
  Missile m1;
  PVector contactNormal;
  float c;
  
  public Contact(Meteor p1, City c1) {
    this.p1 = p1;
    this.c1 = c1; 
  }
  
boolean collision (Meteor p1, City c1) {
    float d = dist(p1.position.x, p1.position.y, c1.position.x, c1.position.y); 
    if ((p1.size/2 + c1.size/2 > d) && c1.col1 == 0) {
    return true;
    } else {
    return false;
    }
  }
}