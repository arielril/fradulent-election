/* beliefs */


/* desires/goals */ 


/* plans */

+!start_fraud[scheme(F)]
  <- .print("starting fraud");
  .
-!start_fraud[scheme(F)]
  <- .print("failed to start fraud");
  .


// when a voter anounces that it is waiting on line...
// influence to commit fraud
+waiting(Voter)[source(_)]
  : candidate(CName) 
  <- .print("new possible victm to commit fraud - ", Voter);
    .send(Voter, tell, change_candidate(CName));
  .




{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }








