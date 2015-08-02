
ArrayList<Strip> createTeatro() {
  ArrayList<Strip> strips = new ArrayList<Strip>();
  int density = 30;


  pushMatrix();
  translate(-240, 0, 0);
  rotateY(-QUARTER_PI);
  
  
  PVector p1 = transPVector(0, 0, inchesToCM(12));
  PVector p2 = transPVector(-450, 0, inchesToCM(12));
  Strip s = new Strip(p1, p2, density);
  println(s.nLights);
  strips.add(s);
  
  
  popMatrix();

  return strips;
}

