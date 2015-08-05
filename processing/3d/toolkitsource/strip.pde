class Strips extends ArrayList<Strip> {
  int getMaxStripLength() {
    int L = 0;
    int stripSize = size();
    for (Strip strip : this) {
      if (strip.nLights > 0) {
        L = strip.nLights;
      }
    }
    return L;
  }
}

class Strip {
  PVector p1;
  PVector p2;
  int density;
  int nLights;
  ArrayList<LED> leds;

  Strip(PVector p1, PVector p2, int density) {
    this.p1 = p1;
    this.p2 = p2;
    this.density = density;
    nLights = ceil(dist(p1, p2) / meter * density);

    // Create positions for each LED
    leds = new ArrayList<LED>();    
    for (int i = 0; i < nLights; i++) {
      float n = i / float(nLights);
      PVector p = lerp(p1, p2, n);
      leds.add(new LED(p));
    }
  }
}

