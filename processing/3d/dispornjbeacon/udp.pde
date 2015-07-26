class Broadcast {
  UDP udp;
  PApplet papplet;
  PixelMap pixelMap;
  String ip;
  int port;
  int bufferSize;
  byte buffer[];

  Broadcast(PApplet papplet, PixelMap pixelMap, String ip, int port) {
    this.papplet = papplet;
    this.pixelMap = pixelMap;
    this.ip = ip;
    this.port = port;

    setupUDP();
  }

  private void setupUDP() {
    udp = new UDP(papplet);
    udp.log(false);
    bufferSize = 3 * pixelMap.columns * pixelMap.rows + 1;
    buffer = new byte[bufferSize];
  }

  void send() {
    int nPixels = width * height;

    buffer[0] = 1;  // Header. Always 1.

    loadPixels();
    for (int i = 0; i < nPixels; i++) {
      int offset = i * 3 + 1;
      int c = pixels[i];
      
      buffer[offset] = byte((c >> 16) & 0xFF);     // Red 
      buffer[offset + 1] = byte((c >> 8) & 0xFF);  // Blue
      buffer[offset + 2] = byte(c & 0xFF);         // Green
    }

    udp.send(buffer, ip, port);
  }
}

