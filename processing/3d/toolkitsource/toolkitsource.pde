import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

String jsonFile = "test.json";
PixelMap pixelMap;
Structure teatro;
Structure flatPanel;

ColorNoise colorNoise;
StripSweep stripSweep;

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


class StripSweep extends DisplayableStrips {
  ArrayList<StripAnimation> animations;

  class StripAnimation {
    Strip strip;
    int position;

    StripAnimation(Strip strip) {
      this.strip = strip;
      position = 0;
    }
  }

  StripSweep(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    setup();
  }

  void setup() {
    super.setup();
    animations = new ArrayList<StripAnimation>();

    for (Strip strip : strips) {
      animations.add(new StripAnimation(strip));
    }
  }

  void update() {
    super.update();
    for (StripAnimation animation : animations) {
      animation.position = (animation.position + 1) % animation.strip.nLights;
    }
  }

  void display() {
    pg.beginDraw();
    pg.clear();
    pg.loadPixels();
    for (int row = 0; row < pg.height; row++) {
      StripAnimation animation = animations.get(row);
      pg.pixels[row * pg.width + animation.position] = color(255);
    }

    pg.updatePixels();
    pg.endDraw();
    super.display();
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
  stripSweep = new StripSweep(pixelMap, teatro);
  size(pixelMap.columns, pixelMap.rows);
}

void draw() {
  background(0);
  colorNoise.update();
  stripSweep.update();
  colorNoise.display();
  stripSweep.display();
  pixelMap.display();
}

