class DisplayableStructure extends Displayable {
  PixelMap pixelMap;  
  Structure structure;
  PGraphics pg;            // Portion of structure, initialized in child
  
  DisplayableStructure(PixelMap pixelMap, Structure structure) {
    this.pixelMap = pixelMap;
    this.structure = structure;
  }
}

class DisplayableStrips extends DisplayableStructure {
  ArrayList<Strip> strips;
  int rowOffset;

  DisplayableStrips(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
    rowOffset = structure.rowOffset;
    strips = structure.strips;
    pg = createGraphics(getMaxWidth(), strips.size());
  }

  int getMaxWidth() {
    int w = 0;
    for (Strip strip : structure.strips) {
      int size = strip.nLights;
      
      if (size > w) {
        w = size;
      }
    }
    return w;
  }

  void update() {
  }

  void display() {
    pixelMap.pg.beginDraw();
    pixelMap.pg.image(pg, 0, 0);
    pixelMap.pg.endDraw();
    
  }
}

class AniFoo extends DisplayableStrips {

  AniFoo(PixelMap pixelMap, Structure structure) {
    super(pixelMap, structure);
  }

  void update() {
    for (Strip strip : strips) {
      
    }    
  }
  
  void display() {
    pg.beginDraw();
    pg.background(0);
    pg.loadPixels();
    for (int i = 0; i < 100; i++) {
      pg.pixels[int(random(pg.width * pg.height))] = color(255);
    }    
    pg.updatePixels();
    pg.endDraw();
    super.display();
  }
}

