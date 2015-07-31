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
    setup();
  }
  
  void setup() {
    rowOffset = structure.rowOffset;
    strips = structure.strips;
    pg = createGraphics(structure.getMaxWidth(), strips.size());
  }

  void display() {
    pixelMapPG.beginDraw();
    pixelMapPG.image(pg, 0, rowOffset);
    pixelMapPG.endDraw();    
  }
}
