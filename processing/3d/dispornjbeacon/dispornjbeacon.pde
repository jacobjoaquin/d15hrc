import moonpaper.*;
import moonpaper.opcodes.*;

float lightSize = 3;  // Size of LEDs
float meter = 100;    // 1 pixel = 1cm

PixelMap pixelMap;
ArrayList<Strip> strips;
Moonpaper mp;

class RandomValue extends MoonCodeEvent {
  Patchable<Integer> pf;
  float low;
  float high;
  
  RandomValue(Patchable<Integer> pf, float low, float high) {
    this.pf = pf;
    this.low = low;
    this.high = high;
  }
  
  void exec() {
    pf.set(color(random(low, high)));
  }
}

void setup() {
  frameRate(30);
  
  // Setup Virtual Installation  
  pixelMap = new PixelMap();
  strips = new ArrayList<Strip>();
  createTeatro();
  pixelMap.add(strips);
  size(pixelMap.pg.width, pixelMap.pg.height);

  // Create Sequence
  mp = new Moonpaper(this);
  Cel cel = mp.createCel();
  CrossNoise cn = new CrossNoise(pixelMap);

  mp.seq(new ClearCels());  
  mp.seq(new PushCel(cel, cn));  
  mp.seq(new Wait(10));
  mp.seq(new RandomValue(cn.foo, 0, 255));
}

void draw() {
  mp.update();
  mp.display();
}
