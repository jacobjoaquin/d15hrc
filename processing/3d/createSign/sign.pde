class Strips extends ArrayList<Strip> {
}

class StructureLayout {
  Strips strips;

  StructureLayout() {
    strips = new Strips();
  }

  Strips getStrips() {
    return strips;
  }
}

class Sign extends StructureLayout {
  final static float crossbar = 13 * 12;
  int density = 30;
  //  float spacer = 6;
  float spacer = 0;

  Sign() {
    super();

    float totalWidth = 500;
    float totalHeight = 100;
    int nLetters = 9;
    float letterWidth = 80;
    float spacer = (totalWidth - (nLetters * letterWidth)) / float(nLetters);

    pushMatrix();
    translate(-totalWidth / 2.0 + spacer / 2.0, 
    inchesToCM(21 * 12) - totalHeight, 
    -250);

    for (int row = 0; row < 14; row++) {
      pushMatrix();
      translate(0, row * (totalHeight / 14.0), 0);
      PVector p1 = new PVector(0, 0, 0);
      PVector p2 = new PVector(totalWidth, 0, 0);
      Strip s = new Strip(transPVector(p1), transPVector(p2), density);
      strips.add(s);
      popMatrix();
    }
    popMatrix();
  }


  // Individual letters
  //    pushMatrix();
  //    translate(-totalWidth / 2.0 + spacer / 2.0, 
  //    inchesToCM(21 * 12) - totalHeight,
  //    -250);
  //
  //    for (int letter = 0; letter < nLetters; letter++) {
  //      pushMatrix();
  //      translate(letter * (letterWidth + spacer), 0, 0);
  //      for (int row = 0; row < 14; row++) {
  //        pushMatrix();
  //        translate(0, row * (totalHeight / 14.0), 0);
  //        PVector p1 = new PVector(0, 0, 0);
  //        PVector p2 = new PVector(80, 0, 0);
  //        Strip s = new Strip(transPVector(p1), transPVector(p2), density);
  //        strips.add(s);
  //        popMatrix();
  //      }
  //      popMatrix();
  //    }
  //    popMatrix();
  //  }
}

Strips createTheSign() {
  Strips strips = new Strips();
  Sign sign = new Sign();
  strips.addAll(sign.getStrips());
  return strips;
}

