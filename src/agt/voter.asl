
/* initial beliefs and rules */
candidate("jose", 1).
candidate("paulo", 10).
candidate("jorge", 30).
candidate("cassiano", 35).
candidate("maria", 15).
candidate("paula", 33).

// i believe that I want to vote for some candidate
vote_for(C).

/* initial goals */
// every voter will wait in line until it's time to vote
+!start : true <- .print("I'm a voter").
!at_waiting_line.



/* plans */
// +!vote_for(C) : is_section_open

+!at_waiting_line[source(A)] 
  <- .print("Agent ", A, " is wating in the voting line").


+!vote 
  // get the name of the ballot machine
  <- ?goalArgument(_, ballot, "ballot_machine_id", BMName);
    // check if the voter has joined the workspace of the ballot machine
    ?joined(ballot_machine_ws, BMId);
    lookupArtifact(BMName, BMId)[wid(BMId)];
    // focus in the ballot machine
    ballot_machine::focus(BMId)[wid(BMId)];
  .




{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
