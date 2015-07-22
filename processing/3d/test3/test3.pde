float lightSize = 2;    // Size of LEDs
float meter = 100;      // 1 pixel = 1cm
float eyeHeight = 170;

PixelMap pixelMap;
ArrayList<Strip> strips;
PVector theCamera = new PVector(0, eyeHeight, 0);
ArrayList<Animation> animations;
ArrayList<ScanLine> scanlines;

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

void setup() {
  size(640, 480, P3D);
  colorMode(HSB);

  pixelMap = new PixelMap();
  strips = new ArrayList<Strip>();
  animations = new ArrayList<Animation>();
  scanlines = new ArrayList<ScanLine>();
  createTeatro();
  
  for (Strip strip : strips) {
//    animations.add(new Animation(strip));
    scanlines.add(new ScanLine(strip));
  }


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
  theCamera.x = map(mouseX, 0, width, -width * 2, width * 2);
  theCamera.z = map(mouseY, 0, height, 500, -1000);
  camera(
  theCamera.x, theCamera.y, theCamera.z, 
  0.0, eyeHeight, 500.0, 
  0.0, -1.0, 0.0);

  drawPlane();

//  for (Animation a : animations) {
//    a.update();
//  }

  for (ScanLine sl : scanlines) {
    sl.update();
  }

  for (Strip s : strips) {
    s.display();
  }

  popMatrix();

  pixelMap.update();
  pixelMap.display();
}

