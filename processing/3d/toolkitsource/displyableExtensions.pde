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

  DisplayableLEDs(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    setup();
  }

  void setup() {
    super.setup();

    leds = new LEDs();

    // Create LED Matrix that has a 1 to 1 ordered relationship to
    // the LEDs in the strip
    ledMatrix = new ArrayList<LEDs>();
    for (Strip strip : strips) {
      LEDs theseLeds = new LEDs();

      for (LED led : strip.leds) {
        LED thisLed = new LED();
        thisLed.position = led.position.get();
        theseLeds.add(thisLed);
        leds.add(thisLed);
      }

      ledMatrix.add(theseLeds);
    }
  }
  
  void update() {
    pg.beginDraw();
    pg.clear();
    pg.loadPixels();

    for (int row = 0; row < ledMatrix.size(); row++) {
      LEDs theseLeds = ledMatrix.get(row);
      for (int col = 0; col < theseLeds.size (); col++) {
        LED led = theseLeds.get(col);
        pg.pixels[row * strips.getMaxStripLength() + col] = led.c;
      }
    }
    
    pg.updatePixels();
    pg.endDraw();
  }
}
