import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

String jsonFile = "test.json";
PixelMap pixelMap;
Structure teatro;
Structure flatPanel;

ColorNoise colorNoise;

class ColorNoise extends DisplayableStrips {
  color c;
  
  ColorNoise(PixelMap pixelMap, Structure structure, color c) {
    super(pixelMap, structure);
    this.c = c;
  }
  
  void update() {
    pg.beginDraw();
    pg.background(0);
    pg.loadPixels();
    for (int i = 0; i < 1000; i++) {
      int r = int(random(pg.height));
      int col = int(random(strips.get(r).nLights));
      pg.pixels[r * pg.width + col] = c;
    }    
    pg.updatePixels();
    pg.endDraw();
  }
}

void setup() {
  ArrayList<Strip> strips = new ArrayList<Strip>();

  loadStrips(strips, jsonFile);
  pixelMap = new PixelMap();
  teatro = new Structure(pixelMap, jsonFile);
  flatPanel = new Structure(pixelMap, "flatpanel.json");
  pixelMap.finalize();

  colorNoise = new ColorNoise(pixelMap, teatro, color(255, 0, 128, 180));
  size(pixelMap.columns, pixelMap.rows);
}

void draw() {
  background(0);
  colorNoise.update();
  colorNoise.display();
  pixelMap.display();
}

