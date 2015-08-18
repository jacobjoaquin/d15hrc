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
    int nLetters = 9;
    float letterWidth = 80;
    
    
    for (int L = 0; i < nLetters; i++) {
      
      for (int row = 0; row < 14; row++) {
      }
    }
  }
}

Strips createTheSign() {
  Strips strips = new Strips();
  Sign sign = new Sign();
  strips.addAll(sign.getStrips());
  return strips;
}

