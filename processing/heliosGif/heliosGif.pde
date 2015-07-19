int nFrames = 120;

ArrayList<Strip> strips;
float phase = 0.0;
float phaseInc = 1.0 / float(nFrames);

class Strip {
  int nLights = 120;
  PVector innerPosition;
  PVector outerPosition;

  ArrayList<Boolean> motionOut;

  Strip(PVector innerPosition, PVector outerPosition) {
    this.innerPosition = innerPosition;
    this.outerPosition = outerPosition;

    motionOut = new ArrayList<Boolean>();    
    for (int i = 0; i < nLights; i++) {
      Boolean b = false;
      if (random(1.0) < 0.25) {
        b = true;
      }
      motionOut.add(b);
    }
  }

  void update() {
    Boolean b = motionOut.remove(motionOut.size() - 1);
    motionOut.add(0, b);
  }

  void display() {
    float s = 3;
    pushStyle();
    noStroke();
    fill(255);
    int L = motionOut.size();
    for (int i = 0; i < L; i++) {
      Boolean b = (Boolean) motionOut.get(i);
      float offset = i / float(L);
      if (b) {
        float x = lerp(innerPosition.x, outerPosition.x, offset);
        float y = lerp(innerPosition.y, outerPosition.y, offset);
        ellipse(x, y, s, s);
        x = lerp(innerPosition.x, outerPosition.x, 1 - offset);
        y = lerp(innerPosition.y, outerPosition.y, 1 - offset);
        ellipse(x, y, s, s);
      }
    }
    popStyle();
  }
}

void setup() {
  size(500, 265, P2D);

  PVector center = new PVector(width / 2.0, height - 10);
  int nStrips = 25;
  strips = new ArrayList<Strip>();

  for (int i = 0; i < nStrips; i++) {
    PVector angle = PVector.fromAngle(i / float(nStrips - 1) * -PI);
    PVector p1 = angle.get();
    PVector p2 = angle.get();

    p1.mult(20);
    p1.add(center);
    p2.mult(245);
    p2.add(center);
    Strip s = new Strip(p1, p2);
    strips.add(s);
  }
}

void draw() {
  background(0);
  for (Strip s : strips) {
    s.update();
  }
  for (Strip s : strips) {
    s.display();
  }
  
  saveFrame("./gif/frame_####.gif");
  if (frameCount > nFrames) {
    exit();
  }  
}

