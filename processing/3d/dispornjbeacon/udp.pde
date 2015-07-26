class Broadcast {
  UDP udp;
  PApplet papplet;
  PixelMap pixelMap;
  String ip;
  int port;
  int bufferSize = 3 * 173 * 23;
  byte buffer[] = new byte[bufferSize];

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
  }

  void send() {
    int nPixels = width * height;
    
    loadPixels();
    for (int i = 0; i < nPixels; i++) {
      int c = pixels[i];
      int r = (c >> 16) & 0xFF;
      int g = (c >> 8) & 0xFF;
      int b = c & 0xFF;
      int offset = i * 3;
      buffer[offset] = byte(r); 
      buffer[offset + 1] = byte(g); 
      buffer[offset + 2] = byte(b); 
    }
    
    udp.send(buffer, ip, port);
  }
}
