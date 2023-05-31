/* beliefs */

// the vote_for belief comes from the jcm config file

/* desires/goals */

!waiting_in_line.

/* plans */

+!waiting_in_line
  <- .print("joining fraudulent election");
    // ?goalArgument();
    ?joined(fraudulent_election_ws, _);
    .print("joined fraudulent election");
    .my_name(AgName);
    .print("my name is ", AgName, ", i'm waiting to vote...");
    // tell the judge that the agent is waiting in line
    .send(judge, tell, waiting(AgName));
  .

-!waiting_in_line
  <- .print("could not join fraudulent election");
  .

+!voters_vote[scheme(F)]
  : vote_for(C) & candidate(C)
  <- ?joined(fraudulent_election_ws, _); 
    .print("voter ", .my_name(self), " is going to vote for [", C, "]");
    ballot_machine::vote(C);
  .

-!voters_vote[scheme(F)]
  <- .print("could not vote");
  .

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
