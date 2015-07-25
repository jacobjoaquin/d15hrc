import moonpaper.*;

float lightSize = 3;    // Size of LEDs
float meter = 100;      // 1 pixel = 1cm
float eyeHeight = 170;
StackPGraphics spg;


PixelMap pixelMap;
ArrayList<Strip> strips;
PVector theCamera = new PVector(0, eyeHeight, 0);
ArrayList<Animation> animations;
ArrayList<ScanLine> scanlines;
int theLength = 60;
int nTiles = 7;
int nPixels;

void drawPlane() {
  float corner = 10000;
  //  fill(#bbac88);  
  fill(64);  
  beginShape();
  vertex(corner, 0, corner);
  vertex(corner, 0, -corner);
  vertex(-corner, 0, -corner);
  vertex(-corner, 0, corner);
  endShape(CLOSE);
}

void setup() {

  nPixels = nTiles * theLength;
  //  size(nPixels, nPixels);
  size(500, 500);

  colorMode(HSB);
  spg = new StackPGraphics(this);

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
  background(0);
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

  PGraphics pg = createGraphics(nPixels, nPixels);
  pg.copy(g, 0, 0, theLength, theLength, 0, 0, theLength, theLength);
  //  copy(pg, 0, 0, theLength, theLength, 0, 0, theLength, theLength);
  background(0);
  translate((500 - nPixels) / 2.0, (500 - nPixels) / 2.0);

  for (int y = 0; y < nTiles; y++) { 
    for (int x = 0; x < nTiles; x++) {
      PVector pos = new PVector(x * theLength, y * theLength);
      //      pg.copy(g, 0, 0, theLength, theLength, 0, 0, theLength, theLength);
      copy(pg, 0, 0, theLength, theLength, int(pos.x), int(pos.y), theLength, theLength);
      //  copy(pg, 0, 0, theLength, theLength, 0, 0, theLength, theLength);
    }
  }

  saveFrame("./gif/frame####.gif");
  if (frameCount >= 125) {
    exit();
  }
}

