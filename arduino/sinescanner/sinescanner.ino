#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN 1
#define N_PIXELS 30
#define SCANNER_LENGTH 11

// Internal variables
Adafruit_NeoPixel strip;
uint32_t theBuffer[SCANNER_LENGTH + 1];
float phase = 0.5;
int direction = 1;
uint32_t nextUpdate = 0;

// User defined settings
uint32_t theDelay = 10;
float phaseInc = 0.004;

void loadBuffer() {
  setBufferColor(0, 0xff8800, 0, 5);
  theBuffer[5] = 0xff9922;
  setBufferColor(0xff8800, 0, 6, 5);
  theBuffer[SCANNER_LENGTH] = 0;
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

  float p = (sin(phase * TWO_PI) + 1.0) / 2.0 * N_PIXELS;
  int p0 = p;
  float interp = 1 - (p - float(p0));
  int offset = SCANNER_LENGTH / 2;
  
  for (int i = 0; i < SCANNER_LENGTH; i++) {
    int pos = p0 - offset + i;
    uint32_t c = lerpColor(theBuffer[i], theBuffer[i + 1], interp);
    
    if (pos >= 0 && pos < N_PIXELS) {
      strip.setPixelColor(pos, c);
    }
  }

  strip.show();
  phase += phaseInc;
  phase -= phase >= 1.0 ? 1 : 0;
}

