#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN 1
#define N_PIXELS 30
#define SCANNER_LENGTH 11

// Internal variables
Adafruit_NeoPixel strip;
uint32_t theBuffer[SCANNER_LENGTH];
float phase = 0.5;
float phaseInc = 0.01;
int direction = 1;
uint32_t nextUpdate = 0;

// User defined settings
uint32_t theDelay = 100;
uint32_t c1 = strip.Color(16, 0, 0);
uint32_t c2 = strip.Color(255, 80, 0);


void loadBuffer() {
  setBufferColor(0x110000, 0xff8800, 0, 5);
  theBuffer[5] = 0xff9922;
  setBufferColor(0xff8800, 0x110000, 6, 5);
}

void setBufferColor(uint32_t c1, uint32_t c2, uint8_t offset, uint8_t theLength) {
  for (int i = 0; i < theLength; i++) {
    theBuffer[i + offset] = lerpColor(c1, c2, float(i) / float(theLength));
  }
}

void setup() {
  strip = Adafruit_NeoPixel(N_PIXELS, PIN, NEO_GRB + NEO_KHZ800);
  strip.begin();
  strip.show();
  loadBuffer();
}

void loop() {
  doScanner();
  strip.show();
  while (millis() < nextUpdate) {}
  nextUpdate = millis() + theDelay;
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

void doScanner() {
  strip.clear();

  int p = int((sin(phase * TWO_PI) + 1.0) / 2.0 * N_PIXELS - SCANNER_LENGTH / 2.0);
    
  for (int i = 0; i < SCANNER_LENGTH; i++) {
    int writePosition = p + i;
    if (writePosition >= 0 && writePosition < N_PIXELS) {
      strip.setPixelColor(writePosition, theBuffer[i]);
    }
  }
  strip.show();

  phase += phaseInc;
  phase -= phase >= 1.0 ? 1 : 0;
}

