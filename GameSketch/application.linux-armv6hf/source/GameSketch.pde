PImage mouseCursor;
PImage bg;

final public static int STARTING_METEORS = 5;
final public static int STARTING_MISSILES = 5;
final public static int NUM_CITIES = 6;
final public static int NUM_WAVES = 5;
final public static int WIDTH = 800;
final public static int HEIGHT = 600;
final public static int OBJECT_SIZE = 15;
final public static float RESTITUTION = 1;
final public static int GROUND = 575;
public static int currentWave;
public static int numMeteors;
public static int numMissiles;
public static float score;
public static int destroyedCities;
public static boolean start = false;
public static int waveTimer = 200;


ArrayList<Meteor> meteors;
ArrayList<City> cities;
ArrayList<Missile> missiles;
Turret turret;

// Holds all the force generators and the Meteors they apply to
ForceRegistry forceRegistry;
//ContactResolver contactResolver;

// Holds the contacts
ArrayList contacts;

// Initialise screen and particle array
void setup() {
  size(800, 600);
  numMeteors = STARTING_METEORS;
  currentWave = 1;
  numMissiles = STARTING_MISSILES;
  bg = loadImage("background.jpg");
  frameRate(60);
  mouseCursor = loadImage("MouseCursor.png");
  meteors = new ArrayList<Meteor>();
  cities = new ArrayList<City>();
  missiles = new ArrayList<Missile>();
  turret = new Turret();
  //Create the ForceRegistry
  forceRegistry = new ForceRegistry();
  //Create the contact resolver and contacts AL
  //contactResolver = new ContactResolver();
  contacts = new ArrayList();
  this.meteors = createMeteors();
  //this.missiles = createMissiles();
  cities = createCities(NUM_CITIES);
}

// update Meteors, render.
void draw() {
  background(0);
  textSize(30);
  fill(0, 102, 153);
  text("Press Spacebar To Start", 225, 300); 
  
  if (start){
    background(bg);
    cursor(mouseCursor, 0, 0);
    textSize(20);
    text("Wave: " + currentWave, 25, 25); 
    textSize(20);
    text("Score: " + score, 25, 50); 
    textSize(20);
    text("Missiles: " + numMissiles, 25, 75); 
  
    forceRegistry.updateForces();
    //need to remove the missile
    
    //check for number of missiles, subtract each time
      for (int i=0; i<missiles.size(); i++) {
        if (missiles.get(i).timer <= 0) {
          missiles.remove(i);
        }
      }
    
      // missile explosion here
      for (int i=0; i<missiles.size(); i++) {
        Missile missile = (Missile) missiles.get(i);
        float d = dist(missiles.get(i).position.x, missiles.get(i).position.y, missiles.get(i).start.x, missiles.get(i).start.y); 
        if ((missiles.get(i).size > d)) {
          missile.explode();
           for (int j =0; j < numMeteors; j++){
           detectMissileCollision(meteors.get(j), missiles.get(i));
            } 
        } else{
          missile.project();
        }
       }

    //city here, permanent through intial game
    for (int x = 0; x < cities.size(); x++){
      cities.get(x).display();
    }
    turret.display();

    for (int i = 0; i < meteors.size(); i++) {
      if (meteors.get(i).position.y > 575){
          meteors.get(i).explode();
      }
       meteors.get(i).fall();
    }
    
    detectCityCollisions();

   
    //creating the ground here
    fill(255, 255, 255);
    rect(0, GROUND, WIDTH, 25);

    updateWave(meteors);   
    detectGameOver();
    contacts.clear();
  }
}

void detectCityCollisions() {
  for (int y = 0; y < numMeteors; y++){
    for (int z = 0; z < NUM_CITIES; z++){
      Contact contact = new Contact(meteors.get(y), cities.get(z));
      if (contact.collision(meteors.get(y), cities.get(z))) {
        cities.get(z).setCol1(244);
        cities.get(z).setCol2(66);
        cities.get(z).setCol3(66);
        destroyedCities++;
      }
    }
  }
}

void detectGameOver(){
 int count = 0;
 for (int i = 0; i < NUM_CITIES; i++) {
   if (cities.get(i).col2 == 66) {
     count++;
   }
 }
 if (count == NUM_CITIES){
   background(0);
   textSize(32);
   text("Game Over", 300, 300);
 }
}

void detectMissileCollision(Meteor p1, Missile p2) {
  float d = dist(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
  if ((p1.size/2 + p2.size/2 > d)) {
    Explosion missileExp = new Explosion(5, p2);
    forceRegistry.add(p1, missileExp);
  }
}

//create cities
ArrayList<City> createCities(int numCities){
   ArrayList<City> cities = new ArrayList<City>();
      cities.add(new City(100, 575, 0, 0, 0, 40));
      cities.add(new City(200, 575, 0, 0, 0, 40));
      cities.add(new City(300, 575, 0, 0, 0, 40));
      cities.add(new City(500, 575, 0, 0, 0, 40));
      cities.add(new City(600, 575, 0, 0, 0, 40));
      cities.add(new City(700, 575, 0, 0, 0, 40));
   return cities;
}

//creating meteors here
ArrayList<Meteor> createMeteors(){
  ArrayList<Meteor> meteors = new ArrayList<Meteor>();
  ////Create a gravitational force
  Gravity gravity = new Gravity(new PVector(0f, .03f));
  //Create a drag force
  //NB Increase k1, k2 to see an effect
  Drag drag = new Drag(3, 3);
    for (int i = 0; i < numMeteors; i++) {
    meteors.add(new Meteor((int)random(0,WIDTH),
                                1,
                                random(-3f,3f),
                                random(-.5f,.5f),
                                random(0.001f,0.005f),
                                (int)random(0, 600),
                                20));
    forceRegistry.add(meteors.get(i), gravity);
    forceRegistry.add(meteors.get(i), drag);
  }
  return meteors;
}

boolean waveFinished(ArrayList<Meteor> meteors){
  for(int i = 0; i < meteors.size(); i++){
     if (meteors.get(i).position.y < HEIGHT && meteors.get(i).position.y > 0 && meteors.get(i).position.x < WIDTH && meteors.get(i).position.x > 0) {
       return false;
     }
     if (meteors.get(i).position.y > 0 && meteors.get(i).position.x > WIDTH && meteors.get(i).position.x < 0){
       score = score + 5;
     }
  }
    return true;
}


void updateWave(ArrayList<Meteor> meteors){
  if (waveFinished(meteors)){
    if (waveTimer > 0){
      background(0);
       textSize(20);
       text("Wave " + currentWave + " End", 350, 300); 
       waveTimer--;
    } else {
      numMissiles = numMissiles += 10; 
      score = score + (NUM_CITIES - destroyedCities) * 1.5;
      currentWave++;
      numMeteors = numMeteors += 5;
      this.meteors = createMeteors();
      waveTimer = 200;
    }
  }
}

void mousePressed() {
  if (mouseButton == LEFT && numMissiles > 0) {
      missiles.add(new Missile(WIDTH/2, GROUND, true, mouseX,mouseY));
      numMissiles--;
  }
}

void startGame(){
  start = true;
}

void keyPressed() {
  if (key == ' ') { startGame(); }
}