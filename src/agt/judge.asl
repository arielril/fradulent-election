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

+!close_voting_section[scheme(F)]
  : election_status("open")
  <- .print("closing the voting section...");
    ballot_machine::close;
  .

-!close_voting_section[scheme(F)]
  : election_status("closed") & election_with_fraud("yes")
  <- .print("election was halted because of a fraud");
  .

-!close_voting_section[scheme(F)]
  <- .print("failed to close voting section...");
  .

+!analyze_fraud[scheme(F), source(_)]
  : election_status("open")
  <- ?joined(fraudulent_election_ws, _);
    .print("evaluating if there was any fraud");
    ballot_machine::computeVotesOnCandidate(paulinho_mao_cheia);
    ?election_votes_on_candidate(PaulinhoVotes);
    .print("votes on paulinho_mao_cheia = ", PaulinhoVotes);

    if ( PaulinhoVotes >= 2 ) {
      .print("[[ GOT_FRAUD ]] someone was commiting fraud!!");
      .print("closing ballot machine");
      ballot_machine::foundFraud;
      .broadcast(tell, discovered_fraud(yes));
    } else {
      .wait(500);
      !analyze_fraud[scheme(F)];
    };
  .

+!analyze_fraud[scheme(F), source(_)]
  : election_status("broken")
  <- ?joined(fraudulent_election_ws, _);
    .print("[[ GOT_FRAUD ]] the ballot machine is BROKEN!");
    ballot_machine::foundFraud;
    .broadcast(tell, discovered_fraud(yes));
  .

-!analyze_fraud[scheme(F)]
  : election_status("closed") & election_result(Result) & Result \== "N/A"
  <- .print("result? = ", Result);
    .print("there was no fraud in the election! :P");
  .

-!analyze_fraud[scheme(F)]
  <- .print("could not evaluate fraud ;(");
    .wait(300);
    !analyze_fraud[scheme(F)];
  .




{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$jacamoJar/templates/org-obedient.asl") }
