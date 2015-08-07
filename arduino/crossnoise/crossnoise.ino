#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

#define PIN 1
#define N_PIXELS 30

Adafruit_NeoPixel strip;
uint8_t pattern_1[N_PIXELS];
uint8_t pattern_2[N_PIXELS];
int position_1 = 0;
int position_2 = 0;
int odds = 32;
int theDelay = 40;

uint32_t orange = strip.Color(255, 96, 0);
uint32_t pink = strip.Color(255, 64, 160);
uint32_t white = strip.Color(127, 127, 127);

void setup() {
  strip = Adafruit_NeoPixel(N_PIXELS, PIN, NEO_GRB + NEO_KHZ800);

  for (int i = 0; i < N_PIXELS; i++) {
    if (random(255) < odds) {
      pattern_1[i] = 1;
    }
    else {
      pattern_1[i] = 0;
    }

    if (random(255) < odds) {
      pattern_2[i] = 1;
    }
    else {
      pattern_2[i] = 0;
    }

  }

  strip.begin();
  strip.show(); // Initialize all pixels to 'off'
}

void loop() {
  crossNoise(orange, pink);
//  crossNoise(white, white);
  delay(theDelay);
}

void crossNoise(uint32_t c1, uint32_t c2) {
  strip.clear();
  
  for (int i = 0; i < N_PIXELS; i++) {
    int thisPosition_1 = (i + position_1) % N_PIXELS;    
    int thisPosition_2 = (i + position_2) % N_PIXELS;    

    if (pattern_1[thisPosition_1]) {
      strip.setPixelColor(i, c1);
    }
    else if (pattern_2[thisPosition_2]) {
      strip.setPixelColor(N_PIXELS - 1 - i, c2);
    }
  }
  
  pattern_1[position_1] = random(255) < odds ? 1 : 0;
  pattern_2[position_2] = random(255) < odds ? 1 : 0;
  position_1 = ++position_1 % N_PIXELS;
  position_2 = ++position_2 % N_PIXELS;
  
  strip.show();
}

