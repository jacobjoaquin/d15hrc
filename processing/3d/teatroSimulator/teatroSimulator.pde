import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

float lightSize = 3;  // Size of LEDs
float meter = 100;    // 1 pixel = 1cm
float eyeHeight = 170;
String jsonFile = "./data/test.json";

ArrayList<Strip> strips;
PVector theCamera = new PVector(0, eyeHeight, 0);
PixelMap pixelMap;

UDP udp;
int listenPort = 6100;
int nPixels;


void receive(byte[] data, String ip, int port) {
  PGraphics pg = pixelMap.pg;
  pg.loadPixels();

  for (int i = 0; i < nPixels; i++) {
    int offset = i * 3;  
    pg.pixels[i] = 0xFF000000 |
      ((data[offset] & 0xFF) << 16) |
      ((data[offset + 1] & 0xFF) << 8) |
      (data[offset + 2] & 0xFF);
  }

  pg.updatePixels();
}

void drawPlane() {
  float corner = 10000;
  pushStyle();
  fill(64);  
  beginShape();
  vertex(corner, 0, corner);
  vertex(corner, 0, -corner);
  vertex(-corner, 0, -corner);
  vertex(-corner, 0, corner);
  endShape(CLOSE);
  popStyle();
}

void setup() {
  size(640, 480, P3D);

  // Setup Virtual Installation  
  strips = new ArrayList<Strip>();

  loadStrips(strips, jsonFile);
  pixelMap = new PixelMap(strips);
  
  nPixels = width * height;
  udp = new UDP(this, listenPort);
  udp.listen( true );
}

void draw() {
  background(16);
  pushMatrix();

  // Reorient Plane
  rotateX(PI);
  translate(width / 2.0, -500);

  // Set Camera
  theCamera.x = map(mouseX, 0, width, -width * 5, width * 5);
  theCamera.z = map(mouseY, 0, height, 500, -3700);
  camera(
  theCamera.x, theCamera.y, theCamera.z, 
  0.0, eyeHeight, 500.0, 
  0.0, -1.0, 0.0);

  // Draw landscape and structure  
  drawPlane();
  for (Strip strip : strips) {
    for (LED led : strip.lights) {
      pushMatrix();
      PVector p = led.position;
      translate(p.x, p.y, p.z);
      box(lightSize);
      popMatrix();
    }
  }

  popMatrix();
}
