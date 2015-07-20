class LED {
  PVector position;
  color c;
  
  LED(PVector position) {
    this.position = position;
    c = color(0);
  }
}

class Strip {
  PVector p1;
  PVector p2;
  int nLights;
  ArrayList<LED> lights;

  Strip(PVector p1, PVector p2) {
    this.p1 = p1;
    this.p2 = p2;
    nLights = ceil(dist(p1, p2) / meter * nLEDsPerMeter);
    println(nLights);
    
    // Create positions for each LED
    lights = new ArrayList<LED>();
    
    for (int i = 0; i < nLights; i++) {
      float n = i / float(nLights);
      PVector p = lerp(p1, p2, n);
      lights.add(new LED(p));
    }
  }
  
  void update() {
  }
  
  void display() {
    pushStyle();

    noStroke();
    for (LED L : lights) {
      pushMatrix();
      fill(L.c);
      translate(L.position.x, L.position.y, L.position.z);
      box(lightSize);
      popMatrix();
    }
    popStyle();
  }
}

