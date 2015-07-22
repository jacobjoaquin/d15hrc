class ScanLine {
  Strip strip;
  PixelMap pm;
  ArrayList<LED> theLights;
  int theLength;
  float theMin;
  float theMax;
  float head = 10;
  float tail = 125;
  float velocity = 5;
  float counter = head;

  ScanLine(Strip strip) {
    this.strip = strip;
    pm = pixelMap;
    theLights = pm.lights;
    theLength = theLights.size();
  }

  void update() {
    pushStyle();
    colorMode(RGB);
    color pink = color(#ff6699);
    color orange = color(#ff8800);
    for (LED led : theLights) {
      float y = led.position.y;
      float d = y - counter;      // Difference

      if (d == head) {
        led.c = color(255);
      }
      else if (d >= 0 && d < head) {
        led.c = lerpColor(color(255), pink, 1 - d / head);
      } else if (d < 0 && d >= -tail) {
        led.c = lerpColor(pink, color(0), -d / tail);
      } else {
        led.c = color(0);
      }
    }
    counter += velocity;
    if (counter > 500 + head + tail) {
      counter = -head;
    }
    popStyle();
  }
}

