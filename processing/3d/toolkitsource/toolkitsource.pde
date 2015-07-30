import hypermedia.net.*;
import moonpaper.*;
import moonpaper.opcodes.*;

String jsonFile = "test.json";
PixelMap pixelMap;
JustNoise myAnimation;

class DisPixelMap extends Displayable {
  PixelMap pixelMap;

  DisPixelMap(PixelMap pixelMap) {
    this.pixelMap = pixelMap;
  }
}


class JustNoise extends DisPixelMap {
  int nPixels;

  JustNoise(PixelMap pixelMap) {
    super(pixelMap);
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
  ArrayList<Strip> strips;
  String filename;

  Structure(PixelMap pixelMap, String filename) {
    this.pixelMap = pixelMap;
    this.filename = filename;
    setup();
  }  

  void setup() {
    strips = new ArrayList<Strip>();    
    loadFromJSON(filename);
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

    println(strips.size());
  }
}



void loadStructures() {
  ArrayList<Strip> strips = new ArrayList<Strip>();


  loadStrips(strips, jsonFile);
  pixelMap = new PixelMap();
  Structure teatro = new Structure(pixelMap, jsonFile);
  Structure flatpanel = new Structure(pixelMap, "flatpanel.json");
  pixelMap.finalize();

  size(pixelMap.columns, pixelMap.rows);
}

void setup() {
  loadStructures();
  myAnimation = new JustNoise(pixelMap);
}

void draw() {
  background(0);
  myAnimation.update();
  myAnimation.display();
}

