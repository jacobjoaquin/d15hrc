import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

String jsonFile = "test.json";

Moonpaper mp;
PixelMap pixelMap;
Structure teatro;
Structure flatPanel;

ColorNoise colorNoise;
StripSweep stripSweep;

int theFrameRate = 60;

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
      pg.pixels[row * pg.width + animation.position] = color(255, 128, 0);
    }

    pg.updatePixels();
    pg.endDraw();
    super.display();
  }
}


void setup() {
  frameRate(theFrameRate);
  Strips strips = new Strips();

  mp = new Moonpaper(this);

  loadStrips(strips, jsonFile);
  pixelMap = new PixelMap();
  teatro = new Structure(pixelMap, jsonFile);
  flatPanel = new Structure(pixelMap, "flatpanel.json");
  pixelMap.finalize();
  size(pixelMap.columns, pixelMap.rows);

  
  colorNoise = new ColorNoise(pixelMap, teatro, color(255, 0, 128, 180));
  stripSweep = new StripSweep(pixelMap, teatro);

  Cel cel0 = mp.createCel(width, height);

  
  ColorNoise cn = new ColorNoise(pixelMap, teatro, color(255, 0, 128, 180));
  PatchSet ps = new PatchSet(cn.transparency, 0.0);
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PushCel(cel0, cn));
  mp.seq(new Wait(120));
  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, teatro)));
  mp.seq(new Wait(120));
  mp.seq(ps);
  mp.seq(new Line(120, cn.transparency, 255.0));
  mp.seq(new Wait(120));
  mp.seq(new PushCel(cel0, new ColorNoise(pixelMap, flatPanel, color(255))));
  mp.seq(new Wait(120));
  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, flatPanel)));
  mp.seq(new Wait(120));
}

void draw() {
  background(0);
  mp.update();
  mp.display();
}

