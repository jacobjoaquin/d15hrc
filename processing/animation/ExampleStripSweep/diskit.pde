import hypermedia.net.*;
import moonpaper.*;

BroadcastReceiver broadcastReceiver;
int meter = 100;

class Broadcast {
  Object receiveHandler;
  PixelMap pixelMap;
  String ip;
  int port;
  UDP udp;
  PGraphics pg;
  int nPixels;
  int bufferSize;
  byte buffer[];

  Broadcast(Object receiveHandler, PixelMap pixelMap, String ip, int port) {
    this.receiveHandler = receiveHandler;
    this.pixelMap = pixelMap;
    this.ip = ip;
    this.port = port;

    setup();
  }

  private void setup() {
    nPixels = pixelMap.columns * pixelMap.rows;
    bufferSize =  3 * nPixels + 1;
    buffer = new byte[bufferSize];
    pg = pixelMap.pg;

    udp = new UDP(receiveHandler);
    udp.setReceiveHandler("broadcastReceiveHandler");
    udp.log(false);
    udp.listen(false);
  }

  void send() {
    buffer[0] = 1;  // Header. Always 1.

    pg.loadPixels();
    for (int i = 0; i < nPixels; i++) {
      int offset = i * 3 + 1;
      int c = pg.pixels[i];
      
      buffer[offset] = byte((c >> 16) & 0xFF);     // Red 
      buffer[offset + 1] = byte((c >> 8) & 0xFF);  // Blue
      buffer[offset + 2] = byte(c & 0xFF);         // Green
    }

    udp.send(buffer, ip, port);
  }
}

class BroadcastReceiver {
  Object receiveHandler;
  PixelMap pixelMap;
  String ip;
  int port;
  UDP udp;
  PGraphics pg;
  int nPixels;
  int bufferSize;
  byte buffer[];

  BroadcastReceiver(Object receiveHandler, PixelMap pixelMap, String ip, int port) {
    this.receiveHandler = receiveHandler;
    this.pixelMap = pixelMap;
    this.ip = ip;
    this.port = port;

    setup();
  }

  protected void setup() {
    nPixels = pixelMap.columns * pixelMap.rows;
    bufferSize =  3 * nPixels + 1;
    buffer = new byte[bufferSize];
    pg = pixelMap.pg;

    udp = new UDP(receiveHandler, port);
    udp.setReceiveHandler("broadcastReceiveHandler");
    udp.log(false);
    udp.listen(true);
  }

  public void receive(byte[] data, String ip, int port) {
    if (data.length != bufferSize || data[0] != 1) {
      return;
    }
    
    pg.loadPixels();

    for (int i = 0; i < nPixels; i++) {
      int offset = i * 3 + 1;

      pg.pixels[i] = 0xFF000000 |         // Alpha
      ((data[offset] & 0xFF) << 16) |     // Red
      ((data[offset + 1] & 0xFF) << 8) |  // Green
      (data[offset + 2] & 0xFF);          // Blue
    }

    pg.updatePixels();
  }
}

class LED {
  PVector position;
  color c;

  LED(PVector position) {
    this.position = position;
    c = color(0);
  }
}

class Strip {
  PVector p1;
  PVector p2;
  int density;
  int nLights;
  ArrayList<LED> lights;

  Strip(PVector p1, PVector p2, int density) {
    this.p1 = p1;
    this.p2 = p2;
    this.density = density;
    nLights = ceil(dist(p1, p2) / meter * density);

    // Create positions for each LED
    lights = new ArrayList<LED>();    
    for (int i = 0; i < nLights; i++) {
      float n = i / float(nLights);
      PVector p = lerp(p1, p2, n);
      lights.add(new LED(p));
    }
  }
}

class PixelMap extends Displayable {
  int rows;
  int columns;
  PGraphics pg;
  ArrayList<LED> lights;
  int nLights;
  ArrayList<Strip> strips;

  PixelMap(ArrayList<Strip> strips) {
    this.strips = strips;
    lights = new ArrayList<LED>();
    columns = 0;
    rows = strips.size();

    for (Strip strip : strips) {
      columns = max(columns, strip.nLights);

      for (LED L : strip.lights) {
        lights.add(L);
        L.c = color(random(255));
      }
    }

    pg = createGraphics(columns, rows);
    //    pg.background(0, 0, 255);
    nLights = lights.size();
  }

  void update() {
    pg.beginDraw();
    pg.background(255, 0, 0);
    pg.loadPixels();

    for (int row = 0; row < rows; row++) {
      Strip strip = strips.get(row);
      int stripSize = strip.nLights;
      int rowOffset = row * pg.width;
      ArrayList<LED> lights = strip.lights;

      for (int col = 0; col < stripSize; col++) {
        pg.pixels[rowOffset + col] = lights.get(col).c;
      }
    }

    pg.updatePixels();
    pg.endDraw();
  }

  void display() {
    try {
      image(pg, 0, 0);
    }
    catch (Exception e) {
      println("PixelMap.display() exception. Could not draw image");
    }
  }
}

void broadcastReceiveHandler(byte[] data, String ip, int port) {
  broadcastReceiver.receive(data, ip, port);
}

void loadStrips(ArrayList<Strip> strips, String filename) {
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

void writeJSONStrips(ArrayList<Strip> strips, String saveAs) {
  JSONArray values = new JSONArray();

  for (int i = 0; i < strips.size (); i++) {
    JSONObject data = new JSONObject();
    Strip strip = strips.get(i);

    data.setInt("id", i);
    data.setInt("density", strip.density);
    data.setInt("numberOfLights", strip.nLights);

    JSONArray p1 = new JSONArray();
    p1.setFloat(0, strip.p1.x);
    p1.setFloat(1, strip.p1.y);
    p1.setFloat(2, strip.p1.z);
    data.setJSONArray("startPoint", p1);

    JSONArray p2 = new JSONArray();
    p2.setFloat(0, strip.p2.x);
    p2.setFloat(1, strip.p2.y);
    p2.setFloat(2, strip.p2.z);    
    data.setJSONArray("endPoint", p2);

    values.setJSONObject(i, data);
  }

  println(values);
  saveJSONArray(values, saveAs);
}

float dist(PVector p1, PVector p2) {
  return dist(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
}

PVector lerp(PVector p1, PVector p2, float amt) {
  float x = lerp(p1.x, p2.x, amt);
  float y = lerp(p1.y, p2.y, amt);
  float z = lerp(p1.z, p2.z, amt);

  return new PVector(x, y, z);
}
