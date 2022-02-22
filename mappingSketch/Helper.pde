void drawGradient (float x, float y, float d, float v, PGraphics pg) {
  float brightness = constrain(v, -150, 666);
  brightness = map(brightness, -150, 666, 33, 175);
  for (int i=0; i<4; i++) {
    pg.fill(255, brightness/(i+1));
    float value = 0;
    if (i>0) value = constrain(v/pow(2, i-1), -150, 1000);
    pg.ellipse(x, y, d+value, d+value);
  }
}

color slide (color a, color b, float p) {
  return color(red(a)*p+red(b)*(1-p),green(a)*p+green(b)*(1-p),blue(a)*p+blue(b)*(1-p),alpha(a)*p+alpha(b)*(1-p));
}
