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


    // verticals
    if (false) {
      pushMatrix();
      translate(inchesToCM( crossbar + spacer / 2.0), 0, 0);

      float verticals[] = {
        1, 9, 17, 21
      };

      for (int v = 0; v < verticals.length - 1; v++) {
        pushMatrix();
        translate(0, inchesToCM(verticals[v] * 12), 0);
        float d = (verticals[v + 1] - verticals[v]) * 12;
        PVector p1 = new PVector(0, 0, 0);
        PVector p2 = new PVector(0, inchesToCM(d), 0);

        Strip s = new Strip(transPVector(p1), transPVector(p2), density);
        strips.add(s);
        popMatrix();
      }
      popMatrix();
    }

    // Jumbotron Helios
    {
      pushMatrix();
      translate(inchesToCM(2 * crossbar + spacer), 0, 0);

      for (int i = 0; i < 12; i++) {
        pushMatrix();
        translate(inchesToCM(6), 0, 0);
        rotateY(-HALF_PI);
        translate(inchesToCM(12), 0, 0);
        translate(inchesToCM(crossbar / 28.0) * i, 0, 0);
        translate(0, inchesToCM(22 * 12) - 450, 0);  

        PVector p1 = new PVector(0, 0, 0);
        PVector p2 = new PVector(0, 450, 0);
        Strip s = new Strip(transPVector(p1), transPVector(p2), density);
        strips.add(s);
        popMatrix();
      }

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

