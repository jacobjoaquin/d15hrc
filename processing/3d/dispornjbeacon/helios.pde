void createHelios() {
  float innerRadius = 32;
  int nStrips = 25;
  int density = 60;
  PVector origin = new PVector(0, 500, 500);

  for (int i = 0; i < nStrips; i++) {
    PVector angle = PVector.fromAngle(i / float(nStrips - 1) * PI);
    PVector p1 = angle.get();
    PVector p2 = angle.get();

    p1.mult(innerRadius);
    p1.add(origin);
    p2.mult(innerRadius + 4 * meter);
    p2.add(origin);
    Strip s = new Strip(p1, p2, density);
    strips.add(s);
  }
}
