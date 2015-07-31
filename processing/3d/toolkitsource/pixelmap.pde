import moonpaper.*;

// PixelMap.createStructure()
// PixelMap.createPartialStructe()

class PixelMap extends Displayable {
  ArrayList<Strip> strips;
  ArrayList<LED> leds;
  int rows = 0;
  int columns;
  PGraphics pg;
  int nLights;

  PixelMap() {
    strips = new ArrayList<Strip>();
  }

  void addStrips(ArrayList<Strip> theStrips) {
    strips.addAll(theStrips);
    rows += theStrips.size();
  }

  void finalize() {
    leds = new ArrayList<LED>();
    columns = 0;
    //    rows = strips.size();

    for (Strip strip : strips) {
      columns = max(columns, strip.nLights);

      for (LED L : strip.leds) {
        leds.add(L);
        L.c = color(random(255));
      }
    }

    pg = createGraphics(columns, rows);
    pg.background(255, 0, 0);
    nLights = leds.size();
  }

  void update() {
    pg.beginDraw();
    pg.background(255, 0, 0);
    pg.loadPixels();

    for (int row = 0; row < rows; row++) {
      Strip strip = strips.get(row);
      int stripSize = strip.nLights;
      int rowOffset = row * pg.width;
      ArrayList<LED> leds = strip.leds;

      for (int col = 0; col < stripSize; col++) {
        pg.pixels[rowOffset + col] = leds.get(col).c;
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

