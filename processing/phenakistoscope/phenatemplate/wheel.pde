class Wheel {
  float radius;
  int nFrames;

  Wheel(int nFrames) {
    this.nFrames = nFrames;
    this.radius = width / 2.0;
  }

  void createFrames(Phenamation phenamation, int phenaFrames, float aniOffset, float position, float scalePhrena) {
    pushMatrix();
    rotate(frameCount % nFrames / float(nFrames) * TWO_PI);

    for (int i = 0; i < phenaFrames; i++) {
      float offset = i / float(phenaFrames);
      float angle = offset * TWO_PI;

      pushMatrix();
      rotate(angle);
      translate(radius * position, 0);
      scale(scalePhrena);
      phenamation.draw(offset + aniOffset * TWO_PI);
      popMatrix();
    }
    popMatrix();
  }
}
