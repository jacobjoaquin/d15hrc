/*
About this animation:
 * Each strip is animated separately.
 * One light per strip.
 * The position of the led is incremented by 1.
 * The position is reset back to 0 once it exceeds the length of the strip.
 
 */

class StripSweep extends Displayable {
  PixelMap pixelMap;
  ArrayList<StripAnimation> animations;

  class StripAnimation {
    Strip strip;
    int position;

    StripAnimation(Strip strip) {
      this.strip = strip;
      position = 0;
    }
  }

  StripSweep(PixelMap pixelMap) {
    this.pixelMap = pixelMap;
    animations = new ArrayList<StripAnimation>();

    for (Strip strip : pixelMap.strips) {
      animations.add(new StripAnimation(strip));
    }
  }

  void update() {
    for (StripAnimation animation : animations) {
      animation.position = (animation.position + 1) % animation.strip.nLights;
    }
  }

  void display() {
    loadPixels();

    for (int row = 0; row < pixelMap.rows; row++) {
      StripAnimation animation = animations.get(row);
      pixels[row * pixelMap.columns + animation.position] = color(255);
    }

    updatePixels();
  }
}

