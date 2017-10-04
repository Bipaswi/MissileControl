public class Score{
 
 //if particle goes out of bounds, add to score
 //if collision detected add to score
 //if city still standing after wave add to score
 
 public int score;
 Missile missile;
 Meteor meteor;
 City city;
 
 Score(Missile missile, Meteor meteor, City city) {
   this.missile = missile;
   this.meteor = meteor;
   this.city = city;
 }
 
 //public int countScore(Missile missile, Meteor meteor, City city){
 //  score = particleCollisionScore();
 //  
 //  
 //  return score;
 //}
 
}