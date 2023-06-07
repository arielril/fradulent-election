// BallotMachine.java

package voting;

import java.util.*;
import java.util.logging.*;
import cartago.OPERATION;
import cartago.Artifact;
import jason.asSyntax.*;
import jason.asSyntax.parser.*;

public class BallotMachine extends Artifact {
    List<String> voters;
    List<String> votes;

    private Logger logger = Logger.getLogger("fraudulent_election.jcm." + BallotMachine.class.getName());

    public void init() {
        /*
         * Status:
         * - closed
         * - configured
         * - open
         */
        defineObsProperty("election_status", "closed");
        defineObsProperty("election_result", "N/A");
    }

    @OPERATION
    public void configure(Object[] candidates, Object[] voters) {
        this.voters = new ArrayList<>();
        this.votes = new ArrayList<>();

        ListTerm candidatesList = ASSyntax.createList();
        for (Object candidate : candidates) {
            try {
                candidatesList.add(ASSyntax.parseTerm(candidate.toString()));
            } catch (ParseException e) {
                System.out.println("parse error -> " + e);
            }
        }
        logger.info("candidates - " + candidatesList.toString());

        for (Object voter : voters) {
            this.voters.add(voter.toString());
        }
        logger.info("voters - " + voters.toString());

        defineObsProperty("election_candidates", candidatesList);
        getObsProperty("election_status").updateValue("configured");
    }

    @OPERATION
    public void open() {
        getObsProperty("election_status").updateValue("open");
    }

    @OPERATION
    public void vote(Object vote) {
        if (getObsProperty("election_status").getValue().equals("closed")) {
            failed("the voting section is closed");
        }

        if (voters.remove(getCurrentOpAgentId().getAgentName())) {
            this.votes.add((String) vote);
            // if (this.voters.isEmpty()) {
            // close();
            // }
        } else {
            failed("agent already voted");
        }
    }

    @OPERATION
    public boolean hasEveryoneVoted() {
        return this.voters.size() == 0;
    }

    @OPERATION
    public void close() {
        getObsProperty("election_result").updateValue(computeResults());
        getObsProperty("election_status").updateValue("closed");
    }

    public String computeResults() {
        HashMap<String, Integer> votesMap = new HashMap<String, Integer>();

        for (String vote : this.votes) {
            if (!votesMap.containsKey(vote)) {
                votesMap.put(vote, 0);
            }

            votesMap.put(vote, votesMap.get(vote) + 1);
        }

        logger.info("Votes -> " + votesMap.toString());

        String winner = "N/A";
        Integer winnerVotes = 0;

        for (Map.Entry<String, Integer> r : votesMap.entrySet()) {
            if (r.getValue() > winnerVotes) {
                winnerVotes = r.getValue();
                winner = r.getKey();
            }
        }

        logger.info("Election result -> Candidate: " + winner + " (" + winnerVotes + ")");
        return winner;
    }

    @OPERATION
    public void foundFraud() {
        defineObsProperty("election_with_fraud", "yes");
        if (getObsProperty("election_status") != null) {
            getObsProperty("election_status").updateValue("closed");
        } else {
            defineObsProperty("election_status", "closed");
        }
    }

    @OPERATION
    public void computeVotesOnCandidate(Object candidate) {
        int res = 0;

        String candidateString = (String) candidate;
        for (String vote : this.votes) {
            if (vote.equals(candidateString)) {
                res += 1;
            }
        }

        if (getObsProperty("election_votes_on_candidate") != null) {
            getObsProperty("election_votes_on_candidate").updateValue(res);
        } else {
            defineObsProperty("election_votes_on_candidate", res);
        }
    }

}
