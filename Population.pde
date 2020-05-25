class Population {
  ArrayList<Creature> creatures;
  float size;

  Population(int n, float size) {
    creatures = new ArrayList();
    this.size = size;
    for (int i = 0; i < n; i++) {
      creatures.add(new Creature(width/2, size/2));
    }
  }

  void show() {
    for (Creature e : creatures) {
      e.show();
    }
  }

  void update(ArrayList<Food> food, float size, PVector center, int mode) {
    ArrayList<Creature> toRemoveCreature = new ArrayList();
    ArrayList<Creature> toAddCreature = new ArrayList();
    for (Creature c : creatures) {
      PVector centerCopy = center.copy();
      if (centerCopy.sub(c.location).mag() > size/2) {
        c.move(center);
      }
      ArrayList<Food> toRemoveFood = new ArrayList();
      boolean flag = false;
      Food min = new Food(Integer.MAX_VALUE, Integer.MAX_VALUE);
      float minDist = dist(c.location, min.location);
      for (Food f : food) {
        if (dist(c.location, f.location) < c.sense) {
          flag = true;
          if (dist(c.location, f.location) < minDist) {
            min = f;
            minDist = dist(c.location, f.location);
          }
        }
      }
      if (flag) {
        if (c.move(min.location)) {
          c.energy+=40;
          toRemoveFood.add(min);
        }
      }
      if (!flag) {
        c.move();
      }
      if(mode == 0) {
        if (c.isDead) {
          toRemoveCreature.add(c);
        }
        if (c.canReproduce) {
          for (int i = 0; i < 1; i++) 
            toAddCreature.add(c.getBaby());
        }
      }
      /*
      if(toRemoveFood.size() != 0) {
       float rx = random(size);
       float rz = random(size);
       PVector rv = new PVector(rx, 0, rz);
       rx = random(size);
       rz = random(size);  
       rv = new PVector(rx, 0, rz);
       while(rv.sub(center).mag() > size/2) {
       rx = random(size);
       rz = random(size);
       rv = new PVector(rx, 0, rz);
       }
       food.add(new Food(rx, rz));
       }
       */

      food.removeAll(toRemoveFood);
    }
    for (Creature e : toRemoveCreature) {
      food.add(new Food(e.location.x, e.location.z));
    }
    creatures.removeAll(toRemoveCreature);
    creatures.addAll(toAddCreature);
  }
  
  void nextGen() {
    ArrayList<Creature> nextGen = new ArrayList();
    float[] energies = new float[creatures.size()];
    TreeMap<Float, Creature> energyMap = new TreeMap();
    for(int i = 0; i < creatures.size(); i++) {
      energyMap.put(creatures.get(i).energy, creatures.get(i));
      energies[i] = creatures.get(i).energy;
    }
    energies = sort(energies);
    for(int i = 0; i < energies.length; i++) {
      nextGen.add(energyMap.get(energies[i]));
    }
    
    int n = nextGen.size();
    for(int i = 0; i < n/2; i++) {
      nextGen.remove(0);
    }
    
    n = nextGen.size();
    for(int i = 0; i < n; i++) {
      nextGen.get(i).location = new PVector(width/2, 0, size/2);
      nextGen.add(nextGen.get(i).getBaby());
      nextGen.get(i).energy = 100;
    }
    
    //for(Creature c : creatures) {
    //  if(c.isDead) continue;
    //  c.location = new PVector(width/2, 0, size/2);
    //  nextGen.add(c);
    //  if(c.canReproduce) {
    //    nextGen.add(c.getBaby());
    //  }
    //}
    creatures = nextGen;
  }
}

float dist(PVector a, PVector b) {
  return dist(a.x, a.y, a.z, b.x, b.y, b.z);
}
