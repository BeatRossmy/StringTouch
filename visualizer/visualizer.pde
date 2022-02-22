import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

int [] values;

void setup() {
  size(300, 800);
  noStroke();
  fill(255,0,0);
  
  values = new int[6];

  MidiBus.list();
  myBus = new MidiBus(this, "Teensy MIDI", "Teensy MIDI"); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
}

void draw() {
  background(255);
  for (int i=0; i<6; i++) {
    int d = values[i];
    color c = color(values[i]*2,0,255-(values[i]*2));
    fill(c);
    ellipse(75+(i%2)*150,100+(i/2)*300,d,d);
  }
}

int[] targetMap = new int [] {0,2,4,1,3,5};


void controllerChange(int channel, int number, int value) {
  values[targetMap[number]] = value;
}
