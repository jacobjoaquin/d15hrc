import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

String jsonFile = "test.json";

Moonpaper mp;
PixelMap pixelMap;
Structure teatro;
Structure asterix;

ColorNoise colorNoise;
StripSweep stripSweep;

int theFrameRate = 60;

// Broadcast
Broadcast broadcast;
String ip = "localhost"; 
int port = 6100;

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

class ScanLine extends DisplayableStrips {
  ArrayList<LEDs> ledMatrix;
  int theLength;
  float theMin;
  float theMax;
  float bandwidth = 20;
  float counter = bandwidth;

  ScanLine(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    setup();
  }

  // Create 2D map of LEDs

  void setup() {
    super.setup();

    // Create LED Matrix that has a 1 to 1 ordered relationship to
    // the LEDs in the strip
    ledMatrix = new ArrayList<LEDs>();
    for (Strip strip : strips) {
      LEDs leds = new LEDs();

      for (LED led : strip.leds) {
        LED thisLed = new LED();
        thisLed.position = led.position.get();
        leds.add(thisLed);
      }

      ledMatrix.add(leds);
    }
  }

  void update() {
    pg.beginDraw();
    pg.clear();
    pg.loadPixels();

    for (int row = 0; row < ledMatrix.size (); row++) {
      LEDs leds = ledMatrix.get(row);

      for (int col = 0; col < leds.size (); col++) {
        LED led = leds.get(col);
        float y = led.position.y;
        if (y >= counter && y <= counter + 20) {
          led.c = color(255);
        } else {
          led.c = color(0, 0, 0, 0);
        }
        pg.pixels[row * strips.getMaxStripLength() + col] = led.c;
      }
    }
    pg.updatePixels();
    pg.endDraw();

    counter += 5;
    if (counter > inchesToCM(21 * 12) + bandwidth) {
      counter = -bandwidth;
    }
  }

  void display() {
    pg.beginDraw();
    for (Strip strip : strips) {
      for (int i = 0; i < strip.nLights; i++) {
      }
    }

    pg.endDraw();
    super.display();
  }
}


void setup() {
  size(135, 108, P2D);
//  int waitTime = millis() + 1000;
//  while (millis() < waitTime) {
//  }
  
  frameRate(theFrameRate);
  Strips strips = new Strips();

  mp = new Moonpaper(this);

  loadStrips(strips, jsonFile);
  pixelMap = new PixelMap();
  PGraphics loadTransformation = createGraphics(1, 1, P3D);

  teatro = new Structure(pixelMap, "../teatro.json");
  loadTransformation.pushMatrix();
  loadTransformation.scale(1, -1, 1);
  asterix = new Structure(pixelMap, "../asterix.json", loadTransformation);
  loadTransformation.popMatrix();
  pixelMap.finalize();


  // Do animations
  Cel cel0 = mp.createCel(width, height);

  ColorNoise cn = new ColorNoise(pixelMap, teatro, color(255, 0, 128, 180));
  PatchSet ps = new PatchSet(cn.transparency, 0.0);
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
  mp.seq(new PushCel(cel0, cn));
  mp.seq(new PushCel(cel0, new ScanLine(pixelMap, asterix)));
  //  mp.seq(new PushCel(cel0, new ScanLine(pixelMap, asterix)));
  //  mp.seq(new PushCel(cel0, new DisplayableStructure(pixelMap, asterix)));
  mp.seq(new Wait(240));
  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, teatro)));
  mp.seq(new Wait(120));
  mp.seq(ps);
  mp.seq(new Line(120, cn.transparency, 255.0));
  mp.seq(new Wait(120));
  mp.seq(new PushCel(cel0, new ColorNoise(pixelMap, asterix, color(255))));
  mp.seq(new Wait(120));
  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, asterix)));
  mp.seq(new Wait(120));

  // Setup Broadcasting
  broadcast = new Broadcast(this, pixelMap, ip, port);  // Set up broadcast
  broadcast.pg = g;                                     // Broadcast global canvas instead of PixelMap
}

void draw() {
  background(0);
  mp.update();
  mp.display();

  // Broadcast to simulator
  broadcast.update();  
}
