
int nLEDsPerMeter = 30;
float meter = 100;

ArrayList<Strip> strips;

void setup() {
  size(500, 500, P3D);
  colorMode(HSB);
  strips = new ArrayList<Strip>();
  
  Strip s = new Strip(new PVector(0, 0, -300), new PVector(500, 0, -300));
  strips.add(s);
}

void draw() {
  background(16);
  pushMatrix();
  // Reorient Plane
  rotateX(PI);
  translate(250, -500);

  float corner = 10000;
  pushMatrix();
  fill(#bbac88);  
  beginShape();
  vertex(corner, 0, corner);
  vertex(corner, 0, -corner);
  vertex(-corner, 0, -corner);
  vertex(-corner, 0, corner);
  endShape(CLOSE);
  popMatrix();
  
  pushMatrix();


  pushMatrix();
  translate(50, 0, 500);
  int nBoxes = 150;
  for (int i = 0; i < nBoxes; i++) {
    pushMatrix();
    pushStyle();
    noStroke();
    translate(0, i / float(nBoxes) * 500, 0);
    fill(random(255), 255, 255);
    box(100 / 30.0);
    popStyle();
    popMatrix();  
  }
  popMatrix();

  for (Strip s : strips) {
    s.display();
  }

  popMatrix();
  popMatrix();  
}

