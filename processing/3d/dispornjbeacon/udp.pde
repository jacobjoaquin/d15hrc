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

