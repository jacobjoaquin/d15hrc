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
    float s = 50;
    ellipse(0, 0, s, s);
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
  frameRate(nFrames);
//  frameRate(1);
  noFill();
  test = new Test();
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
  int nThings = 5;
  for (int i = 0; i < nThings; i++) {
    float ratio = i / float(nThings);    
    wheel.createFrames(test, i + 10, 0, lerp(0.1, 0.9, ratio) + 0.1, 0.5);
  }

  popStyle();
  popMatrix();

  // Update phasor
  phase += phaseInc;
  if (phase >= 1.0) {
    phase -= 1.0;
  }

  // Capture frames for animated gif
  if (captureFrames) {  
    saveFrame("./gif/frame_####.gif");
    if (frameCount >= nFrames) {
      exit();
    }
  }
}

