/* beliefs */


/* desires/goals */ 


/* plans */


// when a voter anounces that it is waiting on line...
// influence to commit fraud
+waiting(Voter)[source(_)]
  // : candidate(CName) 
  <- .print("new possible victm to commit fraud - ", Voter);
    !influence_to_fraud(Voter);
  .

+!influence_to_fraud(Voter)
  <- .print("influencing to commit fraud ", Voter);
    C = math.random;
    if (C < 0.4) {
      !influence_to_break_ballot_machine(Voter);
    } else {
      !influence_to_change_candidate(Voter);
    };
  .

+!influence_to_change_candidate(Voter)[source(self)]
  : candidate(CName)[source(self)]
  <- .print("influencing ", Voter, " to change candidates...");
    .send(Voter, tell, change_candidate(CName));
  .

+!influence_to_break_ballot_machine(Voter)[source(self)]
  <- .print("influencing ", Voter, " to break the ballot machine");
    .send(Voter, tell, break_ballot_machine);
  .


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }








