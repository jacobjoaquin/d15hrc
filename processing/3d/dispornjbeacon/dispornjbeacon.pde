import moonpaper.*;
import moonpaper.opcodes.*;

float lightSize = 3;  // Size of LEDs
float meter = 100;    // 1 pixel = 1cm
String jsonFile = "test.json";

PixelMap pixelMap;
ArrayList<Strip> strips;
Moonpaper mp;

void setup() {
  // Setup Virtual Installation  
  pixelMap = new PixelMap();
  strips = new ArrayList<Strip>();
  loadStrips(strips, jsonFile);
  pixelMap.add(strips);
  size(pixelMap.columns, pixelMap.rows);

  // Create Sequence
  mp = new Moonpaper(this);
  Cel cel = mp.createCel();
  CrossNoise cn = new CrossNoise(pixelMap);

  mp.seq(new ClearCels());  
  mp.seq(new PushCel(cel, cn));  
  mp.seq(new Wait(30));
  mp.seq(new Line(30, cn.theColor, 255));
  mp.seq(new Wait(30));
  mp.seq(new Line(30, cn.theColor, 0));
  
}

void draw() {
  mp.update();
  mp.display();
}

