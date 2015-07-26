import moonpaper.*;

class PixelMap extends Displayable {
  int rows;
  int columns;
  PGraphics pg;
  ArrayList<LED> lights;
  int nLights;
  ArrayList<Strip> strips;
  int meter = 100;

  PixelMap(ArrayList<Strip> strips) {
    this.strips = strips;
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

    pg = createGraphics(columns, rows);
//    pg.background(0, 0, 255);
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
    image(pg, 0, 0);
  }
}

