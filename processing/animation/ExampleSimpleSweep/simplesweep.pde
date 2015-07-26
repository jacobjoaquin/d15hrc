class SimpleSweep extends Displayable {
  int position = 0;
  int nPixels;

  SimpleSweep() {
    nPixels = width * height;
  }

  void update() {
    position = (position + 1) % nPixels;
  }

  void display() {
    pushStyle();
    stroke(255);
    strokeWeight(1);
    line(position, 0, position, height);
    popStyle();
  }
}

