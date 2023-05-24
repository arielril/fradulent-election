/* initial beliefs */
start.

/* initial goals */
!commit_fraud.


/* plans */
+!start <- .println("i'll commit fraud!!!");
  commit_fraud.

+!commit_fraud 
  <- .println("i'm commiting fraud :P");
    ?joined(ballot_machine_ws, BMId);
  .




{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
