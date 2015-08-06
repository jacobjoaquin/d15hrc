class DisplayableStructure extends Displayable {
  PixelMap pixelMap;
  PGraphics pixelMapPG;
  Structure structure;
  PGraphics pg;            // Portion of structure, initialized in child
  Patchable<Integer> theBlendMode;
  Patchable<Float> transparency;

  DisplayableStructure(PixelMap pixelMap, Structure structure) {
    this.pixelMap = pixelMap;
    this.structure = structure;
    pixelMapPG = this.pixelMap.pg;
    theBlendMode = new Patchable<Integer>(BLEND);
    transparency = new Patchable<Float>(255.0);
  }
}

class DisplayableStrips extends DisplayableStructure {
  Strips strips;
  int rowOffset;

  DisplayableStrips(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    setup();
  }

  void setup() {
    rowOffset = structure.rowOffset;
    strips = structure.strips;
    pg = createGraphics(structure.getMaxWidth(), strips.size());
  }

  void display() {
    pixelMapPG.beginDraw();
    pixelMapPG.blendMode(theBlendMode.value());
    pixelMapPG.tint(255, transparency.value());
    pixelMapPG.image(pg, 0, rowOffset);
    pixelMapPG.endDraw();
  }
}


class DisplayableLEDs extends DisplayableStrips {
  ArrayList<LEDs> ledMatrix;
  LEDs leds;
  int maxStripLength;

  DisplayableLEDs(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    //    setup();
  }

  void setup() {
    super.setup();
    leds = new LEDs();
    maxStripLength = strips.getMaxStripLength();

    // Create LED Matrix that has a 1 to 1 ordered relationship to
    // the LEDs in the strip
    ledMatrix = new ArrayList<LEDs>();
    int nRows = strips.size();

    for (int row = 0; row < nRows; row++) {
      Strip strip = strips.get(row);
      int nCols = strip.nLights;
      LEDs stripLeds = new LEDs();

      for (int col = 0; col < nCols; col++) {
        LED thisLed = new LED();
        LED led = strip.leds.get(col);

        thisLed.position = led.position.get();
        stripLeds.add(thisLed);
        leds.add(thisLed);
      }

      ledMatrix.add(stripLeds);
    }
  }

  void update() {
    pg.beginDraw();
    pg.clear();
    pg.loadPixels();

    int nRows = ledMatrix.size();

    for (int row = 0; row < nRows; row++) {
      LEDs stripLeds = ledMatrix.get(row);
      int nCols = stripLeds.size();
      int rowOffset = row * maxStripLength;

      for (int col = 0; col < nCols; col++) {
        LED led = stripLeds.get(col);
        pg.pixels[rowOffset + col] = led.c;
      }
    }
    
    pg.updatePixels();
    pg.endDraw();
  }
}

