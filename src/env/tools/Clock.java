package tools;

import cartago.*;

public class Clock extends Artifact {
  boolean counting;
  final static long TICK_TIME = 100;

  void init() {
    this.counting = false;
  }

  @OPERATION
  void start() {
    if (!counting) {
      this.counting = true;
      execInternalOp("count");
    } else {
      failed("clock is already started");
    }
  }

  @OPERATION
  void stop() {
    this.counting = false;
  }

  @INTERNAL_OPERATION
  void count() {
    while (this.counting) {
      signal("tick");
      await_time(TICK_TIME);
    }
  }

}
