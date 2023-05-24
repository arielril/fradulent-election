!test_clock.


+!test_clock 
  <- makeArtifact("votingClock", "tools.Clock", [], Id);
    focus(Id);
    +n_ticks(0);
    start;
    println("voting clock started");
  .

@plan1
+tick : n_ticks(10)
  <- stop;
    println("voting clock stopped");
  .

@plan2 [atomic]
+tick : n_ticks(N)
  <- -+n_ticks(N+1);
    println("voting clock tick percieved!");

