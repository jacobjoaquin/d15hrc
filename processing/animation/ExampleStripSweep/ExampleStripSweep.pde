import hypermedia.net.*;
import moonpaper.*;

// Teatro
//String jsonFile = "../teatro.json";
String jsonFile = "../asterix.json";
PixelMap pixelMap;
ArrayList<Strip> strips;

// Broadcast
Broadcast broadcast;
String ip = "localhost"; 
int port = 6100;

// Animation
StripSweep stripSweep;

void setup() {
  // Setup Virtual LED Installation  
  strips = new ArrayList<Strip>();        // Data structure for storing individual strips
  loadStrips(strips, jsonFile);           // Load strips from file

  for (Strip strip : strips) {
    for (LED led : strip.leds) {
      led.position.y *= -1;
    }
  }

  pixelMap = new PixelMap();              // Create 2D PixelMap from strips
  pixelMap.addStrips(strips);
  pixelMap.finalize();
  size(pixelMap.columns, pixelMap.rows);  // Create canvas

    // Setup Broadcasting
  broadcast = new Broadcast(this, pixelMap, ip, port);  // Set up broadcast
  broadcast.pg = g;                                     // Broadcast global canvas instead of PixelMap

  // Setup Animation
  stripSweep = new StripSweep(pixelMap);
}

void draw() {
  background(0);

  // Update and display animation
  stripSweep.update();
  stripSweep.display();

  // Broadcast to simulator  
  broadcast.send();
}
