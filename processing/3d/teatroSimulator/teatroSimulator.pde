import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

float lightSize = 3;  // Size of LEDs
float eyeHeight = 170;
String jsonFile = "./data/test.json";  // JSON file containing LED structure data

ArrayList<Strip> strips;
PVector theCamera = new PVector(0, eyeHeight, 0);
PixelMap pixelMap;
String ip = "localhost";
int port = 6100;

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
  broadcastReceiver = new BroadcastReceiver(this, pixelMap, ip, port);
}

void pixelMapToStrips(PixelMap pixelMap, ArrayList<Strip> strips) {
  int rows = strips.size();
  PGraphics pg = pixelMap.pg;
  pg.loadPixels();
  
  for (int row = 0; row < rows; row++) {
    Strip strip = strips.get(row);
    ArrayList<LED> lights = strip.lights;
    int cols = strip.nLights;
    int rowOffset = row * pixelMap.columns;
    
    for (int col = 0; col < cols; col++) {
      LED led = lights.get(col);
      led.c = pg.pixels[rowOffset + col];
    }
  } 
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
  
  pushStyle();
  noStroke();
  pixelMapToStrips(pixelMap, strips);
  
  for (Strip strip : strips) {
    for (LED led : strip.lights) {
      pushMatrix();
      PVector p = led.position;
      fill(led.c);
      translate(p.x, p.y, p.z);
      box(lightSize);
      popMatrix();
    }
  }
  popStyle();

  popMatrix();
}
