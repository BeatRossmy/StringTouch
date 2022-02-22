import themidibus.*;
MidiBus myBus;

Interface ui;
PGraphics layer;
MAP map;
boolean shift;
enum MODE {RAW,UI,FOLLOW,GESTURES}
MODE mode;

void setup () {
  size(displayWidth, displayHeight, P3D);
  ui = new Interface();
  layer = createGraphics(2400, 1200);
  map = new MAP();
  MidiBus.list();
  myBus = new MidiBus(this, "Teensy MIDI", "Teensy MIDI");
  mode = MODE.UI;
}

void draw () {
  ui.handle();
  background(0);
  if (mode==MODE.RAW) ui.plotRawValues(layer);
  if (mode==MODE.UI) ui.plotInterface(layer);
  if (mode==MODE.FOLLOW) ui.plotFollow(layer);
  if (mode==MODE.GESTURES) ui.plotGestures(layer);
  map.show(layer);
  map.handle();
}

void noteOn(int channel, int pitch, int velocity) {
  println("!");
  if (pitch%3==0 && channel==0) ui.t.setValue(200,color(0,255,255));
  if (pitch%3==0 && channel==1) ui.t.setValue(400,color(255,0,255));
  if ((pitch-1)%3==0 && (pitch-1)/3<6 && channel==0) ui.l.setValue(200,color(0,255,255));
  if ((pitch-1)%3==0 && (pitch-1)/3<6 && channel==1) ui.l.setValue(400,color(255,0,255));
  if ((pitch-1)%3==0 && (pitch-1)/3>5 && channel==0) ui.r.setValue(200,color(0,255,255));
  if ((pitch-1)%3==0 && (pitch-1)/3>5 && channel==1) ui.r.setValue(400,color(255,0,255));
  if ((pitch-2)%3==0 && channel==0) ui.b.setValue(200,color(0,255,255));
  if ((pitch-2)%3==0 && channel==1) ui.b.setValue(400,color(255,0,255));
  
  if (channel==2) ui.setHand(true);
}

void noteOff(int channel, int pitch, int velocity) {
  if (pitch%3==0 && channel==0) ui.t.setValue(300,color(255));
  if (pitch%3==0 && channel==1) ui.t.setValue(300,color(255));
  if ((pitch-1)%3==0 && (pitch-1)/3<6 && channel==0) ui.l.setValue(300,color(255));
  if ((pitch-1)%3==0 && (pitch-1)/3<6 && channel==1) ui.l.setValue(300,color(255));
  if ((pitch-1)%3==0 && (pitch-1)/3>5 && channel==0) ui.r.setValue(300,color(255));
  if ((pitch-1)%3==0 && (pitch-1)/3>5 && channel==1) ui.r.setValue(300,color(255));
  if ((pitch-2)%3==0 && channel==0) ui.b.setValue(300,color(255));
  if ((pitch-2)%3==0 && channel==1) ui.b.setValue(300,color(255));
  
  if (channel==2) ui.setHand(false);
}

void controllerChange(int channel, int number, int value) {
  if (channel==9 && number==10) ui.triggerLeftSlide();
  if (channel==9 && number==20) ui.triggerRightSlide();
  if (channel==9 && number==30) ui.triggerDownStrum();
  if (channel==9 && number==40) ui.triggerUpStrum();
  
  if (channel==1) ui.setCenter(value);
  if (channel == 0) ui.setRawValue(number,value);
}


void keyPressed () {
  if (key=='s') map.save("settings.json");
  if (key=='r') map.resetCorners();
  if (key=='v') map.toggleVisible();
  
  if (key=='4') mode = MODE.GESTURES;
  if (key=='3') mode = MODE.FOLLOW;
  if (key=='2') mode = MODE.UI;
  if (key=='1') mode = MODE.RAW;
}
  /*
  
  if (keyCode == SHIFT) shift = true;
  
  if (!shift && keyCode == LEFT) ui.l.setValue(400,color(255,0,0));
  if (shift && keyCode == LEFT) ui.l.setValue(200,color(0,0,255));
  if (!shift && keyCode == RIGHT) ui.r.setValue(400,color(255,0,0));
  if (shift && keyCode == RIGHT) ui.r.setValue(200,color(0,0,255));
  if (!shift && keyCode == UP) ui.t.setValue(400,color(255,0,0));
  if (shift && keyCode == UP) ui.t.setValue(200,color(0,0,255));
  if (!shift && keyCode == DOWN) ui.b.setValue(400,color(255,0,0));
  if (shift && keyCode == DOWN) ui.b.setValue(200,color(0,0,255));
  
  
  
  if (key==' ') ui.triggerDownStrum();
}

void keyReleased () {
  if (keyCode == SHIFT) shift = false;
  //if (keyCode == DOWN || keyCode == UP || keyCode == LEFT || keyCode == RIGHT) 
}
*/
