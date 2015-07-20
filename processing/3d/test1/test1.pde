//import moonpaper.*;

float lightSize = 2;
int nLEDsPerMeter = 30;
float meter = 100;

PixelMap pixelMap;
ArrayList<Strip> strips;
PVector theCamera = new PVector(0, 200, 0);
//StackPGraphics spg;

ArrayList<Animation> animations;

void drawPlane() {
  float corner = 10000;
  fill(#bbac88);  
  beginShape();
  vertex(corner, 0, corner);
  vertex(corner, 0, -corner);
  vertex(-corner, 0, -corner);
  vertex(-corner, 0, corner);
  endShape(CLOSE);
}

void createHelios() {
  float innerRadius = 32;
  int nStrips = 25;
  PVector origin = new PVector(0, 500, 500);

  for (int i = 0; i < nStrips; i++) {
    PVector angle = PVector.fromAngle(i / float(nStrips - 1) * PI);
    PVector p1 = angle.get();
    PVector p2 = angle.get();

    p1.mult(innerRadius);
    p1.add(origin);
    p2.mult(innerRadius + 400);
    p2.add(origin);
    Strip s = new Strip(p1, p2);
    strips.add(s);
    Animation a = new Animation(s);
    animations.add(a);
  }
}

void setup() {
  size(500, 500, P3D);
  colorMode(HSB);
  
//  spg = new StackPGraphics(this);
  pixelMap = new PixelMap();
  strips = new ArrayList<Strip>();
  animations = new ArrayList<Animation>();  
  createHelios();
  pixelMap.add(strips);
  pixelMap.finalize();
}

void draw() {
  background(16);

  pushMatrix();

  // Reorient Plane
  rotateX(PI);
  translate(width / 2.0, -500);

  // Set Camera
  theCamera.x = map(mouseX, 0, height, -width, width);
  theCamera.z = map(mouseY, 0, height, 0, -1000);
  camera(
  theCamera.x, theCamera.y, theCamera.z, 
  0.0, 500.0, 500.0, 
  0.0, -1.0, 0.0);

  drawPlane();

  for (Animation a : animations) {
    a.update();
  }

  for (Strip s : strips) {
    s.display();
  }

  popMatrix();

  pixelMap.update();
  pixelMap.display();
}

