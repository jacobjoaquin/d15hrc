void drawLetters() {
  noStroke();
  float distance = 1.0;
  String text = "Reor15nt";

  ArrayList<String> variations = new ArrayList<String>();
  variations.add("oRn5tr1e");
  variations.add("tronRe51");
  variations.add("5oRter1n");
  
  int counter = 0;
  while (distance > 0.0125) {
    distance *= 0.617;
    float x = lerp(arcCenter.x, fontPosition.x, distance);
    float y = lerp(arcCenter.y, fontPosition.y, distance);

    pushMatrix();
    translate(x, y);
    
    String output = "";
    if (counter < variations.size()) {
      output = variations.get(counter);
    }
    else {
      List<String> letters = Arrays.asList(text.split(""));
      Collections.shuffle(letters);
      String shuffled = "";
      for (String letter : letters) {
        output += letter;
      }
    }
    renderString(output, dotSize * distance, map(distance, 1, 0, 180, 32));
    popMatrix();
    
    counter++;
  }

  stroke(0);
  strokeWeight(1);
  pushMatrix();
  translate(fontPosition.x, fontPosition.y);
  renderString("Reor15nt", dotSize, 255);
  popMatrix();
}

int renderString(String string, float s, float a) {
  int bitmapWidth = 0;

  pushStyle();
  int counter = 0;
  for (char c : string.toCharArray ()) {

    String thisChar = Character.toString(c);
    Bitmap d = df.getBitmap(thisChar);

    color theColor = pornjOrange;
    if (thisChar.equals("R") || thisChar.equals("e")) {
      theColor = pornjPink;
    }
    fill(theColor, a);

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

ArrayList<PVector> getLinePoints(String string, float s) {
  int bitmapWidth = 0;
  ArrayList<PVector> theList = new ArrayList<PVector>();

  for (char c : string.toCharArray ()) {
    String thisChar = Character.toString(c);
    Bitmap d = df.getBitmap(thisChar);

    for (int y = 0; y < d.h; y += 7) {
      boolean notFound = true;
      int x = 0;
      while (notFound) {
        if (d.data[y][x] == 1) {
          theList.add(new PVector(x * s + bitmapWidth * s, y * s));
          notFound = false;
        }
        x++;
      }

      notFound = true;
      x = d.w - 1;
      while (notFound) {
        if (d.data[y][x] == 1) {
          theList.add(new PVector(x * s + bitmapWidth * s, y * s));
          notFound = false;
        }
        x--;
      }
    }
    bitmapWidth += d.w + 1;
  }
  return theList;
}
