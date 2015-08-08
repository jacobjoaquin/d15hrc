#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN 1
#define N_PIXELS 30

Adafruit_NeoPixel strip;
uint32_t pattern[N_PIXELS];
int position = 0;

uint32_t orange = strip.Color(255, 96, 0);
uint32_t pink = strip.Color(255, 64, 160);
uint32_t white = strip.Color(127, 127, 127);

// User defined settings
int theDelay = 20;
uint32_t headColor = pink;
uint32_t tailColor = orange;
uint32_t endColor = 0;
int headLength = 3;
int tailLength = 12;

void setup() {
  strip = Adafruit_NeoPixel(N_PIXELS, PIN, NEO_GRB + NEO_KHZ800);
  
  for (int i = 0; i < headLength; i++) {
    pattern[i] = lerpColor(headColor, tailColor, (float(i) / float(headLength)));
  }
  for (int i = headLength; i < headLength + tailLength; i++) {
    pattern[i] = lerpColor(tailColor, endColor, (float(i - headLength) / float(tailLength)));
  }

  strip.begin();
  strip.show();
}

void loop() {
  cycleBuffer();
  delay(theDelay);
}

uint32_t lerpColor(uint32_t c1, uint32_t c2, float amt) {
  uint32_t r1 = (c1 & 0xff0000) >> 16;
  uint32_t g1 = (c1 & 0xff00) >> 8;
  uint32_t b1 = (c1 & 0xff);
  uint32_t r2 = (c2 & 0xff0000) >> 16;
  uint32_t g2 = (c2 & 0xff00) >> 8;
  uint32_t b2 = (c2 & 0xff);
  
  float r = (float(r1) * (1.0 - amt) + float(r2) * amt) / 2.0;
  float g = (float(g1) * (1.0 - amt) + float(g2) * amt) / 2.0;
  float b = (float(b1) * (1.0 - amt) + float(b2) * amt) / 2.0;
  
  return (uint32_t(r) << 16) | (uint32_t(g) << 8) | uint32_t(b); 
}

void cycleBuffer() {
  for (int i = 0; i < N_PIXELS; i++) {
    int thisPosition = (i + position) % N_PIXELS;    

    strip.setPixelColor(i, pattern[thisPosition]);
  }
  
  position = ++position % N_PIXELS;  
  strip.show();
}

