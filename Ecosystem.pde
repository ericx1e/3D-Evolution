class Ecosystem {
  PImage img = loadImage("https://image.freepik.com/free-photo/top-view-green-grass-background-texture_1253-1416.jpg");
  float size; //diameter
  PVector center;
  ArrayList<Food> food;
  Population population;

  public Ecosystem(float size) {
    this.size = size;
    center = new PVector(width/2, 0, size/2);
    food = new ArrayList();
    randomizeFood(200);
    population = new Population(10, size);
  }
  
  void show() {
    pushMatrix();
    translate(center.x, center.y, center.z);
    rotateX(PI/2);
    noFill();
    stroke(0);
    strokeWeight(5);
    rectMode(CORNER);
    for (int r = 0; r < size/100; r++) {
      for (int c = 0; c < size/100; c++) {
        rect(c*100-size/2, r*100-size/2, 100, 100);
      }
    }
    //fill(50, 255, 150);
    fill(255);
    translate(0, 0, 5);
    ellipse(0, 0, size, size);
    popMatrix();

    for (Food e : food) {
      e.show();
    }

    population.show();
  }
  /*
  
   void drawCylinder(int sides, float r, float h) {
   float angle = 360 / sides;
   float halfHeight = h / 2;
   // draw top shape
   beginShape();
   for (int i = 0; i < sides; i++) {
   float x = cos( radians( i * angle ) ) * r;
   float y = sin( radians( i * angle ) ) * r;
   vertex( x, y, -halfHeight );
   }
   endShape(CLOSE);
   // draw bottom shape
   beginShape();
   for (int i = 0; i < sides; i++) {
   float x = cos( radians( i * angle ) ) * r;
   float y = sin( radians( i * angle ) ) * r;
   vertex( x, y, halfHeight );
   }
   endShape(CLOSE);
   }
   */

  void update(int mode) {
    if(mode == 1) {
      if(food.size() == 0) {
        population.nextGen();
        randomizeFood(100);
      }
    }
    population.update(food, size, center, mode);
    if(mode == 0) {
      if (frameCount % 3  == 0) {
        randomizeFood(1);
      }
    }
  }
  
  void randomizeFood(int n) {
    float rx = random(size);
    float rz = random(size);
    PVector rv = new PVector(rx, 0, rz);
    for (int i = 0; i < n; i++) {
      rx = random(size);
      rz = random(size);
      rv = new PVector(rx, 0, rz);
      while (rv.sub(center).mag() > size/2) {
        rx = random(size);
        rz = random(size);
        rv = new PVector(rx, 0, rz);
      }
      food.add(new Food(rx, rz));
    }
  }
}
