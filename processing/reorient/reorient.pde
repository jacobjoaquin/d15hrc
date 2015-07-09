import java.util.*;

color pornjPink = #FC17DA;
color pornjGold = #FFB23F;
color pornjOrange = #FF8800;
color land = #bcac88;

float nx = 0;
float ny = 1000;
float nInc = 0.01;

//float gScale = 0.125;
//float gScale = 0.18;
float gScale = 1;
float sWidth;
float sHeight;
DisorientFont df;
PVector arcCenter;
PVector fontPosition;

float tarpRadius = 520;


float fontWidthRatio = 0.75;
float fontWidth = 4000 * fontWidthRatio;
float nColumns = 80;
float dotSize = fontWidth / nColumns;
float fontHeight = dotSize * 10;


void setup() {
  size(int(4000 * gScale), int(4000 * gScale));
  noLoop();
  sWidth = width * (1 / gScale);
  sHeight = height * (1 / gScale);
  df = new DisorientFont();

  arcCenter = new PVector(0.617 * sWidth, 0.617 * sHeight);
  float offset = (sWidth - fontWidth) / 2.0;
  fontPosition = new PVector(300, 3400);
}

void draw() {
  scale(gScale);
  noFill();
  background(0);
  colorMode(HSB);

  // Arc Layer
  pushMatrix();
  translate(arcCenter.x, arcCenter.y);
  generateArcLayer();
  popMatrix();


  // Playa
  pushStyle();
  pushMatrix();
  translate(arcCenter.x, arcCenter.y);
  noStroke();
  fill(0, 64);
  ellipse(0, 0, 1040, 1040);
  popMatrix();  
  popStyle();


  // Helios
  pushMatrix();
  pushStyle();
  translate(arcCenter.x, arcCenter.y);
  stroke(255);
  strokeWeight(4);
  int nRods = 24;
  for (int i = 0; i < nRods + 1; i++) {
    float n = float(i) / float(nRods);
    PVector a = PVector.fromAngle(n * PI + PI);
    PVector p = PVector.fromAngle(atan2(a.y, a.x));
    p.mult(tarpRadius);
    a.mult(3500);
    heliosLine(p, a, 0.75, 10);
  }  
  popStyle();
  popMatrix();



  // Draw Tarps
  pushMatrix();
  translate(arcCenter.x, arcCenter.y); 
  int nTarps = 48;
  for (int i = 0; i < nTarps; i++) {
    float n = float(i) / float(nTarps);
    PVector a = PVector.fromAngle(n * TWO_PI);
    a.mult(tarpRadius);
    pushMatrix();
    translate(a.x, a.y);
    rotate(n * TWO_PI);
    tarpFigure(50);
    popMatrix();
  }
  popMatrix();



  // Lines
  println("begin Lines");
  ArrayList<PVector> lineStarts = getLinePoints("reor15nt", dotSize); 
  stroke(255, 180);
  strokeWeight(4);
  for (PVector p : lineStarts) {
    heliosLine(new PVector(p.x + fontPosition.x, p.y + fontPosition.y), arcCenter, 0.75, 50);
  }

  // Draw letters
  drawLetters();

  save("temp.tiff");
}

void heliosLine(PVector p1, PVector p2, float r, float L) {
  float d = dist(p1.x, p1.y, p2.x, p2.y);
  PVector a = PVector.fromAngle(atan2(p2.y - p1.y, p2.x - p1.x));

  float pos = 0;
  float end = d;
  while (pos < end - L) {
    if (random(1) > r) {
      PVector pt1 = a.get();
      pt1.mult(pos); 
      pt1.add(p1);
      PVector pt2 = a.get();
      pt2.mult(pos + L);
      pt2.add(p1);
      line(pt1.x, pt1.y, pt2.x, pt2.y);
    } 
    pos += L;
  }
}

void tarpFigure(float s) {
  float h = s / 2.0;

  pushStyle();
  fill(0);
  stroke(pornjGold);
  strokeWeight(1.5);
  beginShape();
  vertex(h, h);
  vertex(h, -h);
  vertex(-h, -h);
  vertex(-h, h);  
  endShape(CLOSE);
  //  stroke(pornjOrange);
  //  line(0, -h, 0, h);
  //  line(-h, 0, h, 0);
  popStyle();
}
