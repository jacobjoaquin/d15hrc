import processing.pdf.*;

int nFrames = 15;
boolean capturePDF = false;
boolean captureFrames = false;

color cut = color(255, 0, 0);
color etch = color(0, 0, 255);

float phase = 0.0;
float phaseInc = 1 / float(nFrames);
Test test;
PlayaAngela pa;
Wheel wheel;

class Test extends Phenamation {
  void draw(float phase) {
    float s = 50;
    ellipse(0, 0, s, s);
  }
}

class PlayaAngela extends Phenamation {
  void draw(float phase) {
    float s = 10;
    float w = map(sin(phase * TWO_PI), -1, 1, 0.5, 1.5) * s;
    float h = 1 / 2.6 * s;
    float two_div_sqrt3 = 2 / sqrt(3);

    pushMatrix();
    rotate(2 * PI / 6.0 * phase);
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
    popMatrix();
  }
}

void createCuts() {
  pushStyle();
  stroke(cut);
  ellipse(0, 0, width, height);
  ellipse(0, 0, 5, 5);
  popStyle();
}

void setup() {
  if (capturePDF) {
    size(500, 500, PDF, "phenaDisco.pdf");
  } else {
    size(500, 500);
  }
  frameRate(nFrames);
  //  frameRate(1);
  noFill();
  test = new Test();
  pa = new PlayaAngela();
  wheel = new Wheel(nFrames);
}

void draw() {
  background(255);
  pushMatrix();
  translate(width / 2.0, height / 2.0);
  pushStyle();

  // Create cuts
  createCuts();

  // Create phenakistoscope 
  stroke(etch);
  //  int nThings = 5;
  //  for (int i = 0; i < nThings; i++) {
  //    float ratio = i / float(nThings);    
  //    wheel.createFrames(test, i + 10, 0, lerp(0.1, 0.9, ratio) + 0.1, 0.5);
  //  }

  wheel.createFrames(pa, nFrames, 0, 0.8, 0.5);
  wheel.createFrames(pa, nFrames - 1, TWO_PI, 0.38, 0.20);
  wheel.createFrames(pa, nFrames + 1, PI, 0.55, 0.25);
  popStyle();
  popMatrix();

  // Update phasor
  phase += phaseInc;
  if (phase >= 1.0) {
    phase -= 1.0;
  }

  if (capturePDF) {
    exit();
  }

  // Capture frames for animated gif
  if (captureFrames) {  
    saveFrame("./gif/frame_####.gif");
    if (frameCount >= nFrames) {
      exit();
    }
  }
}

