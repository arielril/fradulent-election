/* initial beliefs and rules */
has_fraud(false).

/* initial goals */
!start.

+!start : true <- .print("I'm the judge").

/* plans */

// start the voting section
+!open_voting_section[scheme(S)]
  <- // get all candidates
      .findall(C, vote_for(C)[source(_)], Candidates);
      // get all voters
      .findall(A, play(A, voter, _), Voters);
      // initialize the ballot machine
      ballot_machine::open(Candidates, Voters);
      .print("Candidates: ", Candidates, " \n Voters: ", Voters);

      // update the organization goal to "vote"
      setArgumentValue(ballot, ballot_machine_id, b1)[artifact_name(S)];
  .

+!close_voting_section
  <- ?ballot_machine::election_result(W);
      .println("The winner candidate was.... ", W);
  .

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
