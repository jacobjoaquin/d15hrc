class CrossNoise extends Displayable {
  PixelMap pixelMap;
  ArrayList<Animation> animations;

  CrossNoise(PixelMap pixelMap) {
    this.pixelMap = pixelMap;
    animations = new ArrayList<Animation>();

    for (Strip strip : pixelMap.strips) {
      animations.add(new Animation(strip));
    }
  }

  void update() {
    for (Animation a : animations) {
      a.update();
    }
  }

  void display() {
    int rows = pixelMap.rows;
    int columns = pixelMap.columns; 
    color c = color(#ff8800);
    color black = color(0);

    loadPixels();
    
    for (int row = 0; row < rows; row++) {
      Animation a = animations.get(row);
      ArrayList<Boolean> lights1 = a.lights1;
      ArrayList<Boolean> lights2 = a.lights2;
      int stripSize = a.strip.nLights;
      int rowOffset = row * columns;
      
      for (int col = 0; col < stripSize; col++) {
        if (lights1.get(col) || lights2.get(col)) {
          pixels[rowOffset + col] = c;
        } else {
          pixels[rowOffset + col] = black;
        }
      }
    }
    
    updatePixels();
  }
}
