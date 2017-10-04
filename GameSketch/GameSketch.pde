PImage mouseCursor;
PImage bg;

final public static int STARTING_METEORS = 5;
final public static int NUM_CITIES = 6;
final public static int NUM_WAVES = 5;
final public static int WIDTH = 800;
final public static int HEIGHT = 600;
final public static int OBJECT_SIZE = 15;
final public static float RESTITUTION = 1;
final public static int GROUND = 575;
public static int currentWave;
public static int numParticles;
public static int score;
public static int destroyedCities;
public static boolean start = false;

ArrayList<Meteor> meteors;
ArrayList<City> cities;
ArrayList<Missile> missiles;
Turret turret;

// Holds all the force generators and the particles they apply to
ForceRegistry forceRegistry;
//ContactResolver contactResolver;

// Holds the contacts
ArrayList contacts;

// Initialise screen and particle array
void setup() {
  size(800, 600);
  numParticles = STARTING_METEORS;
  currentWave = 1;
  bg = loadImage("background.jpg");
  frameRate(60);
  mouseCursor = loadImage("MouseCursor.png");
  meteors = new ArrayList<Meteor>();
  cities = new ArrayList<City>();
  missiles = new ArrayList<Missile>();
  //Create the ForceRegistry
  forceRegistry = new ForceRegistry();
  //Create the contact resolver and contacts AL
  //contactResolver = new ContactResolver();
  contacts = new ArrayList();
  this.meteors = createMeteors();
  cities = createCities(NUM_CITIES);
}

// update particles, render.
void draw() {
  background(0);
  textSize(30);
  fill(0, 102, 153);
  text("To start press spacebar ", 200, 300); 
  
  if (start){
    background(bg);
    cursor(mouseCursor, 0, 0);
    textSize(20);
    text("Wave: " + currentWave, 25, 25); 
    textSize(20);
    text("Score: " + score, 25, 50); 
  
    forceRegistry.updateForces();
    //need to remove the missile
    for (int i=0; i<missiles.size(); i++) {
      if (missiles.get(i).timer <= 0) {
      //if ((missiles.get(i).start.x == missiles.get(i).xS) && (missiles.get(i).start.y == missiles.get(i).yS)) {
          missiles.remove(i);
      }
    }
    System.out.println(numParticles);
    // missile explosion here
    for (int i=0; i<missiles.size(); i++) {
      Missile missile = (Missile) missiles.get(i);
      missile.update();
      missile.display();
      for (int j =0; j < numParticles; j++){
         detectMissileCollision(meteors.get(j), missiles.get(i));
      }
    }

    //city here, permanent through intial game
    for (int x = 0; x < cities.size(); x++){
      cities.get(x).display();
    }

    for (int i = 0; i < meteors.size(); i++) {
      meteors.get(i).integrate();
    }
    detectCityCollisions();

    detectGameOver();
    //creating the ground here
    fill(255, 255, 255);
    rect(0, GROUND, WIDTH, 25);

    updateWave(meteors);
    contacts.clear();
  }
}

void detectCityCollisions() {
  for (int y = 0; y < numParticles; y++){
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
   text("Game Over", 200, 300);
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
    for (int i = 0; i < numParticles; i++) {
    meteors.add(new Meteor((int)random(0,WIDTH),
                                1,
                                random(-3f,3f),
                                random(-.5f,.5f),
                                random(0.001f,0.005f),
                                (int)random(0, 600),
                                10));
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
       score+=5;
     }
  }
  return true;
}

//wave transition needed boolean switch,
//boolean waveOff;
void updateWave(ArrayList<Meteor> meteors){
  if (waveFinished(meteors)){
    
    score += (NUM_CITIES - destroyedCities) * 1.5;
    currentWave++;
    numParticles = numParticles += 5;
    this.meteors = createMeteors();
    System.out.println("numParticles: " + numParticles);
    System.out.println("currentWave:" + currentWave);
  
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
     missiles.add(new Missile(WIDTH/2, GROUND, true, mouseX,mouseY));
  }
  else {
    missiles.add(new Missile(WIDTH/2, GROUND, true, mouseX,mouseY));
  }
}

void startGame(){
  start = true;
  
}

void keyPressed() {
  if (key == ' ') { startGame(); }
}