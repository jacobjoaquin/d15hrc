import hypermedia.net.*;
import moonpaper.*;

// Teatrp
String jsonFile = "teatro.json";
PixelMap pixelMap;
ArrayList<Strip> strips;

// Broadcast
Broadcast broadcast;
String ip = "localhost"; 
int port = 6100;

// Animation
SimpleSweep simpleSweep;

void setup() {
  // Setup Virtual LED Installation  
  strips = new ArrayList<Strip>();        // Data structure for storing individual strips
  loadStrips(strips, jsonFile);           // Load strips from file
  pixelMap = new PixelMap();              // Create 2D PixelMap from strips
  pixelMap.addStrips(strips);
  pixelMap.finalize();
  size(pixelMap.columns, pixelMap.rows);  // Create canvas
  
  // Setup Broadcasting
  broadcast = new Broadcast(this, pixelMap, ip, port);  // Set up broadcast
  broadcast.pg = g;                                     // Broadcast global canvas instead of PixelMap

  // Setup Animation
  simpleSweep = new SimpleSweep();
}

void draw() {
  background(0);
  
  // Update and display animation
  simpleSweep.update();
  simpleSweep.display();

  // Broadcast to simulator  
  broadcast.send();
}

