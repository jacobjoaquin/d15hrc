class Strip {
  PVector p1;
  PVector p2;
  int nLEDsPerMeter;
  int nLights;
  ArrayList<LED> lights;

  Strip(PVector p1, PVector p2, int nLEDsPerMeter) {
    this.p1 = p1;
    this.p2 = p2;
    this.nLEDsPerMeter = nLEDsPerMeter;
    nLights = ceil(dist(p1, p2) / meter * nLEDsPerMeter);
    
    // Create positions for each LED
    lights = new ArrayList<LED>();    
    for (int i = 0; i < nLights; i++) {
      float n = i / float(nLights);
      PVector p = lerp(p1, p2, n);
      lights.add(new LED(p));
    }
  }
}



