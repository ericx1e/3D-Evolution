final float R = 10;

class Food {
  PVector location;

  public Food(float x, float z) {
    location = new PVector(x, 0, z);
  }

  public void show() {
    fill(255, 100, 0);
    pushMatrix();
    translate(location.x, location.y-R*1.5, location.z);
    noStroke();
    sphere(R);
    popMatrix();
  }
}
