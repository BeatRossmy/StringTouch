class Wave {
  int value;
  int min;
  int max;
  int speed;
  color c;
  
  void handle () {
   value += speed;
  }
  
  public Wave (int v, int min, int max, int s, color c) {
    value = v;
    this.max = max;
    this.min = min;
    speed = s;
    this.c = c;
  }
  
  void plot (float x, float y, PGraphics layer) {}
  
  void removeFrom (ArrayList<Wave> list) {
    //if (value>max) list.remove(this);
    if (value==max) list.remove(this);
  }
}

class RadialWave extends Wave {
  public RadialWave (int v, int min, int max, int s, color c) {
    super(v,min,max,s,c);
  }
  
  void plot (float x, float y, PGraphics layer) {
    layer.stroke(c,map(value,min,max,66,0));
    layer.strokeWeight(constrain(map(value,min,max,20,0),0,10000));
    layer.noFill();
    layer.ellipse(x,y,value,value);
  }
}

enum DIRECTION {LEFT,RIGHT,UP,DOWN}

class LinearWave extends Wave {
  DIRECTION dir;
  public LinearWave (int v, int min, int max, int s, color c, DIRECTION d) {
    super(v,min,max,s,c);
    dir = d;
  }
  
  void plot (float x, float y, PGraphics layer) {
    layer.stroke(c,map(value,min,max,200,0));
    layer.strokeWeight(map(value,min,max,200,0));
    layer.noFill();
    if (dir==DIRECTION.UP || dir==DIRECTION.DOWN) layer.line(0,y+value,layer.width,y+value);
    else layer.line(x+value,0,x+value,layer.height);
  }
}

class Button {
  float defaultValue;
  float value;
  float target;
  float speed;
  
  ArrayList<Wave> waves;
  
  public Button () {
    defaultValue = 300;
    value = 300;
    waves = new ArrayList<Wave>();
  }
  
  void handle () {
    for (Wave w : waves) w.handle();
    for (int i=waves.size()-1; i>=0; i--) waves.get(i).removeFrom(waves);
    
    if (abs(value-target)>10) value += speed;
  }
  
  void plot (float x, float y, PGraphics layer) {
    for (int i=0; i<waves.size(); i++) waves.get(i).plot(x,y,layer);
    
    layer.fill(map(defaultValue-value,-100,100,255,0),map(defaultValue-value,-100,100,0,255),255,map(abs(defaultValue-value),0,100,0,200));
    //layer.fill(255,map(abs(defaultValue-value),0,100,0,255));
    //layer.fill(slide(color(255, 0, 255, 33), color(0, 255, 255, 33), map(abs(defaultValue-value), 0, 100, 0, 1)));
    layer.stroke(255,200);
    layer.strokeWeight(20);
    layer.ellipse(x,y,(int)value,(int)value);
  }
  
  void setValue (float v, color c) {
    target = v;
    speed = (target-value)/15.0;
    if (waves.size()>10) waves.remove(0);
    waves.add(new RadialWave((int)v,0,1600,8,c));
  }
}
