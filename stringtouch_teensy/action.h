class Action {
  private:
    void (&function) ();
    unsigned long lastTriggerTime = 0;
    unsigned long waitTime = 100;
  public:
    Action (unsigned long w, void (&ref) ()) : waitTime(w), function(ref) {}
    void trigger () {
      if (millis() - lastTriggerTime > waitTime) {
        lastTriggerTime = millis();
        function();
      }
    }
};

