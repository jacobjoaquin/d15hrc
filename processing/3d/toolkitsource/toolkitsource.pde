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
    pg.clear();
    //    pg.rect(0, 0, pg.width, pg.height);
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

class ScanLine extends DisplayableLEDs {
  Patchable<Float> bandwidth = new Patchable<Float>(50.0);
  Patchable<Float> speed = new Patchable<Float>(1.0);
  Patchable<Integer> color1 = new Patchable<Integer>(color(255));
  Patchable<Integer> color2 = new Patchable<Integer>(color(255, 0));
  float counter = -bandwidth.value() / 2.0;

  ScanLine(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    setup();
  }

  void update() {
    float bDiv2 = bandwidth.value() / 2.0;
    color c1 = color1.value();
    color c2 = color2.value();
    for (LED led : leds) {
      float y = led.position.y;
      if (y >= counter - bDiv2 && y <= counter + bDiv2) {
        float d = abs(y - counter);
        led.c = lerpColor(c1, c2, d / bDiv2);
      } else {
        led.c = color(0, 0);
      }
    }

    counter += speed.value();
    if (counter > inchesToCM(21 * 12) + bDiv2) {
      counter = -bDiv2;
    }
    else if (counter <= - bDiv2) {
      counter = inchesToCM(21 * 12);
    }

    super.update();
  }
}


class GradientStrips extends DisplayableStrips {
  GradientStrips(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }
  
  void display() {
    pg.beginDraw();
    pg.clear();
    pg.loadPixels();
    for (int row = 0; row < pg.height; row++) {
      //      StripAnimation animation = animations.get(row);
      Strip strip = strips.get(row);
      for (int col = 0; col < strip.nLights; col++) {
        pg.pixels[row * pg.width + col] = lerpColor(color(255, 0, 0), color(0, 0, 255), col / float(strip.nLights));
      }
    }

    pg.updatePixels();
    pg.endDraw();
    super.display();
  }
}

class GradientLEDs extends DisplayableLEDs {
  GradientLEDs(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }
  
  void update() {  
    for (int i = 0; i < leds.size(); i++) {
      LED led = leds.get(i);
      led.c = lerpColor(color(255, 0, 0), color(0, 0, 255), i / float(leds.size())); 
    }
    super.update();
  }
}



void setup() {
  size(135, 108, P2D);
  frameRate(theFrameRate);

  Strips strips = new Strips();
  PGraphics loadTransformation = createGraphics(1, 1, P3D);

  mp = new Moonpaper(this);
  loadStrips(strips, jsonFile);
  pixelMap = new PixelMap();
  teatro = new Structure(pixelMap, "../teatro.json");
  //  loadTransformation.pushMatrix();
  //  loadTransformation.scale(1, -1, 1);
  //  asterix = new Structure(pixelMap, "../asterix.json", loadTransformation);
  asterix = new Structure(pixelMap, "../asterix.json");
  for (Strip strip : asterix.strips) {
    for (LED led : strip.leds) {
      led.position.y *= -1;
    }
  }
  //  loadTransformation.popMatrix();
  pixelMap.finalize();

  // Do animations
  Cel cel0 = mp.createCel(width, height);

  ColorNoise cn = new ColorNoise(pixelMap, teatro, color(255, 0, 128, 180));
  PatchSet ps = new PatchSet(cn.transparency, 0.0);
  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel0, pixelMap));
//  mp.seq(new PushCel(cel0, new GradientStrips(pixelMap, asterix)));
//  mp.seq(new PushCel(cel0, new GradientLEDs(pixelMap, asterix)));
//  mp.seq(new Wait(120));
  mp.seq(new PushCel(cel0, cn));
  
  
  
  ScanLine a1 = new ScanLine(pixelMap, asterix);
  ScanLine a2 = new ScanLine(pixelMap, asterix);
  ScanLine t1 = new ScanLine(pixelMap, teatro);
  ScanLine t2 = new ScanLine(pixelMap, teatro);

  mp.seq(new PushCel(cel0, a1));
  mp.seq(new PushCel(cel0, t1));
  mp.seq(new PushCel(cel0, a2));
  mp.seq(new PushCel(cel0, t2));
  mp.seq(new PatchSet(a1.speed, 1.0));
  mp.seq(new PatchSet(t1.speed, 1.0));
  mp.seq(new PatchSet(a2.speed, -4.0));
  mp.seq(new PatchSet(t2.speed, -4.0));
  mp.seq(new PatchSet(a1.color1, color(255, 128, 0)));
  mp.seq(new PatchSet(a1.color2, color(255, 128, 0, 0)));
  mp.seq(new PatchSet(t1.color1, color(255, 128, 0)));
  mp.seq(new PatchSet(t1.color2, color(255, 128, 0, 0)));
  mp.seq(new PatchSet(a2.color1, color(255, 80, 180)));
  mp.seq(new PatchSet(a2.color2, color(255, 80, 180, 0)));
  mp.seq(new PatchSet(t2.color1, color(255, 80, 180)));
  mp.seq(new PatchSet(t2.color2, color(255, 80, 180, 0)));

    
  mp.seq(new Wait(120));
  
  mp.seq(new Line(120, a1.speed, 10));
  mp.seq(new Line(120, t1.speed, 10));
  mp.seq(new Line(120, a1.bandwidth, 400));
  mp.seq(new Line(120, t1.bandwidth, 400));
  
  mp.seq(new Wait(240));

  mp.seq(new Line(120, a1.speed, 1));
  mp.seq(new Line(120, t1.speed, 1));
  mp.seq(new Line(120, a1.bandwidth, 50));
  mp.seq(new Line(120, t1.bandwidth, 50));

  mp.seq(new Wait(240));

  
  mp.seq(new PatchSet(a1.speed, 1.0));
  mp.seq(new PatchSet(t1.speed, 1.0));
  mp.seq(new PatchSet(a1.bandwidth, 50.0));
  mp.seq(new PatchSet(t1.bandwidth, 50.0));

  
  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, teatro)));
  mp.seq(new Wait(120));
  mp.seq(ps);
  mp.seq(new Line(120, cn.transparency, 255.0));
  mp.seq(new Wait(120));
//  mp.seq(new PushCel(cel0, new ColorNoise(pixelMap, asterix, color(255))));
//  mp.seq(new Wait(120));
//  mp.seq(new PushCel(cel0, new StripSweep(pixelMap, asterix)));
//  mp.seq(new Wait(120));

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

