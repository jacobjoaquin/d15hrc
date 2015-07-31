class DisplayableStructure extends Displayable {
  PixelMap pixelMap;
  PGraphics pixelMapPG;
  Structure structure;
  PGraphics pg;            // Portion of structure, initialized in child
  
  DisplayableStructure(PixelMap pixelMap, Structure structure) {
    this.pixelMap = pixelMap;
    this.structure = structure;
    pixelMapPG = this.pixelMap.pg;
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

  void display() {
    pixelMapPG.beginDraw();
    pixelMapPG.image(pg, 0, rowOffset);
    pixelMapPG.endDraw();    
  }
}

