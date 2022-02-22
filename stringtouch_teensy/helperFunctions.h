float map (float x, float a, float b, float y, float z) {
  return ((x - a) / (b - a) * (z - y)) + y;
}
