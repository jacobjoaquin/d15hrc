void loadStrips(Strips strips, String filename) {
  JSONArray values = loadJSONArray(filename);
  int nValues = values.size();

  for (int i = 0; i < nValues; i++) {
    JSONObject data = values.getJSONObject(i);
    int id = data.getInt("id");
    int density = data.getInt("density");
    int nLights = data.getInt("numberOfLights");
    JSONArray startPoint = data.getJSONArray("startPoint");
    JSONArray endPoint = data.getJSONArray("endPoint");

    float x1 = startPoint.getInt(0);
    float y1 = startPoint.getInt(1);
    float z1 = startPoint.getInt(2);
    float x2 = endPoint.getInt(0);
    float y2 = endPoint.getInt(1);
    float z2 = endPoint.getInt(2);
    float x3 = modelX(x1, y1, z1); 
    float y3 = modelY(x1, y1, z1); 
    float z3 = modelZ(x1, y1, z1); 
    float x4 = modelX(x2, y2, z2); 
    float y4 = modelY(x2, y2, z2); 
    float z4 = modelZ(x2, y2, z2); 

    PVector p1 = new PVector(x3, y3, z3);
    PVector p2 = new PVector(x4, y4, z4);
    strips.add(new Strip(p1, p2, density));
  }
}

void writeJSONStrips(Strips strips, String saveAs) {
  JSONArray values = new JSONArray();

  for (int i = 0; i < strips.size (); i++) {
    JSONObject data = new JSONObject();
    Strip strip = strips.get(i);

    data.setInt("id", i);
    data.setInt("density", strip.density);
    data.setInt("numberOfLights", strip.nLights);

    JSONArray p1 = new JSONArray();
    p1.setFloat(0, strip.p1.x);
    p1.setFloat(1, strip.p1.y);
    p1.setFloat(2, strip.p1.z);
    data.setJSONArray("startPoint", p1);

    // Capture individual LED positions    
    //    JSONArray lights = new JSONArray(); 
    //    for (int j = 0; j < strip.nLights; j++) {
    //      JSONArray pos = new JSONArray(); 
    //      LED led = strip.lights.get(j);
    //      pos.setFloat(0, led.position.x);
    //      pos.setFloat(1, led.position.y);
    //      pos.setFloat(2, led.position.z);
    //      lights.setJSONArray(j, pos); 
    //    }
    //    data.setJSONArray("pixelPosition", lights);

    JSONArray p2 = new JSONArray();
    p2.setFloat(0, strip.p2.x);
    p2.setFloat(1, strip.p2.y);
    p2.setFloat(2, strip.p2.z);    
    data.setJSONArray("endPoint", p2);

    values.setJSONObject(i, data);
  }

  println(values);
  saveJSONArray(values, saveAs);
}
