import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

String jsonFile = "test.json";
PixelMap pixelMap;
JustNoise myAnimation;
Structure teatro;
Structure flatpanel;

AniFoo anifoo;

// PixelMap.createStructure()
// PixelMap.createPartialStructe()



class JustNoise extends Displayable {
  int nPixels;

  JustNoise(Structure targetStucture) {
//    super(pixelMap);
    nPixels = width * height;
  }

  void update() {
  }

  void display() {
    loadPixels();

    for (int i = 0; i < nPixels; i++) {
      pixels[i] = color(random(1) < 0.75 ? 0 : 255);
    }

    updatePixels();
  }
}


class Structure {
  // Child classes map to global PixelMap via various methods
  
  PixelMap pixelMap;
  String filename;
  ArrayList<Strip> strips;
  int rowOffset = 0;

  Structure(PixelMap pixelMap, String filename) {
    this.pixelMap = pixelMap;
    this.filename = filename;
    setup();
  }  

  void setup() {
    strips = new ArrayList<Strip>();    
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
      PVector p1 = new PVector(startPoint.getInt(0), startPoint.getInt(1), startPoint.getInt(2));
      PVector p2 = new PVector(endPoint.getInt(0), endPoint.getInt(1), endPoint.getInt(2));
      strips.add(new Strip(p1, p2, density));
    }
  }
}



void loadStructures() {
  ArrayList<Strip> strips = new ArrayList<Strip>();

  loadStrips(strips, jsonFile);
  pixelMap = new PixelMap();
  teatro = new Structure(pixelMap, jsonFile);
  flatpanel = new Structure(pixelMap, "flatpanel.json");
  pixelMap.finalize();

  anifoo = new AniFoo(pixelMap, teatro);
  size(pixelMap.columns, pixelMap.rows);
}

void setup() {
  loadStructures();
  myAnimation = new JustNoise(flatpanel);
}

void draw() {
  background(0);
  anifoo.update();
  anifoo.display();
  pixelMap.display();
}

