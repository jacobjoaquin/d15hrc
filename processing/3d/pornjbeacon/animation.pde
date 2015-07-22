class Animation {
  Strip strip;
  ArrayList<Boolean> lights1;
  ArrayList<Boolean> lights2;
  float r = 1.0 / 3.0;
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
    Boolean temp = lights1.remove(theLength - 1);
    lights1.add(0, temp);
    Boolean temp2 = lights2.remove(0);
    lights2.add(temp2);
    
    for (int i = 0; i < theLength; i++) {
      Boolean b1 = lights1.get(i);
      Boolean b2 = lights2.get(i);
      LED led = strip.lights.get(i);
      
      if (b1 || b2) {
        led.c = color(#ff6699);
      } else {
        led.c = color(0);
      }
    }
  }
}
