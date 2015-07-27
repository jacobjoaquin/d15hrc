import hypermedia.net.*;
import moonpaper.*;

// Teatrp
String jsonFile = "test.json";
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
  pixelMap = new PixelMap(strips);        // Create 2D PixelMap from strips
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

