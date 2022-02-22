//template<typename T>
class EventStack {
  private:
    const int size = 30;
    std::vector <EVENT> stack =  std::vector <EVENT>(size);

  public:
    void init () {
      for (int i = size - 1; i >= 0; i--) stack.erase(stack.begin() + i);
    }

    void add (EVENT e) {
      if (stack.size() < size) {
        stack.push_back(e);
        //e.print();
      }
    }

    EVENT get (int i) {
      return stack[(i%getSize())];  
    }

    int getSize () {
      return stack.size();
    }

    // ERRORS BY PASSING VECTORS? Maybe not???
    std::vector<EVENT> getAll (STRING s) {
      std::vector<EVENT> out;
      for (int i = 0; i < size; i++) if (stack[i].string == s) out.push_back(stack[i]);
      return out;
    }
    std::vector<EVENT> getAll (ACTION a) {
      std::vector<EVENT> out;
      for (int i = 0; i < size; i++) if (stack[i].action == a) out.push_back(stack[i]);
      return out;
    }
    std::vector<EVENT> getAll (unsigned long timestamp, long offset) {
      std::vector<EVENT> out;
      for (int i = 0; i < size; i++) if (stack[i].timestamp > timestamp - offset && stack[i].timestamp < timestamp + offset) out.push_back(stack[i]);
      return out;
    }

    int isSlide (STRING s) {
      std::vector<EVENT> events = getAll(s);
      if (events.size()>2) {
        if ((events[0].sensorID < events[1].sensorID && events[1].sensorID < events[2].sensorID)) return 1;
        if ((events[0].sensorID > events[1].sensorID && events[1].sensorID > events[2].sensorID)) return -1;
      }
      
      return 0;  
    }

    long timeStampOfFirst (STRING s) {
      //for (int i = 0; i < size; i++) if (stack[i].string == s && stack[i].isON()) return (long)stack[i].timestamp;
      for (int i = 0; i < getSize(); i++) if (stack[i].string == s && stack[i].isON()) return (long)stack[i].timestamp;
      return -1;
    }

    void removeOldEvents () {
      for (int i = getSize() - 1; i >= 0; i--) {
        if (millis() - stack[i].timestamp > 300) {
          stack.erase(stack.begin() + i);
        }
      }
    }

    bool containsPattern (int length, STRING* pattern) {
      int counter = 0;
      for (int i=0; i<getSize(); i++) {
        if (stack[i].isON() && stack[i].string==pattern[counter]) counter++;
        if (counter==length) return true;
      }
      return false;
    }
};
