void createFlatPanel() {
  ArrayList<Strip> s = new ArrayList<Strip>();
  int nCapStrips = 3;
  int density = 30;
  
  for (int i = 0; i < 80; i++) {
    float x = (i - 40) * 10;
    float z = -10 * meter;
    PVector p1 = new PVector(x, 0, z);
    PVector p2 = new PVector(x, 500, z);
    Strip strip = new Strip(p1, p2, density);
    s.add(strip);
  }

  for (Strip strip : s) {
    strips.add(strip);
  }
}
