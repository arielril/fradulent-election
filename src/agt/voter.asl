/* beliefs */
ready_to_vote("no").
chance_to_fraud(0.5).

// the vote_for belief comes from the jcm config file

/* desires/goals */

!waiting_in_line.

/* plans */

+!waiting_in_line
  <- .print("joining fraudulent election");
    ?joined(fraudulent_election_ws, _);
    .print("joined fraudulent election");
    .my_name(AgName);
    .print("my name is ", AgName, ", i'm waiting to vote...");
    // tell the judge that the agent is waiting in line
    .broadcast(tell, waiting(AgName));
  .

-!waiting_in_line
  <- .print("could not join fraudulent election");
  .

+!voters_vote[scheme(F)]
  : ready_to_vote(RD) & RD == "yes" & vote_for(C) & candidate(C)
  <- ?joined(fraudulent_election_ws, _);
    .print("voter ", .my_name(self), " is going to vote for [", C, "]");
    ballot_machine::vote(C);
  .

+!voters_vote[scheme(F)]
  : ready_to_vote(RD) & RD \== "yes" & vote_for(C) & candidate(C)
  <- ?joined(fraudulent_election_ws, _);
    WaitTime = math.ceil(math.random(15));
    !go_and_vote(WaitTime)[scheme(F)];
  .


-!voters_vote[scheme(F)]
  : vote_for(C) & candidate(C)
  <- .print("could not vote at all");

  .
  

+!go_and_vote(WaitTime)[scheme(F)]
  : WaitTime > 0
  <- .print("going to vote");
    .print("wait time = ", WaitTime);
    .wait(WaitTime * 100);
    !go_and_vote(WaitTime - 1)[scheme(F)];
  .

+!go_and_vote(WaitTime)[scheme(F)]
  <- .print("going to vote");
    -+ready_to_vote("yes");
    !voters_vote[scheme(F)];
  .

-!go_and_vote(WaitTime)[scheme(F)]
  <- .print("failed to move to the ballot machine");
  .

+change_candidate(NewCandidate)[source(bad_influence)]
  <- .print("received a new candidate to vote for... ", NewCandidate);
    ShouldICommitFraud = math.random;
    .print("ShouldICommitFraud = ", ShouldICommitFraud);
    ?chance_to_fraud(ChanceToCommitFraud);
    if (ShouldICommitFraud > ChanceToCommitFraud) {
      .print("[[ FRAUD ]] changing my vote to ", NewCandidate);
      -+vote_for(NewCandidate);
    };
  .

+discovered_fraud(R)[source(judge)]
  : R == yes
  <- .print("someone commited fraud, election halted...");
    .drop_all_intentions;
  .


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
