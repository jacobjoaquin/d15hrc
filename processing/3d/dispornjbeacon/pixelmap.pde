class PixelMap extends Displayable {
  int theLength;
  int rows;
  int columns;
  PGraphics pg;
  ArrayList<LED> lights;
  PVector position;
  int nLights;

  PixelMap() {
    lights = new ArrayList<LED>();
    position = new PVector();
  }

  void add(ArrayList<Strip> strips) {
    columns = 0;
    rows = strips.size();
    
    for (Strip strip : strips) {
      if (strip.nLights > columns) {
        columns = strip.nLights;
      }
      for (LED L : strip.lights) {
        lights.add(L);
        L.c = color(random(255));
      }
    }
    
    finalize();
  }

  void finalize() {
    pg = createGraphics(columns, rows);
    pg.background(0, 0, 255);
    nLights = lights.size();
  }

  void update() {
    pg.beginDraw();
    pg.background(255, 0, 0);
    
    for (int row = 0; row < rows; row++) {
      Strip strip = strips.get(row);
      int stripSize = strip.nLights;
      
      for (int col = 0; col < stripSize; col++) {
        int index = row * pg.width + col; 
        LED led = strip.lights.get(col);
        pg.loadPixels();
        pg.pixels[index] = led.c;
        pg.updatePixels();
      }
    }
    
    pg.endDraw();
  }

  void display() {
    image(pg, position.x, position.y);
  }
}

