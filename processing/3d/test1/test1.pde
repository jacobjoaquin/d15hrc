
float lightSize = 2;
int nLEDsPerMeter = 30;
float meter = 100;

ArrayList<Strip> strips;

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
  size(500, 500, P3D);
  colorMode(HSB);
  strips = new ArrayList<Strip>();
  
  Strip s = new Strip(new PVector(-50, 0, 50), new PVector(0, 500, 50));
  strips.add(s);
}

void draw() {
  background(16);
  pushMatrix();
  
  // Reorient Plane
  rotateX(PI);
  translate(width / 2.0, -500);

  drawPlane();
    
  for (Strip s : strips) {
    s.display();
  }

  popMatrix();  
}

