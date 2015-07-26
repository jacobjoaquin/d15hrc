import hypermedia.net.*;

String ip = "localhost";
int port = 6100;
PixelMap pixelMap;
ArrayList<Strip> strips;
String filename = "test.json";
BroadcastReceiver broadcastReceiver;

void setup() {
  strips = new ArrayList<Strip>();
  loadStrips(strips, filename);
  pixelMap = new PixelMap(strips);
  size(pixelMap.columns, pixelMap.rows);
  broadcastReceiver = new BroadcastReceiver(this, pixelMap, ip, port);
}

void draw() {
  pixelMap.display();
}

