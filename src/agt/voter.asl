/* beliefs */

// the vote_for belief comes from the jcm config file

/* desires/goals */

!waiting_in_line.

/* plans */

+!waiting_in_line
  <- .my_name(AgName);
    .print("my name is ", AgName, ", i'm waiting to vote...");
    // send everyone a message saying that the agent is waiting in line
    .broadcast(tell, waiting(AgName));
  .

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
