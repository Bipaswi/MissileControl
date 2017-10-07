import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GameSketch extends PApplet {

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
public void setup() {
  
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
public void draw() {
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

public void detectCityCollisions() {
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

public void detectGameOver(){
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

public void detectMissileCollision(Meteor p1, Missile p2) {
  float d = dist(p1.position.x, p1.position.y, p2.position.x, p2.position.y);
  if ((p1.size/2 + p2.size/2 > d)) {
    Explosion missileExp = new Explosion(5, p2);
    forceRegistry.add(p1, missileExp);
  }
}

//create cities
public ArrayList<City> createCities(int numCities){
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
public ArrayList<Meteor> createMeteors(){
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

public boolean waveFinished(ArrayList<Meteor> meteors){
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


public void updateWave(ArrayList<Meteor> meteors){
  if (waveFinished(meteors)){
    if (waveTimer > 0){
      background(0);
       textSize(20);
       text("Wave " + currentWave + " End", 350, 300); 
       waveTimer--;
    } else {
      numMissiles = numMissiles += 10; 
      score = score + (NUM_CITIES - destroyedCities) * 1.5f;
      currentWave++;
      numMeteors = numMeteors += 5;
      this.meteors = createMeteors();
      waveTimer = 200;
    }
  }
}

public void mousePressed() {
  if (mouseButton == LEFT && numMissiles > 0) {
      missiles.add(new Missile(WIDTH/2, GROUND, true, mouseX,mouseY));
      numMissiles--;
  }
}

public void startGame(){
  start = true;
}

public void keyPressed() {
  if (key == ' ') { startGame(); }
}
final class City {

  public PVector position;
  public int col1;
  public int col2;
  public int col3;
  public int size;
  int c;
  
   City(int x, int y, int col1, int col2, int col3, int size){
    position = new PVector(x, y);
    this.col1 = col1;
    this.col2 = col2;
    this.col3 = col3;
    this.size = size;
   }
   
   public void setCol1(int col1) {
        this.col1 = col1;
   }
   
    public void setCol2(int col2) {
        this.col2 = col2;
    }
    
     public void setCol3(int col3) {
        this.col3 = col3;
    }

   public void display(){
     fill(col1, col2, col3);
     noStroke();
     arc(position.x, position.y, size, size, -PI, 0); 
   }
   
}
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
  
public boolean collision (Meteor p1, City c1) {
    float d = dist(p1.position.x, p1.position.y, c1.position.x, c1.position.y); 
    if ((p1.size/2 + c1.size/2 > d) && c1.col1 == 0) {
    return true;
    } else {
    return false;
    }
  }
}
//example given in lectures
public final class Drag extends ForceGenerator {
  // Velocity drag coefficient
  private float k1 ;
  // Velocity squared drag coefficient
  private float k2 ;
  
  // Construct generator with the given coefficients
  Drag(float k1, float k2) {
    this.k1 = k1 ;
    this.k2 = k2 ; 
  }
  
  // Applies the drag force to the given particle
  public void updateForce(Meteor particle) {
    PVector force = particle.velocity.get() ;
    
    //Calculate the total drag coefficient
    float dragCoeff = force.mag() ;
    dragCoeff = k1 * dragCoeff + k2 * dragCoeff * dragCoeff ;
    
    //Calculate the final force and apply it
    force.normalize() ;
    force.mult(-dragCoeff) ;
    particle.addForce(force) ;
  }
}
public class Explosion extends ForceGenerator{
   
  public int magnitude = 1;
  public Missile missile; 
   
  Explosion(int magnitude, Missile missile){
   this.magnitude = magnitude;
   this.missile = missile;
  }
   
  public void updateForce(Meteor meteor) {
    PVector force = meteor.position.copy();
    force.sub(missile.position);
    force.normalize();
    force.mult(magnitude);
    meteor.addForce(force);
  }
}

abstract class ForceGenerator {
  public abstract void updateForce(Meteor p) ;
}

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
  public void add(Meteor p, ForceGenerator fg) {
    registrations.add(new ForceRegistration(p, fg)) ; 
  }

  /**
   * Calls all force generators to update the forces of their
   *  corresponding particles.
   */
  public void updateForces() {
    Iterator<ForceRegistration> itr = registrations.iterator() ;
    while(itr.hasNext()) {
      ForceRegistration fr = itr.next() ;
      fr.forceGenerator.updateForce(fr.meteor) ;
    }
  }
}
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

  public void updateForce(Meteor particle) {
    PVector resultingForce = gravity.get();
    resultingForce.mult(particle.getMass());
    particle.addForce(resultingForce);
  }
}
final class Meteor {
  
  public PVector position;
  public PVector velocity;
  private PVector forceAccumulator;
  private float invMass;
  private int timer;
  public int explosionTimer = 60;
  public int transparency = 255;
  public int explosionSize = 50;
  private int size;
  int c;
  
  public float getMass() {
     return 1/invMass;
  }
  
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
  public void addForce(PVector force) {
    forceAccumulator.add(force);
  }
  
  public void fall() {
    if (invMass <= 0f) return;
      if (timer > 0){
        timer--;
      }
      if (timer <= 0) {
        position.add(velocity);
    
        PVector resultingAcceleration = forceAccumulator.get();
        resultingAcceleration.mult(invMass);
        velocity.add(resultingAcceleration);
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
  
  public void explode(){
   if (explosionTimer > 0){
       explosionTimer-=5;
       explosionSize+=4;
       transparency-=25;
    }
    noStroke();
    c = color(255, 255, 0);
    fill(c, transparency);
    ellipse(position.x, 575, explosionSize, explosionSize); 
  }
}
public class Missile {
  
  public PVector position;
  public PVector start;
  public PVector velocity;
  public int xS;
  public int yS;
  public int x;
  public int y;
  public float size = 10;
  public int c;
  public boolean transparencyOn;
  public int transparency;
  public int timer = 60;
  public int magnitude = 10;
  
  Missile(int x, int y, boolean transparencyOn, int xS, int yS) {
    start = new PVector(x, y);
    position = new PVector(xS, yS);
    this.transparencyOn = transparencyOn;
    c = color(169, 169, 169);
    transparency = 255;
  }
 
  public void project() {
    velocity = new PVector(position.x - start.x, position.y - start.y);
    velocity.normalize();
    velocity.mult(magnitude);
    start.add(velocity); 
    noStroke();
    fill(c);
    ellipse(start.x, start.y,size,size);
  }
  
  public void explode() {
   if (timer > 0){
       timer-=1.5f;
       size+=2.5f;
       transparency-=2;
    }
    noStroke();
    fill(c,transparency);
    ellipse(position.x, position.y,size,size);
  }
}
public class Turret  {
  
public void display(){  
  fill(46, 139, 87);
  noStroke();
  arc(400, 575, 20, 20, -PI, 0); 
  }
}
  public void settings() {  size(800, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GameSketch" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
