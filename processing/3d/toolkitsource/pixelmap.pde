import moonpaper.*;

class PixelMap extends Displayable {
  int rows;
  int columns;
  PGraphics pg;
  ArrayList<LED> lights;
  int nLights;
  ArrayList<Strip> strips;
  int meter = 100;

  PixelMap() {
    strips = new ArrayList<Strip>();
  }

  void addStrips(ArrayList<Strip> theStrips) {
    strips.addAll(theStrips);
  }

  void finalize() {
    lights = new ArrayList<LED>();
    columns = 0;
    rows = strips.size();

    for (Strip strip : strips) {
      columns = max(columns, strip.nLights);

      for (LED L : strip.lights) {
        lights.add(L);
        L.c = color(random(255));
      }
    }

    println(strips.size());
    pg = createGraphics(columns, rows);
    nLights = lights.size();
  }

  void update() {
    pg.beginDraw();
    pg.background(255, 0, 0);
    pg.loadPixels();

    for (int row = 0; row < rows; row++) {
      Strip strip = strips.get(row);
      int stripSize = strip.nLights;
      int rowOffset = row * pg.width;
      ArrayList<LED> lights = strip.lights;

      for (int col = 0; col < stripSize; col++) {
        pg.pixels[rowOffset + col] = lights.get(col).c;
      }
    }

    pg.updatePixels();
    pg.endDraw();
  }

  void display() {
    try {
      image(pg, 0, 0);
    }
    catch (Exception e) {
      println("PixelMap.display() exception. Could not draw image");
    }
  }
}

