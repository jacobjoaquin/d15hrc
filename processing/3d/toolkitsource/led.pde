class LEDs extends ArrayList<LED> {
}

class LED {
  PVector position;
  color c;
 
  LED() {
    this.position = new PVector();
    c = color(0);
  }

  LED(PVector position) {
    this.position = position;
    c = color(0);
  }
}
