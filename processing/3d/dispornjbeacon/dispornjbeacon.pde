import moonpaper.*;
import moonpaper.opcodes.*;

float lightSize = 3;    // Size of LEDs
float meter = 100;      // 1 pixel = 1cm
float eyeHeight = 170;

PixelMap pixelMap;
ArrayList<Strip> strips;
PVector theCamera = new PVector(0, eyeHeight, 0);
ArrayList<Animation> animations;
ArrayList<ScanLine> scanlines;

Moonpaper mp;

void setup() {
  // Setup Virtual Installation  
  pixelMap = new PixelMap();
  strips = new ArrayList<Strip>();
  animations = new ArrayList<Animation>();
  scanlines = new ArrayList<ScanLine>();
  createTeatro();

//  for (Strip strip : strips) {
//    //    animations.add(new Animation(strip));
//    scanlines.add(new ScanLine(strip));
//  }

  pixelMap.add(strips);
  size(pixelMap.pg.width, pixelMap.pg.height);

  // Create Sequence
  mp = new Moonpaper(this);
  Cel cel = mp.createCel();

  mp.seq(new ClearCels());
  mp.seq(new PushCel(cel, new CrossNoise(pixelMap)));  
  
  //  mp.seq(new PushCel(cel, scanlines.get(0)));  
  //  mp.seq(new PushCel(cel, strips.get(0)));  
//  mp.seq(new PushCel(cel, pixelMap));  
  mp.seq(new Wait(30));
}

void draw() {
  for (Strip strip : strips) {
    for (LED led : strip.lights) {
      led.c = color(random(255));
    }
  }
  mp.update();
  mp.display();
}
