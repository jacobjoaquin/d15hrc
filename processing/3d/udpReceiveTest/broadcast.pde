import hypermedia.net.*;


class BroadcastReceiver {
  PApplet papplet;
  PixelMap pixelMap;
  String ip;
  int port;
  UDP udp;
  PGraphics pg;
  int nPixels;
  int bufferSize;
  byte buffer[];

  BroadcastReceiver(PApplet papplet, PixelMap pixelMap, String ip, int port) {
    this.papplet = papplet;
    this.pixelMap = pixelMap;
    this.ip = ip;
    this.port = port;

    setup();
  }

  void setup() {
    println("setup");
    nPixels = pixelMap.columns * pixelMap.rows;
    bufferSize =  3 * nPixels + 1;
    buffer = new byte[bufferSize];
    pg = pixelMap.pg;

    udp = new UDP(papplet, port);
    udp.log(false);
    udp.listen(true);
  }

  void receive(byte[] data, String ip, int port) {
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


void receive(byte[] data, String ip, int port) {
  broadcastReceiver.receive(data, ip, port);
}

