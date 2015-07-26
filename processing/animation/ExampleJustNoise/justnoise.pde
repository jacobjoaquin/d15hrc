class JustNoise extends Displayable {
  int nPixels;

  JustNoise() {
    nPixels = width * height;
  }

  void update() {
  }

  void display() {
    loadPixels();

    for (int i = 0; i < nPixels; i++) {
      pixels[i] = color(random(1) < 0.75 ? 0 : 255);
    }

    updatePixels();
  }
}

