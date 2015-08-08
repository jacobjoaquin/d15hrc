#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN 1
#define N_PIXELS 30
Adafruit_NeoPixel strip;
uint8_t theBuffer[N_PIXELS];

// User defined settings
int theDelay = 40;
uint32_t headColor = strip.Color(255, 64, 160);
uint32_t tailColor = strip.Color(255, 96, 0);
uint32_t endColor = 0;

int headLength = 3;
int tailLength = 12;
const int gradientLength = 16;
uint32_t gradient[gradientLength];

void setup() {
  strip = Adafruit_NeoPixel(N_PIXELS, PIN, NEO_GRB + NEO_KHZ800);
  createGradient();
  for (int i = 0; i < N_PIXELS; i++) {
    theBuffer[i] = 0;
  }
  strip.begin();
  strip.clear();
  strip.show();
}

void createGradient() {
  for (int i = 0; i < headLength; i++) {
    gradient[i] = lerpColor(headColor, tailColor, (float(i) / float(headLength)));
  }
  for (int i = headLength; i < headLength + tailLength; i++) {
    gradient[i] = lerpColor(tailColor, endColor, (float(i - headLength) / float(tailLength)));
  }
  gradient[gradientLength - 1] = 0;
}

void loop() {
  doSparkle();
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

void doSparkle() {
  if (random(1) == 0) {
    int r = random(N_PIXELS);
    theBuffer[r] = gradientLength;
  }

  for (int i = 0; i < N_PIXELS; i++) {
    uint8_t b = max(theBuffer[i] - 1, 0);
    theBuffer[i] = b;
    strip.setPixelColor(i, gradient[gradientLength - 1 - theBuffer[i]]);
  }

  strip.show();
}

