enum ACTION {PUSH_ON, PUSH_OFF, PULL_ON, PULL_OFF,TOUCH};

enum STRING {TOP, MIDDLE, BOTTOM};

STRING intToSTRING (int i) {
  if (i==0) return TOP;
  if (i==1) return MIDDLE;
  return BOTTOM;
}

struct EVENT {
  int sensorID;
  ACTION action;
  unsigned long timestamp;
  STRING string;
  bool processed = false;
  
  /*void print () {
    Serial.print(sensorID);
    Serial.print(" ");
    Serial.print(action);  
    Serial.print(" ");
    Serial.println(timestamp);
    Serial.println();
  }*/
  bool matchesWith (EVENT e) {
    if (e.action == PUSH_OFF && action == PUSH_ON) return true;
    if (e.action == PULL_OFF && action == PULL_ON) return true;
    return false;  
  }

  bool isON () {
    return (action==PUSH_ON || action==PULL_ON);  
  }
};

bool isON (ACTION a) {
  return (a==PUSH_ON || a==PULL_ON);  
}

