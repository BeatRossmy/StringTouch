class Interface {
  float [] rawValues, picturedValues;

  float center, nextCenter;
  boolean hand;

  int timer;

  Button l, r, t, b;

  ArrayList<Wave> waves;
  boolean editWaves;

  public Interface () {
    waves = new ArrayList<Wave>();
    rawValues = new float [36];
    picturedValues = new float [36];
    for (int i=0; i<36; i++) rawValues[i] = 64;
    for (int i=0; i<36; i++) picturedValues[i] = 64;
    center = 4.5;
    nextCenter = 4.5;
    l = new Button();
    r = new Button();
    t = new Button();
    b = new Button();
  }

  void handle () {
    for (Wave w : waves) w.handle();
    for (int i=waves.size()-1; i>=0; i--) waves.get(i).removeFrom(waves);
    l.handle();
    r.handle();
    t.handle();
    b.handle();

    center = center*0.95+nextCenter*0.05;

    if (timer>0 && !hand) timer-=2;
    if (timer<300 && hand) timer+=3;

    for (int i=0; i<36; i++) picturedValues[i] = picturedValues[i]*0.7+rawValues[i]*0.3;
  }

  void plotRawValues (PGraphics layer) {
    float w = layer.width;
    float h = layer.height;

    layer.beginDraw();
    layer.rectMode(CENTER);
    layer.background(255);

    layer.fill(slide(color(255, 0, 255, 33), color(0, 255, 255, 33), map(64, 0, 127, 0, 1)));

    layer.rect(w*0.5, h*0.5-400, w, 36);
    layer.rect(w*0.5, h*0.5, w, 36);
    layer.rect(w*0.5, h*0.5+400, w, 36);

    layer.noStroke();
    layer.fill(255, 33);
    for (int i=0; i<12; i++) {
      for (int l=0; l<3; l++) {
        float d = map(picturedValues[i+l*12], 0, 127, 50, 500);
        layer.fill(slide(color(255, 0, 255, 33), color(0, 255, 255, 33), map(picturedValues[i+l*12], 0, 127, 0, 1)));
        layer.ellipse(375+i*150, h*0.5+(-400+l*400), d, d);
      }
    }
    layer.endDraw();
  }

  void plotInterface (PGraphics layer) {
    float d = layer.height*0.33;
    float w = layer.width;
    float h = layer.height;
    float c = 1200;

    layer.beginDraw();
    layer.background(0);
    layer.stroke(255);

    layer.fill(225);

    l.plot(c-w*0.25, h*0.5, layer);
    r.plot(c+w*0.25, h*0.5, layer);
    t.plot(c, h*0.5-400, layer);
    b.plot(c, h*0.5+400, layer);

    layer.endDraw();
  }

  void plotFollow (PGraphics layer) {
    float d = layer.height*0.33;
    float w = layer.width;
    float h = layer.height;
    float c = 600-75+center*150;

    layer.beginDraw();
    layer.background(0);

    layer.stroke(constrain(timer, 0, 255));
    layer.noFill();

    layer.ellipse(c-w*0.25, h*0.5, 300, 300);
    layer.ellipse(c+w*0.25, h*0.5, 300, 300);
    layer.ellipse(c, h*0.5-400, 300, 300);
    layer.ellipse(c, h*0.5+400, 300, 300);

    layer.endDraw();
  }

  void plotGestures (PGraphics layer) {
    float d = layer.height*0.33;
    float w = layer.width;
    float h = layer.height;
    float c = 600-75+center*150;

    layer.beginDraw();
    layer.background(0);

    layer.stroke(constrain(timer, 0, 255));
    layer.noFill();

    editWaves = true;
    for (Wave wave : waves) wave.plot(0, 0, layer);
    editWaves = false;

    layer.endDraw();
  }

  void triggerDownStrum () {
    while(editWaves){}
    waves.add(new LinearWave(0, 0, 1200, 8, color(255), DIRECTION.DOWN));
  }

  void triggerUpStrum () {
    while(editWaves){}
    waves.add(new LinearWave(1200, 1200, 0, -8, color(255), DIRECTION.UP));
  }

  void triggerLeftSlide () {
    while(editWaves){}
    waves.add(new LinearWave(0, 0, 2400, 16, color(255), DIRECTION.LEFT));
  }

  void triggerRightSlide () {
    while(editWaves){}
    waves.add(new LinearWave(2400, 2400, 0, -16, color(255), DIRECTION.RIGHT));
  }

  void setRawValue (int id, float value) {
    int index = 0;
    if (id%3==0) index = (id/3);
    if ((id-1)%3==0) index = ((id-1)/3)+12;
    if ((id-2)%3==0) index = ((id-2)/3)+24;
    rawValues[index] = value;
  }

  void setCenter (int x) {
    if (timer == 0) center = x-1;
    nextCenter = x-1;
  }

  void setHand (boolean b) {
    hand = b;
  }
}
