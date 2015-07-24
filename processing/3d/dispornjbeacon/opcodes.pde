class RandomValue extends MoonCodeEvent {
  Patchable<Integer> pf;
  float low;
  float high;

  RandomValue(Patchable<Integer> pf, float low, float high) {
    this.pf = pf;
    this.low = low;
    this.high = high;
  }

  void exec() {
    pf.set(color(random(low, high)));
  }
}

