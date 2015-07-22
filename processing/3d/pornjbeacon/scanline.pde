class ScanLine {
  Strip strip;
  PixelMap pm;
  ArrayList<LED> theLights;
  int theLength;
  float theMin;
  float theMax;
  float bandwidth = 10;
  float counter = bandwidth;

  ScanLine(Strip strip) {
    this.strip = strip;
    pm = pixelMap;
    theLights = pm.lights;
    theLength = theLights.size();
  }

  void update() {
    float tail = 100;
    pushStyle();
    colorMode(RGB);
    color pink = color(#ff6699);
    color orange = color(#ff8800);
    for (LED led : theLights) {
      float y = led.position.y;
      float d = y - counter;      // Difference

      if (d == bandwidth) {
        led.c = color(255);
      }
      else if (d >= 0 && d < bandwidth) {
        led.c = lerpColor(color(255), pink, 1 - d / bandwidth);
      } else if (d < 0 && d >= -tail) {
        led.c = lerpColor(pink, color(0), -d / tail);
      } else {
        led.c = color(0);
      }
    }
    counter += 5;
    if (counter > 500 + bandwidth + tail) {
      counter = -bandwidth;
    }
    popStyle();
  }
}

