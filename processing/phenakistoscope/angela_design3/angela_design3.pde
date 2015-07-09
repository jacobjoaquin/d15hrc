int nFrames = 40;
boolean captureFrames = false;

float phase = 0.0;
float phaseInc = 1 / float(nFrames);

void setup() {
  size(500, 500);
  frameRate(10);
}

void draw() {
  float h = 1 / 2.6;
  float offset = 1 / float(nFrames);
  background(255);
  stroke(#ff8800);
  strokeWeight(1);  
  noFill();
  
//  noLoop();
  
  pushMatrix();
  translate(width / 2, height / 2);
  ellipse(0, 0, 500, 500);
  ellipse(0, 0, 5, 5);
  for (int i = 0; i < nFrames; i++) {
    pushMatrix();
//    rotate((phase + offset * i) * PI / 3.0);
    float w = map(sin((phase + offset * i) * TWO_PI), -1, 1, 0.6, 1.25);
    pushMatrix();
    rotate(i * offset * TWO_PI); 
//    rotate(0.25);
    translate(190, 0);
    drawGeo(70, w, h, phase);
    popMatrix();
    popMatrix();
  }

  popMatrix();

  phase += phaseInc;
  if (phase >= 1.0); 
  {
    phase -= 1.0;
  }

  if (captureFrames) {  
    saveFrame("./gif/frame_####.gif");
    if (frameCount >= nFrames) {
      exit();
    }
  }
}

void drawGeo(float s, float w, float h, float phase) {
  float two_div_sqrt3 = 2 / sqrt(3);
  
  pushStyle();
  rectMode(CENTER);

  for (int i = 0; i < 3; i++) {
    float n = i / 3.0;
    pushMatrix();
    rotate(PI * n);
    

    // Rectangles
    rect(0, 0, w * s, h * s);

    // Inner Lines
    float a = h / 2.0 * s;
    PVector p = PVector.fromAngle(PI / 3.0);
    p.mult(two_div_sqrt3 * a);
    line(-p.x, -p.y, p.x, p.y);

    // Outer lines
    p = PVector.fromAngle(0);
    p.mult(two_div_sqrt3 * a);
    for (int j = 0; j < 2; j++) {
      pushMatrix();
      rotate(j * PI);
      line(w * s * 0.5, h * s * 0.5, p.x, p.y);
      line(w * s * 0.5, -h * s * 0.5, p.x, p.y);
      popMatrix();
    }

    popMatrix();
  }

  popStyle();
}

