void drawLetters() {
  noStroke();
  String text = "disorient";
  int counter = 0;
  String output = "";
  List<String> letters = Arrays.asList(text.split(""));
  Collections.shuffle(letters);
  String shuffled = "";

  for (String letter : letters) {
    output += letter;
    renderString(output, 1);
    counter++;
  }

  strokeWeight(1);
  stroke(0);
//  renderString("r", 1);
}

int renderString(String string, float s) {
  int bitmapWidth = 0;

  pushStyle();
  int counter = 0;
  for (char c : string.toCharArray ()) {

    String thisChar = Character.toString(c);
    Bitmap d = df.getBitmap(thisChar);

    for (int y = 0; y < d.h; y++) {
      for (int x = 0; x < d.w; x++) {
        if (d.data[y][x] == 1) {

          ellipse(x * s + bitmapWidth * s, y * s, s, s);
        }
      }
    }

    bitmapWidth += d.w + 1;
  }
  popStyle();
  return bitmapWidth - 1;
}

