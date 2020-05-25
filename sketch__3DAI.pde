float camX, camY, camZ, eyeX, eyeY, eyeZ;
float camAngle=PI/2;
float yCamAngle=PI/2;
int camMode = 0;
int screen = 0;
PFont font;
int evolutionMode = 0;
//import java.util.Comparator;
import java.util.TreeMap;
import java.util.TreeSet;

//boolean birdsEye = false;

final float CAM_SPEED = 5;
final float CAM_TURN_SPEED = 0.05;

Ecosystem ecosystem;
String[] fontList;
void setup() {
  size(1024, 768, P3D);
  camX = width/2;
  camY = height/2-500;
  camZ = -100;
  eyeZ = -60;
  ecosystem = new Ecosystem(2000);
  //fontList = PFont.list();
  //printArray(fontList);
    font = createFont("AvenirNext-UltraLight",100,true);
}

float startScreenTextAngle;
//float startScreenLight;
boolean goingLeft = false;
void draw() {
  if (screen == 0) {
    //mono = createFont("Zapfino",100);
    background(255);
    textAlign(CENTER,CENTER);
    textSize(100);
    pushMatrix();
    translate(width/2, height/2-200);
    rotateY(startScreenTextAngle);
    textFont(font);
    for(float i = 0; i < 100; i++) {
      fill(i*2.55);
      text("3D Evolution", 0, 0, i/4);
    }
    popMatrix();
    pushMatrix();
    translate(width/2, height/2+200);
    rotateX(startScreenTextAngle);
    textSize(50);
    for(float i = 0; i < 100; i++) {
      fill(i*2.55);
      text("Press Space To Start", 0, 0, i/4);
    }
    popMatrix();
    pushMatrix();
    translate(width/2, height/2);
    fill(0, 255, 255);
    noStroke();
    directionalLight(255, 255, 255, -1, 1, -1);
    directionalLight(255, 255, 0, 1, -1, -1);
    sphere(50);
    popMatrix();
    startScreenTextAngle+=goingLeft?-0.01:0.01;
    //startScreenLight+=0.1;
    //if(startScreenLight > 1) {
    //  startScreenLight = -1;
    //}
    if(Math.abs(startScreenTextAngle) > PI/4) {
      goingLeft = !goingLeft;
    }
    if(key == ' ') {
      screen++;
    }
  }
  if (screen == 1) {
    background(255);
    directionalLight(255, 200, 126, 1, 1, -1);
    directionalLight(0, 200, 200, -1, 1, 1);
    ambientLight(200, 200, 200);
    fill(0);
    textSize(360);
    pushMatrix();
    translate(width/2, height/2, 3000);
    rotateY(PI);
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    noFill();
    stroke(0);
    strokeWeight(5);
    rect(0, -2000, 3600, 1800);
    text("fps: " + (int)frameRate + "\nCreatures: " + ecosystem.population.creatures.size() + "\nFood: " + ecosystem.food.size(), 0, -2000, 0);
    popMatrix();
    switch(camMode) {
      case(0):
      camControl();
      camera(camX, camY, camZ, camX+cos(camAngle), camY+sin(yCamAngle), camZ+sin(camAngle)-cos(yCamAngle), 0, 1, 0);
      break;
      case(1):
      camControl();
      camera(width/2, -ecosystem.size, ecosystem.size/2+1, width/2, 0, ecosystem.size/2, 0, -1, 0);
      translate(camX, camY, camZ);
      fill(255, 0, 0);
      noStroke();
      rotateY(PI-camAngle);
      box(50);
      fill(0);
      translate(-25, 0, -10);
      box(10);
      translate(25, 0, 10);
      translate(-25, 0, 10);
      box(10);
      translate(25, 0, -10);
      rotateY(-PI+camAngle);
      translate(-camX, -camY, -camZ);
      break;
      case(2):
      if (ecosystem.population.creatures.size() == 0) {
        camMode++;
      }
      Creature c = ecosystem.population.creatures.get(0);
      println(c.location.x + ", " + c.location.z);
      camera(c.location.x, c.location.y-R*2, c.location.z, c.location.x+c.vel.x, c.location.y-R*2, c.location.z+c.vel.z, 0, 1, 0);
      break;
    }
    //noFill();
    //for(int i = 0; i <= 10; i++) {
    //  for(int j = 0; j <= 10; j++) {s
    //    beginShape();
    //    vertex(j*100, 0, i*100);
    //    vertex(j*100+100, 0, i*100);
    //    vertex(j*100+100, 0, i*100+100);
    //    vertex(j*100, 0, i*100+100);
    //    vertex(j*100, 0, i*100);
    //    endShape();
    //  }
    //}

    //camera();
    ecosystem.show();
    ecosystem.update(evolutionMode);
  }
}

void camControl() {
  if (w) {
    camZ+=sin(camAngle)*CAM_SPEED;
    camX+=cos(camAngle)*CAM_SPEED;
  }
  if (a) {
    camZ-=cos(camAngle)*CAM_SPEED;
    camX+=sin(camAngle)*CAM_SPEED;
  }
  if (s) {
    camZ-=sin(camAngle)*CAM_SPEED;
    camX-=cos(camAngle)*CAM_SPEED;
  }
  if (d) {
    camZ+=cos(camAngle)*CAM_SPEED;
    camX-=sin(camAngle)*CAM_SPEED;
  }
  if (up) {
    yCamAngle+=CAM_TURN_SPEED;
  }
  if (left) {
    camAngle-=CAM_TURN_SPEED;
  }
  if (down) {
    yCamAngle-=CAM_TURN_SPEED;
  }
  if (right) {
    camAngle+=CAM_TURN_SPEED;
  }
}

boolean w, a, s, d, up, left, down, right, space, shift;

void keyPressed() {
  if (key == 'w') {
    w = true;
  }
  if (key == 'a') {
    a = true;
  }
  if (key == 's') {
    s = true;
  }
  if (key == 'd') {
    d = true;
  }
  if (keyCode == UP) {
    up = true;
  }
  if (keyCode == LEFT) {
    left = true;
  }
  if (keyCode == DOWN) {
    down = true;
  }
  if (keyCode == RIGHT) {
    right = true;
  }
  if (key == ' ') {
    for (int i = 0; i < ecosystem.food.size()/2; i++) {
      ecosystem.food.remove(0);
    }
  }
  if (key == 'm') {
    pushMatrix();
    translate(ecosystem.center.x, ecosystem.center.y, ecosystem.center.z);
    for (int i = 0; i < 1; i++) {
      ecosystem.food.add(new Food(-width/2+mouseX, -height/2+mouseY));
    }
    popMatrix();
  }

  if (key == 'S') {
    int n = ecosystem.population.creatures.size();
    for (int i = 0; i < n/2; i++) {
      ecosystem.population.creatures.remove(0);
    }
  }

  if (keyCode == SHIFT) {
    camMode++;
    camMode %= 3;
  }
}



void keyReleased() {
  if (key == 'w') {
    w = false;
  }
  if (key == 'a') {
    a = false;
  }
  if (key == 's') {
    s = false;
  }
  if (key == 'd') {
    d = false;
  }
  if (keyCode == UP) {
    up = false;
  }
  if (keyCode == LEFT) {
    left = false;
  }
  if (keyCode == DOWN) {
    down = false;
  }
  if (keyCode == RIGHT) {
    right = false;
  }
}

void mousePressed() {
  ecosystem.food.add(new Food(mouseX, mouseY));
}
