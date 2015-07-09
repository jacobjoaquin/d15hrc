import java.util.*;

color pornjPink = #FC17DA;
color pornjOrange = #FFB23F;
color land = #bcac88;

float nx = 0;
float ny = 1000;
float nInc = 0.01;

//float gScale = 0.125;
float gScale = 0.5;
//float gScale = 1;
float sWidth;
float sHeight;
DisorientFont df;
PVector arcCenter;
PVector lettersStart;

void setup() {
  size(int(4000 * gScale), int(4000 * gScale));
  noLoop();
  sWidth = width * (1 / gScale);
  sHeight = height * (1 / gScale);
  df = new DisorientFont();
  arcCenter = new PVector(sWidth / 2.0, sHeight / 2.0);
  lettersStart = new PVector(200, 3600);
}

void draw() {
  scale(gScale);
  noFill();
  background(land);
//  background(0);
  colorMode(HSB);



  // Playa
  pushStyle();
  pushMatrix();
  translate(arcCenter.x, arcCenter.y);
  noStroke();
  fill(land);
  ellipse(0, 0, 1040, 1040);
  popMatrix();  
  popStyle();

  // Draw Tarps
  pushMatrix();
  translate(arcCenter.x, arcCenter.y); 
  int nTarps = 48;
  for (int i = 0; i < nTarps; i++) {
    float n = float(i) / float(nTarps);
    PVector a = PVector.fromAngle(n * TWO_PI);
    a.mult(1500);
    pushMatrix();
    translate(a.x, a.y);
    rotate(n * TWO_PI);
    tarpFigure(160);
    popMatrix();
  }
  popMatrix();




  // Draw letters
//  drawLetters();


  
  save("temp.tiff");
}

void tarpFigure(float s) {
  float h = s / 2.0;
  
  pushStyle();
  fill(color(#d1571a, 255));
  stroke(0);
//  fill(0);
//  stroke(pornjPink);
  strokeWeight(4);
  beginShape();
  vertex(h, h);
  vertex(h, -h);
  vertex(-h, -h);
  vertex(-h, h);  
  endShape(CLOSE);
  line(0, -h, 0, h);
  line(-h, 0, h, 0);
  popStyle();
}
