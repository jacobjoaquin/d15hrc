import java.util.Arrays;

class CrossNoise extends Displayable {
  PixelMap pixelMap;
  ArrayList<CrossNoiseAnimation> animations;
  float r = 0.125;
  Patchable<Float> theColor = new Patchable<Float>(0.0);
//  color c = color(255, 128, 0);

  class CrossNoiseAnimation {
    Strip strip;
    ArrayList<Boolean> lights1;
    ArrayList<Boolean> lights2;
    int theLength;
    PGraphics pg;

    CrossNoiseAnimation(Strip strip) {
      this.strip = strip;

      theLength = strip.nLights;
      pg = createGraphics(theLength, 1);
      lights1 = new ArrayList<Boolean>();
      lights2 = new ArrayList<Boolean>();

      for (int i = 0; i < theLength; i++) {
        if (random(1) < r) {
          lights1.add(i, true);
        } else {
          lights1.add(i, false);
        }

        if (random(1) < r) {
          lights2.add(i, true);
        } else {
          lights2.add(i, false);
        }
      }
    }

    void update() {
      Boolean temp = lights1.remove(theLength - 1);
      lights1.add(0, temp);
      Boolean temp2 = lights2.remove(0);
      lights2.add(temp2);

      pg.loadPixels();
      Arrays.fill(pg.pixels, color(0));

      for (int i = 0; i < theLength; i++) {
        Boolean b1 = lights1.get(i);
        Boolean b2 = lights2.get(i);

        if (b1 || b2) {
          pg.pixels[i] = color(theColor.value());
        }
      }

      pg.updatePixels();
    }
  }

  CrossNoise(PixelMap pixelMap) {
    this.pixelMap = pixelMap;
    animations = new ArrayList<CrossNoiseAnimation>();

    for (Strip strip : pixelMap.strips) {
      animations.add(new CrossNoiseAnimation(strip));
    }
  }

  void update() {
    for (CrossNoiseAnimation a : animations) {
      a.update();
    }
  }

  void display() {
    int rows = pixelMap.rows;

    for (int row = 0; row < rows; row++) {
      CrossNoiseAnimation a = animations.get(row);
      image(a.pg, 0, row);
    }
  }
}
