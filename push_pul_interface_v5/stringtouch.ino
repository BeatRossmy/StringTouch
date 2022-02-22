#define HWSERIAL Serial3

#include <vector>
#include "event.h"
#include "eventstack.h"
#include "action.h"

struct VALUE {
  float ref;
  float value;
  int pin;
  void init (int p) {
    pin = p;
    ref = touchRead(pin);
    for (int i = 0; i < 1000; i++) {
      ref = ref * 0.9 + touchRead(pin) * 0.1;
      delay(1);
    }
    value = ref;
  }
  void read () {
    value = 0.9 * value + 0.1 * touchRead(pin);
    //if (abs(value-ref)<1.5) ref = 0.99*ref+0.01*value;
  }
  float get () {
    return value - ref;
  }
};

EventStack stack;
EventStack touchStack;

void handleDownStrum () {
  usbMIDI.sendControlChange(30,30,10);
}
Action downStrum = Action(400, handleDownStrum);

void handleUpStrum () {
  usbMIDI.sendControlChange(40,40,10);
}
Action upStrum = Action(400, handleUpStrum);

void handleLeftSlide () {
  usbMIDI.sendControlChange(10,10,10);
}
Action leftSlide = Action(400,handleLeftSlide);

void handleRightSlide () {
  usbMIDI.sendControlChange(20,20,10);
}
Action rightSlide = Action(400,handleRightSlide);

/*
bool containsSTRINGsInOrder (STRING a, STRING b, STRING c) {
  long ta = stack.timeStampOfFirst(a);
  long tb = stack.timeStampOfFirst(b);
  long tc = stack.timeStampOfFirst(c);
  return (ta < tb && tb < tc && ta != -1 && tb != -1 && tc != -1);
}*/

STRING patternA [] = {TOP, MIDDLE, BOTTOM};
STRING patternA2 [] = {TOP, BOTTOM};
STRING patternA3 [] = {MIDDLE, BOTTOM};
STRING patternA4 [] = {TOP, MIDDLE};

STRING patternB [] = {BOTTOM, MIDDLE, TOP};
STRING patternB2 [] = {BOTTOM, TOP};
STRING patternB3 [] = {MIDDLE, TOP};
STRING patternB4 [] = {BOTTOM, MIDDLE};

void lookForEventPatterns () {
  if (stack.containsPattern(3, patternA) || stack.containsPattern(2, patternA2) || stack.containsPattern(2, patternA3) || stack.containsPattern(2, patternA4)) downStrum.trigger();
  if (stack.containsPattern(3, patternB) || stack.containsPattern(2, patternB2) || stack.containsPattern(2, patternB3) || stack.containsPattern(2, patternB4)) upStrum.trigger();
  if (touchStack.isSlide(MIDDLE)>0) leftSlide.trigger();
  if (touchStack.isSlide(MIDDLE)<0) rightSlide.trigger();
}

#include "helperFunctions.h"

#include "sensorArray.h"

SensorArray sensors;

elapsedMillis timer, timer2;

VALUE t1, t2, t3, t4, t5, t6, t7, t8;
VALUE* touchValues [] = {&t1,&t2,&t3,&t4,&t5,&t6,&t7,&t8};
int handPos;
bool hand;

void setup() {
  stack.init();
  touchStack.init();
  sensors.init();
  
  t8.init(0);
  t7.init(1);
  t6.init(3);
  t5.init(4);
  t4.init(15);
  t3.init(16);
  t2.init(22);
  t1.init(23);
  
  pinMode(13, OUTPUT);
  digitalWrite(13, HIGH);

  //usbMIDI.sendNoteOn(30,20,10);
}

// ERRORS:
// b 5 s 3 missing magnet?

void loop() {
  sensors.read();
  for (int i=0; i<8; i++) touchValues[i]->read();

  int t = 10;
  if (timer >= t) {
    timer -= t;
    lookForEventPatterns();
    stack.removeOldEvents();
    touchStack.removeOldEvents();
    sensors.printMIDI();
  }

  t = 100;
  if (timer2 >= t) {
    timer2 -= t;
    
    float sum = 0;
    float counter = 0;
    for (int i=0; i<8; i++) {
      if (touchValues[i]->get()>2) {
        sum+=(i+1);
        counter++;
      }
    }

    /*
    if (t1.get() > 2) {
      sum += 1;
      counter++;
    }
    if (t2.get() > 2) {
      sum += 2;
      counter++;
    }
    if (t3.get() > 2) {
      sum += 3;
      counter++;
    }
    if (t4.get() > 2) {
      sum += 4;
      counter++;
    }
    if (t5.get() > 2) {
      sum += 5;
      counter++;
    }
    if (t6.get() > 2) {
      sum += 6;
      counter++;
    }
    if (t7.get() > 2) {
      sum += 7;
      counter++;
    }
    if (t8.get() > 2) {
      sum += 8;
      counter++;
    }*/
    
    if (counter > 0) {
      int pos = (int)(sum / counter);
      if (pos!= handPos) {
        handPos = pos;
        usbMIDI.sendControlChange(0,handPos,2);
        touchStack.add({handPos, PUSH_ON, millis(), MIDDLE});
      }
    }

    bool handClose = false;
    for (int i=0; i<8; i++) if (touchValues[i]->get()>2) handClose = true;
    if (hand!=handClose) {
      hand = handClose;
      if (hand) usbMIDI.sendNoteOn(100,100,3);  
      else usbMIDI.sendNoteOff(100,0,3);  
    }
    
  }

  delayMicroseconds(500);
}

