import hypermedia.net.*;

UDP udp;
int listenPort = 6100;
int nPixels;

void setup() {
  size(173, 23);
  nPixels = width * height;
  udp = new UDP(this, listenPort);
  udp.listen( true );
}

void draw() {
}

void receive(byte[] data, String ip, int port) {
  loadPixels();

  for (int i = 0; i < nPixels; i++) {
    int offset = i * 3;
    pixels[i] = 0xFF000000 |
      ((data[offset] & 0xFF) << 16) |
      ((data[offset + 1] & 0xFF) << 8) |
      (data[offset + 2] & 0xFF);
  }

  updatePixels();
}
