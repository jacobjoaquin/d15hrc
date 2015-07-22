class ScanLine {
  Strip strip;
  PixelMap pm;
  ArrayList<LED> theLights;
  int theLength;
  float theMin;
  float theMax;
  float bandwidth = 20;
  float counter = bandwidth;

  ScanLine(Strip strip) {
    this.strip = strip;
    pm = pixelMap;
    theLights = pm.lights;
    theLength = theLights.size();
  }

  void update() {
    
    pushStyle();
    colorMode(RGB);
    for (LED led : theLights) {
      float y = led.position.y;
      if (y >= counter && y <= counter + 20) {
        led.c = color(255);
      } else {
        led.c = color(64);
      }
    }
    counter += 5;
    if (counter > 500 + bandwidth) {
      counter = -bandwidth;
    }
    popStyle();
  }
}

