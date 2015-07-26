import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

float meter = 100;    // 1 pixel = 1cm
String jsonFile = "test.json";

PixelMap pixelMap;
ArrayList<Strip> strips;
Moonpaper mp;

// Broadcast
Broadcast broadcast;
int port = 6100;
String ip = "localhost"; 


void setup() {
  // Setup Virtual Installation  
  strips = new ArrayList<Strip>();
  loadStrips(strips, jsonFile);
  pixelMap = new PixelMap(strips);
  size(pixelMap.columns, pixelMap.rows);
  // Broadcast
  broadcast = new Broadcast(this, pixelMap, ip, port);

  // Create Sequence
  mp = new Moonpaper(this);
  Cel cel = mp.createCel();
  CrossNoise cn = new CrossNoise(pixelMap);

  mp.seq(new ClearCels());  
  mp.seq(new PushCel(cel, cn));  
  mp.seq(new Line(30, cn.theColor, 255));
  mp.seq(new Wait(30));
  mp.seq(new Line(30, cn.theColor, 0));  
  mp.seq(new Wait(30));
}

void draw() {
  mp.update();
  mp.display();
  broadcast.send();
}

