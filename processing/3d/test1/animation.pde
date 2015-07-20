class Animation {
  Strip strip;
  ArrayList<Boolean> lights1;
  ArrayList<Boolean> lights2;
  float r = 0.25;
  int theLength;
  
  Animation(Strip strip) {
    this.strip = strip;
    
    theLength = strip.nLights;
    lights1 = new ArrayList<Boolean>();
    lights2 = new ArrayList<Boolean>();
    
    for (int i = 0; i < theLength; i++) {
      if (random(1) < r) {
        lights1.add(i, true);
      } else {
        lights1.add(i, false);
      }

      if (random(1) < r) {
        lights2.add(i, true);
      } else {
        lights2.add(i, false);
      }
    }
  }
  
  void update() {
    for (int i = 0; i < theLength; i++) {
      Boolean b = lights1.get(i);
      LED led = strip.lights.get(i);
      
      if (b) {
        led.c = color(255);
      } else {
        led.c = color(0);
      }
    }
  }
}
