#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN 1
#define N_PIXELS 30

Adafruit_NeoPixel strip;
uint32_t pattern[N_PIXELS];

void setup() {
  strip = Adafruit_NeoPixel(N_PIXELS, PIN, NEO_GRB + NEO_KHZ800);
  
  strip.begin();
  for (int i = 0; i < N_PIXELS; i++) {
    strip.setPixelColor(i, 0xffffff);
  }
  strip.show();
}

void loop() {
}

