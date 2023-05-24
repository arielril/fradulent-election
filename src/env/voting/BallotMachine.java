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
    int timeout;

    private Logger logger = Logger.getLogger("fraudulent_election.jcm." + BallotMachine.class.getName());

    public void init() {
        /*
         * Status:
         * - closed
         * - configured
         * - open
         */
        defineObsProperty("status", "closed");
    }

    @OPERATION
    public void configure(Object[] candidates, Object[] voters, int timeout) {
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

        this.timeout = timeout;
        defineObsProperty("candidates", candidatesList);
        defineObsProperty("deadline", this.timeout);
        getObsProperty("status").updateValue("configured");
    }

    @OPERATION
    public void open() {
        getObsProperty("status").updateValue("open");
    }

    @OPERATION
    public void vote(Object vote) {
        if (getObsProperty("status").getValue().equals("closed")) {
            failed("the voting section is closed");
        }

        if (voters.remove(getCurrentOpAgentId().getAgentName())) {
            this.votes.add((String) vote);
            if (this.voters.isEmpty()) {
                close();
            }
        } else {
            failed("agent already voted");
        }
    }

    @OPERATION
    public void close() {
        defineObsProperty("election_result", computeResults());
        getObsProperty("status").updateValue("close");
    }

    public String computeResults() {
        HashMap<String, Integer> result = new HashMap<String, Integer>();

        for (String vote : this.votes) {
            if (!result.containsKey(vote)) {
                result.put(vote, 0);
            }

            result.put(vote, result.get(vote) + 1);
        }

        System.out.println("Voting result -> " + result.toString());

        String winner = "";
        Integer winnerVotes = 0;

        for (Map.Entry<String, Integer> r : result.entrySet()) {
            if (r.getValue() > winnerVotes) {
                winnerVotes = r.getValue();
                winner = r.getKey();
            }
        }

        return winner;
    }

}
