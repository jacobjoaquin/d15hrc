
void generateArcLayer() {
  generateMultiArcs(1.125, 1.04, pornjPink);
  generateMultiArcs(1.125, 1.05, pornjOrange);
}

void generateMultiArcs(float start, float m, color c) {
  pushStyle();
  float d = start;
  while (d < 2.5) {
    stroke(c, map(d, 1.125, 2.5, 0, 212));
    generateArcs(d);
    d *= m;
  }
  popStyle();
} 

void generateArcs(float inc) {
  float angle = random(TWO_PI);
  float d = 1;
  float d1 = 1;
  float maxDistance = sqrt(2) * sWidth;

  while (d < maxDistance) {
    float thisAngle = angle;
    angle += map(noise(nx), 0.0, 1.0, -TWO_PI, TWO_PI);
    nx += nInc;
    PVector p = PVector.fromAngle(thisAngle);
    PVector p1 = p.get();
    p.mult(d);
    p1.mult(d1);

    strokeWeight(map(d, 0, maxDistance, 1, 10));
    line(p.x, p.y, p1.x, p1.y);

    if (angle > thisAngle) {
      arc(0, 0, d * 2, d * 2, thisAngle, angle);
    } else {
      arc(0, 0, d * 2, d * 2, angle, thisAngle);
    }
    d1 = d;

    if (random(1) > 0.5) {
      d *= inc;
    } else {
      d *= 1.0 / (inc / 2.0);
    }
  }
}
