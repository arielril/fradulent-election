/* initial beliefs and rules */
has_fraud(false).

/* initial goals */
// !start.

+start 
  <- .print("I'm the judge");
    createScheme(sc, open_section, AId);
    focus(AId);
    addScheme(sc);

    resetGoal(voting);
  .

+open_voting_section <- .print("suupppp").


/* plans */

// start the voting section
+!open_voting_section[scheme(S)]
  <- 
      // get all candidates
      .print("searching all candidates");
      .findall(C, vote_for(C)[source(_)], Candidates);
      // get all voters
      .print("searching all voters");
      .findall(A, play(A, voter, _), Voters);
      // initialize the ballot machine
      .print("initiating ballot machine");
      ballot_machine::open(Candidates, Voters, 10000);
      .print("Candidates: ", Candidates, " \n Voters: ", Voters);

      // update the organization goal to "vote"
      setArgumentValue(ballot, ballot_machine_id, b1)[artifact_name(S)];
      .print("The voting section is now openned!");
      init_voting_clock(10000);
  .

+!close_voting_section
  <- ?ballot_machine::election_result(W);
      .println("The winner candidate was.... ", W);
  .

+!init_voting_clock(TIMEOUT)
  <- makeArtifact("votingClock", "tools.Clock",[], Id);
    focus(Id);
    +tick_clock(TIMEOUT);
    votingClock::start;
    println("election clock started...");
  .

@tickClock1
+!tick_clock(MAX_TICK) : MAX_TICK==0
  <- votingClock::stop;
    println("election has ended");
  .

@tickClock2 [atomic]
+!tick_clock(MAX_TICK) : tick(MAX_TICK)
  <- -+tick(MAX_TICK-1);
    println("clock is ticking...");
  .


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
