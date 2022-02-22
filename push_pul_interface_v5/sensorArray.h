enum STATE {PUSHED, PULLED, NONE};

struct Sensor {
  int id;
  int pin;
  float val;
  float ref;
  float out;
  STATE state = NONE;
  int ccValue;

  void setRef () {
    ref = val;
  }
  void read () {
    val = (float)analogRead(pin) * 0.1 + val * 0.9;
    out = (val - ref);
    out = out * out * out;
    handleNewValue();
  }

  /*void init () {
    ref = (float)analogRead(pin);
    for (int i = 0; i < 1000; i++) {
      ref = ref * 0.9 + (float)analogRead(pin) * 0.1;
      delay(1);
    }
    value = ref;
  }*/

  void printCC () {
    int v = constrain((int)map(out,-300,300,0,127),0,127);
    if (v!= ccValue) {
      ccValue = v;
      usbMIDI.sendControlChange(id,(byte)ccValue,1);
    }
  }

  void handleNewValue () {
    STRING s = intToSTRING(id % 3);
    if (state == NONE && out < -15) {
      state = PUSHED;
      usbMIDI.sendNoteOn(id,100,1);
      stack.add({id, PUSH_ON, millis(), s});
    }
    else if (state == PUSHED && out > -7.5) {
      state = NONE;
      usbMIDI.sendNoteOff(id,0,1);
      stack.add({id, PUSH_OFF, millis(), s});
    }
    if (state == NONE && out > 15) {
      state = PULLED;
      usbMIDI.sendNoteOn(id,100,2);
      stack.add({id, PULL_ON, millis(), s});
    }
    else if (state == PULLED && out < 7.5) {
      state = NONE;
      usbMIDI.sendNoteOff(id,0,2);
      stack.add({id, PULL_OFF, millis(), s});
    }
  }
};

int pinList [] = {14,17,18,19,20,21};

class SensorArray {
  private:
    const int A = 12;
    const int B = 11;
    const int C = 10;
    Sensor sensorArray [36];

  public:
    SensorArray () {}

    void init () {
      pinMode(A, OUTPUT);
      pinMode(B, OUTPUT);
      pinMode(C, OUTPUT);

      //for (int i = 0; i < 36; i++) sensorArray[i] = {i, (i / 6) + 14};
      for (int i = 0; i < 36; i++) sensorArray[i] = {i, pinList[(i / 6)]};

      for (int i = 0; i < 1000; i++) {
        read();
        delay(1);
      }

      for (int i = 0; i < 36; i++) sensorArray[i].setRef();
    }

    void read () {
      for (int sensor = 0; sensor < 6; sensor++) {
        // set multiplexer;
        digitalWrite(A, (sensor == 1 || sensor == 3 || sensor == 5 || sensor == 7) ? HIGH : LOW);
        digitalWrite(B, (sensor == 2 || sensor == 3 || sensor == 6 || sensor == 7) ? HIGH : LOW);
        digitalWrite(C, (sensor == 4 || sensor == 5 || sensor == 6 || sensor == 7) ? HIGH : LOW);
        // read sensors from all six boards
        for (int board = 0; board < 6; board++) sensorArray[board * 6 + sensor].read();
      }
    }

    /*void printRaw () {
      for (int i = 0; i < 36; i++) {
        Serial.print(sensorArray[i].out);
        Serial.print((i < 35) ? "," : "\n");
      }
    }*/

    void read (int board, int sensor) {
      digitalWrite(A, (sensor == 1 || sensor == 3 || sensor == 5 || sensor == 7) ? HIGH : LOW);
      digitalWrite(B, (sensor == 2 || sensor == 3 || sensor == 6 || sensor == 7) ? HIGH : LOW);
      digitalWrite(C, (sensor == 4 || sensor == 5 || sensor == 6 || sensor == 7) ? HIGH : LOW);
      sensorArray[board * 6 + sensor].read();
    }

    void printMIDI () {
      for (int i = 0; i < 36; i++) sensorArray[i].printCC();
    }
};
