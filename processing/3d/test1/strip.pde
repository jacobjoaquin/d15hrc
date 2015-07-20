

class Strip {
  PVector p1;
  PVector p2;
  int nLights;
  ArrayList<PVector> lights;

  Strip(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    nLights = floor(dist(p1, p2) / meter * nLEDsPerMeter);
    println(nLights);
    
    // Create positions for each LED
    lights = new ArrayList<PVector>();
    
    for (int i = 0; i < nLights; i++) {
      float n = i / float(nLights);
      PVector p = lerp(p1, p2, n);
      lights.add(p);
    }
  }
  
  void update() {
  }
  
  void display() {
    pushStyle();
    stroke(255);
//    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
    noStroke();
    colorMode(RGB);
    fill(#ff6688);
    for (PVector p : lights) {
      pushMatrix();
      translate(p.x, p.y, p.z);
      box(lightSize);
      popMatrix();
    }
    popStyle();
  }
}

