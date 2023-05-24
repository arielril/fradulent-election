/* beliefs */
discovered_fraud(false).

// the candidate(CName, CNumber) belief is defined in the jcm config file


/* desires */

!configure_voting_section.


/* plans */

+!configure_voting_section
  <- .print("configuring voting section...");
    .print("searching candidates");
    .findall(Name, candidate(Name, _)[source(_)], Candidates);
    .print("registered candidates... ", Candidates);

    // wait 2 seconds for the voters to enter the line
    .wait(1000);
    .print("searching voters");
    .findall(AgName, waiting(AgName)[source(_)], Voters);
    .print("registered voters... ", Voters);

    !announce_candidates(Voters, Candidates);
  .

+!announce_candidates(Voters, Candidates) 
  : not .empty(Voters)
  <- .print("announcing the candidates");
    for ( .member(V, Voters) ) {
      for ( .member(C, Candidates) ) {
        .send(V, tell, candidate(C));
      };
    };
  .


{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
