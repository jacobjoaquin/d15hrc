void newStrip(PVector p1, PVector p2, int density, int nLeds) {
}

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

class Teatro extends StructureLayout {
  final static float crossbar = 13 * 12;
  int density = 30;
  //  float spacer = 6;
  float spacer = 0;

  Teatro() {
    super();

    float floors[] = {
      1, 9, 17
    };
    float cols[] = {
      0, crossbar + spacer
    };

    // Floors 1, 2, 3
    for (int f = 0; f < floors.length; f++) {
      float h = inchesToCM(floors[f] * 12);
      println(h);
      pushMatrix();
      translate(0, h, 0);

      for (int c = 0; c < cols.length; c++) {
        float x = inchesToCM(cols[c]);
        pushMatrix();
        translate(x, 0, 0);

        PVector p1 = new PVector(0, 0, 0);
        PVector p2 = new PVector(400, 0, 0);
        Strip s = new Strip(transPVector(p1), transPVector(p2), density);
        strips.add(s);

        popMatrix();
      }
      popMatrix();
    }

    // Floor 3.5
    {
      pushMatrix();
      float h = inchesToCM(21 * 12);
      println(h);
      float x = inchesToCM(cols[1]);
      translate(x, h, 0);       
      PVector p1 = new PVector(0, 0, 0);
      PVector p2 = new PVector(400, 0, 0);
      Strip s = new Strip(transPVector(p1), transPVector(p2), density);
      strips.add(s);
      popMatrix();
    }

    {
      pushMatrix();
      translate(inchesToCM(2 * crossbar + spacer), 0, 0);
      rotateY(-HALF_PI);
      // Top Helios
      pushMatrix();
      translate(0, inchesToCM((21 - 15) * 12), 0);
      helios();
      popMatrix();
      
      // Bottom Helios
      
      
      popMatrix();
    }
  }

  void helios() {
    for (int i = 0; i < 3; i++) {
      pushMatrix();      
      rotateZ(radians(-i * 12));

      PVector p1 = new PVector(0, 0, 0);
      PVector p2 = new PVector(0, 450, 0);
      Strip s = new Strip(transPVector(p1), transPVector(p2), density);
      strips.add(s);

      popMatrix();
    }
  }
}

Strips createTheTeatro() {
  Strips strips = new Strips();

  // Left Side
  {
    pushMatrix();
    scale(-1, 1, 1);
    rotateY(radians(30));
    translate(inchesToCM(1.5 * Teatro.crossbar), 0, 0);
    Teatro teatro = new Teatro();
    strips.addAll(teatro.getStrips());
    popMatrix();
  }

  // Right side
  {
    pushMatrix();
    rotateY(radians(30));
    translate(inchesToCM(1.5 * Teatro.crossbar), 0, 0);
    Teatro teatro = new Teatro();
    strips.addAll(teatro.getStrips());
    popMatrix();
  }

  return strips;
}
