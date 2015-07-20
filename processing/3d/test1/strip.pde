

class Strip {
  PVector p1;
  PVector p2;
  int nLights;
  ArrayList<PVector> lights;

  Strip(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    nLights = floor(dist(p1, p2) / meter * nLEDsPerMeter);
    
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
  }
}

