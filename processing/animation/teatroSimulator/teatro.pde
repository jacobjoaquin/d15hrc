void createTeatro() {
  ArrayList<Strip> s = new ArrayList<Strip>();
  int nCapStrips = 3;
  int density = 30;
  
  // Left endcap
  PVector p0b = new PVector(-800, 0, 200);
  PVector p0t = new PVector(-800, 500, 200);
  PVector p1b = new PVector(-600, 0, 0);
  PVector p1t = new PVector(-600, 500, 0);

  // Left Angle
  PVector p1front_b = new PVector(-600, 200, 0); 
  PVector p1front_m = new PVector(-600, 300, 0); 
  PVector p1front_t = new PVector(-600, 400, 0); 
  PVector p2front_b = new PVector(-200, 200, 400); 
  PVector p2front_m = new PVector(-200, 300, 400); 
  PVector p2front_t = new PVector(-200, 400, 400); 

  // Right Angle
  PVector p3front_b = new PVector(200, 200, 400); 
  PVector p3front_m = new PVector(200, 300, 400); 
  PVector p3front_t = new PVector(200, 400, 400); 
  PVector p4front_b = new PVector(600, 200, 0); 
  PVector p4front_m = new PVector(600, 300, 0); 
  PVector p4front_t = new PVector(600, 400, 0); 

  // Right endcap
  PVector p4b = new PVector(600, 0, 0);
  PVector p4t = new PVector(600, 500, 0);
  PVector p5b = new PVector(800, 0, 200);
  PVector p5t = new PVector(800, 500, 200);

  // Left endcap
  s.add(new Strip(p0t, p1b, density));  
  for (int i = 0; i < nCapStrips; i++) {
    float n = i / float(nCapStrips);    
    s.add(new Strip(p0t, lerp(p0b, p1b, n), density));
    s.add(new Strip(p1b, lerp(p1t, p0t, n), density));
  }
  
  // Left Angle
  s.add(new Strip(p1front_b, p2front_b, density));  
  s.add(new Strip(p1front_m, p2front_m, density));  
  s.add(new Strip(p1front_t, p2front_t, density));  

  // Middle
  s.add(new Strip(p2front_b, p3front_b, density));  
  s.add(new Strip(p2front_m, p3front_m, density));  
  s.add(new Strip(p2front_t, p3front_t, density));  

  // Right Angle
  s.add(new Strip(p3front_b, p4front_b, density));  
  s.add(new Strip(p3front_m, p4front_m, density));  
  s.add(new Strip(p3front_t, p4front_t, density));  
  

  
  // Right 
  s.add(new Strip(p5t, p4b, density));  
  for (int i = 0; i < nCapStrips; i++) {
    float n = i / float(nCapStrips);    
    s.add(new Strip(p5t, lerp(p5b, p4b, n), density));
    s.add(new Strip(p4b, lerp(p4t, p5t, n), density));
  }

  for (Strip strip : s) {
    strips.add(strip);
  }
}
