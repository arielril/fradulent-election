/* beliefs */

// the vote_for belief comes from the jcm config file

/* desires/goals */

!waiting_in_line.

/* plans */

+!waiting_in_line
  <- ?joined(fraudulent_election_ws, _);
    .my_name(AgName);
    .print("my name is ", AgName, ", i'm waiting to vote...");
    // tell the judge that the agent is waiting in line
    .send(judge, tell, waiting(AgName));
  .

+!voters_vote[scheme(F)]
  : vote_for(C) & candidate(C)
  <- .print("voter ", .my_name(self), " is going to vote for [", C, "]");
    ballot_machine::vote(C);
  .

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
