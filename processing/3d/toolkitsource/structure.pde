class Structures extends ArrayList<Structure> {
}

class Structure {
  PixelMap pixelMap;
  String filename;
  Strips strips;
  int rowOffset = 0;
  PGraphics loadTransformation;

  Structure(PixelMap pixelMap) {
    this.pixelMap = pixelMap;
  }

  Structure(PixelMap pixelMap, String filename) {
    this.pixelMap = pixelMap;
    this.filename = filename;
    loadTransformation = createGraphics(1, 1, P3D);  // P3D required to get 3D transformations
    setup();
  }  

  Structure(PixelMap pixelMap, String filename, PGraphics loadTransformation) {
    this.pixelMap = pixelMap;
    this.filename = filename;
    this.loadTransformation = loadTransformation;
    setup();
  }  

  void setup() {
    strips = new Strips();    
    loadFromJSON(filename);
    rowOffset = pixelMap.rows;
    this.pixelMap.addStrips(strips);
  }

  void loadFromJSON(String filename) {
    JSONArray values = loadJSONArray(filename);
    int nValues = values.size();

    for (int i = 0; i < nValues; i++) {
      JSONObject data = values.getJSONObject(i);
      int id = data.getInt("id");
      int density = data.getInt("density");
      int nLights = data.getInt("numberOfLights");
      JSONArray startPoint = data.getJSONArray("startPoint");
      JSONArray endPoint = data.getJSONArray("endPoint");

      // Apply transformations
      float x1 = startPoint.getInt(0);
      float y1 = startPoint.getInt(1);
      float z1 = startPoint.getInt(2);
      float x2 = endPoint.getInt(0);
      float y2 = endPoint.getInt(1);
      float z2 = endPoint.getInt(2);
      float x3 = loadTransformation.modelX(x1, y1, z1); 
      float y3 = loadTransformation.modelY(x1, y1, z1); 
      float z3 = loadTransformation.modelZ(x1, y1, z1); 
      float x4 = loadTransformation.modelX(x2, y2, z2); 
      float y4 = loadTransformation.modelY(x2, y2, z2); 
      float z4 = loadTransformation.modelZ(x2, y2, z2); 

      PVector p1 = new PVector(x3, y3, z3);
      PVector p2 = new PVector(x4, y4, z4);

      strips.add(new Strip(p1, p2, density));
    }
  }

  int getMaxWidth() {
    int w = 0;
    for (Strip strip : strips) {
      int size = strip.nLights;

      if (size > w) {
        w = size;
      }
    }
    return w;
  }
  
  // getBox
  // getHeight
  // getDepth
  // getXBoundaries
  // etc...
}

class ComboStructure extends Structure {
  
  
  ComboStructure(PixelMap pixelMap, Structures structures) {
    super(pixelMap);
  }
}
