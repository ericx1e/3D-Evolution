final float MUTATION_RATE = 0.5;
final float MUTATION_VAR = 0.3;

class Creature{
  PVector location;
  PVector vel;
  float speed, sense, energy;
  boolean isDead, canReproduce;

  Creature(float x, float z) {
    location = new PVector(x, 0, z);
    vel = new PVector();
    isDead = false;

    energy = 100;
    speed = random(3, 6);
    sense = random(50, 200);
  }
  
  //public int compareTo(Creature other) {
  //  return (int)(energy-other.energy);
  //}

  void show() {
    pushMatrix();
    fill(0, speed/10*220, 255-speed/10*255, Math.max(0, 255*energy/100));
    translate(location.x, location.y-R*1.5, location.z);
    noStroke();
    sphere(R*2);
    fill(0);
    textSize(18);
    textAlign(CENTER, CENTER);
    rotateY(PI);
    text("sense: " + sense, 0, -R*2-72, 0);
    popMatrix();
  }

  void move() {
    PVector rand = PVector.fromAngle(random(2*PI));
    vel.add(new PVector(rand.x, 0, rand.y));
    vel.setMag(speed);
    location.add(vel);

    energy-=Math.pow((speed/10), 2)+sense/1000;
    isDead = energy < 0;
    canReproduce = energy > 200;
  }

  boolean move(PVector target) {
    PVector t = target.copy();
    vel = t.sub(location);
    vel.setMag(speed);
    location.add(vel);

    energy-=Math.pow((speed/10), 2)+sense/1000;
    isDead = energy < 0;
    canReproduce = energy > 200;
    if (dist(location, target) < 3*R) {
      return true;
    }
    return false;
  }

  Creature getBaby() {
    energy = 150;
    Creature baby = new Creature(location.x, location.z);
    if (random(1) < MUTATION_RATE) {
      baby.speed = Math.max(speed+5*random(-MUTATION_VAR, MUTATION_VAR), 0);
      baby.sense = Math.max(sense+200*random(-MUTATION_VAR, MUTATION_VAR), 0);
    } else {
      baby.speed = Math.max(speed+5*random(-MUTATION_VAR/5, MUTATION_VAR/5), 0);
      baby.sense = Math.max(sense+200*random(-MUTATION_VAR/5, MUTATION_VAR/5), 0);
    }
    baby.move(new PVector().sub(vel));
    return baby;
  }
}
