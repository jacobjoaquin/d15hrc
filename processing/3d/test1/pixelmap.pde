class PixelMap {
  int theWidth;
  int theHeight;
  PGraphics pg;
  ArrayList<LED> lights;
  PVector position;
  int nLights;

  PixelMap() {
    lights = new ArrayList<LED>();
    position = new PVector();
  }

  void add(ArrayList<Strip> strips) {
    for (Strip s : strips) {
      for (LED L : s.lights) {
        lights.add(L);
      }
    }
  }

  void finalize() {
    float s = sqrt(lights.size());
    theWidth = ceil(s);
    theHeight = ceil(s);
    pg = createGraphics(theWidth, theHeight);
    nLights = lights.size();
  }

  void update() {
    for (int y = 0; y < theHeight; y++) {
      int yIndex = y * theWidth;
      for (int x = 0; x < theWidth; x++) {
        int index = x + yIndex;
        
        if (index >= nLights) {
          break;
        }
        
        LED led = lights.get(index);
        pg.beginDraw();
        pg.loadPixels();
        pg.pixels[index] = led.c;
        pg.updatePixels();
        pg.endDraw();
      }
    }
  }

  void display() {    
    image(pg, position.x, position.y);
  }
}

