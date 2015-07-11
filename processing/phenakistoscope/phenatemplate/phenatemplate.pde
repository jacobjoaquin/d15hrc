int nFrames = 12;
boolean captureFrames = false;

color cut = color(255, 0, 0);
color etch = color(0, 0, 255);

float phase = 0.0;
float phaseInc = 1 / float(nFrames);
Test test;
Wheel wheel;

class Test extends Phenamation {
  void draw(float phase) {
    float s = map(sin(phase * TWO_PI), -1, 1, 10, 50);
    ellipse(0, 0, s, s);
  }
}

class Wheel {
  float radius;
  int nFrames;
  
  Wheel(int nFrames, float radius) {
    this.nFrames = nFrames;
    this.radius = radius;
  }
  
  void createFrames(Phenamation phenamation, int phenaFrames, float aniOffset, float position, float scalePhrena) {
    pushMatrix();
    rotate(frameCount % nFrames / float(nFrames) * TWO_PI);
    
    for (int i = 0; i < phenaFrames; i++) {
      float offset = i / float(phenaFrames);
      float angle = offset * TWO_PI;
      
      pushMatrix();
      rotate(angle);
      translate(radius * position, 0);
      scale(scalePhrena);
      phenamation.draw(offset + aniOffset * TWO_PI);
      popMatrix();
      
    }
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
  size(500, 500);
  noFill();
  frameRate(nFrames);
//  frameRate(1);
  test = new Test();
  wheel = new Wheel(nFrames, width / 2.0);
}

void draw() {
  background(255);
  pushMatrix();
  translate(width / 2.0, height / 2.0);

  pushStyle();
  stroke(etch);

  createCuts();

  int nThings = 5;
  for (int i = 0; i < nThings; i++) {
    float ratio = i / float(nThings);    
    wheel.createFrames(test, i + 10, 0, lerp(0.1, 0.9, ratio) + 0.1, 0.5);
  }
  popStyle();
  popMatrix();
  
  phase += phaseInc;
  if (phase >= 1.0) {
    phase -= 1.0;
  }
  
  if (captureFrames) {  
    saveFrame("./gif/frame_####.gif");
    if (frameCount >= nFrames) {
      exit();
    }
  }
}
