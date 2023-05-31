/* beliefs */
discovered_fraud(false).

// the candidate(CName, CNumber) belief is defined in the jcm config file


/* desires */


/* plans */

+!configure_voting_section[scheme(F)]
  <- .print("configuring voting section...");
    .print("searching candidates");
    .findall(Name, candidate(Name, _)[source(_)], Candidates);
    .print("registered candidates... ", Candidates);

    // wait 2 seconds for the voters to enter the line
    .wait(2000);
    .print("searching voters");
    .findall(AgName, waiting(AgName)[source(_)], Voters);
    .print("registered voters... ", Voters);

    !announce_candidates(Voters, Candidates);

    ballot_machine::configure(Candidates, Voters);
  .

+!announce_candidates(Voters, Candidates) 
  : not .empty(Voters)
  <- .print("announcing the candidates");
    for ( .member(C, Candidates) ) {
      .broadcast(tell, candidate(C));
    };
  .


+!open_voting_section[scheme(F)]
  <- .print("openning the voting section...");
    ballot_machine::open;
  .

+!close_voting_section[scheme(F), source(_)]
  <- .print("waiting for every voter to vote...");
    .print("closing the voting section...");
    ballot_machine::close;
  .



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
