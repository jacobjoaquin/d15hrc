int nFrames = 12;

float phase = 0.0;
float phaseInc = 1 / float(nFrames);
Test test;


class Test extends Phenamation {
  void draw(float phase) {
    float s = map(sin(phase * TWO_PI), -1, 1, 10, 50);
    ellipse(0, 0, s, s);
  }
}

class Wheel {
  float radius;
  float nFrames;
  
  Wheel(int nFrames, float radius) {
    this.nFrames = nFrames;
    this.radius = radius;
  }
  
  void drawPhrena(Phrenamation phenamation, int phenaFrames, float position, float scalePhrena) {
    
  }  
}

void setup() {
  frameRate(10);
  test = new Test();
}

void draw() {
  background(255);
  pushMatrix();
  translate(width / 2.0, height / 2.0);
  test.draw(phase);
  popMatrix();
  
  phase += phaseInc;
  if (phase >= 1.0) {
    phase -= 1.0;
  }
}
