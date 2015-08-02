// Distance between two PVectors
float dist(PVector p1, PVector p2) {
  return dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
}

// Interpolate between two PVectors
PVector lerp(PVector p1, PVector p2, float amt) {
  float x = lerp(p1.x, p2.x, amt);
  float y = lerp(p1.y, p2.y, amt);
  float z = lerp(p1.z, p2.z, amt);

  return new PVector(x, y, z);
}

// Convert point to include matrix translation
PVector transPVector(float x, float y, float z) {
  float x1 = modelX(x, y, z);
  float y1 = modelY(x, y, z);
  float z1 = modelZ(x, y, z);
  return new PVector(x1, y1, z1);  
}

// Convert point to include matrix translation
PVector transPVector(PVector p) {
  return transPVector(p.x, p.y, p.z);  
}

// Inches to Centimeters
float inchesToCM(float inches) {
  return inches / 0.393701;
}

