void createTeatro() {
  int density = 30;
  PVector p0b = new PVector(-800, 0, 200);
  PVector p0t = new PVector(-800, 500, 200);


  PVector p5b = new PVector(800, 0, 200);
  PVector p5t = new PVector(800, 500, 200);


  Strip s = new Strip(p0b, p0t, density);
  strips.add(s);
  Animation a = new Animation(s);
  animations.add(a);
}

