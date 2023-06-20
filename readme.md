# Fraudulent Election

## Agents

### Voter

> Beliefs
- Want to vote in a candidate

> Goals
- Vote in a desired candidate

> Plans
1. Go to the Ballot Box
2. Vote in the desired candidate
3. Go away from the ballot box

### Polling Judge

> Beliefs
- The election must not have a fraud

> Desires
- Configure the voting section
  - list voters
  - list candidates
  - announce candidates
- Open the voting section
- Wait until all voters have voted
- Compute the result
- Show the result

> Goals
- Check on the ballot box
- Check on the voters waiting line

> Plans


### Bad Influence

> Beliefs
- Want to make the voters to commit a fraud
- Want to make the voters to vote for their candidate
- Want to make the voters to break the ballot box

> Goals
- Change the beliefs of a voter to vote for their candidate
- Change the beliefs of a voter to break the ballot box

> Plans
1. Approach a voter (get closer to)
2. Start speaking to the voter (this action must have a verification that checks where the judge is, if he is close/far from the influencer)
    1. Influence the voter to vote for their candidate/brake the ballot box
3. Go away from the voter

## General execution

normal election

1. voters wait in line
2. judge configs the section
2.1. list all voters
2.2. list all candidates
2.3. initialize voting section
3. one voter at a time go to vote
4. after all voters have voted, judge close the section
5. judge shows the election result

----

in parallel...

the bad influence

1. wait a voter to enter the line
2. when a voter get in the line...
2.1. try to influence the voter
2.2. if the voter is influenced - success
2.3. otherwise - go to the another

## Environment Items

### Candidate
- Receive votes from voters


## Simulation Results

### normal voter

- how many frauds were discovered? 8/10
- which was the most fraudulent action? 
  - 4 broken ballots
  - 4 vote change
- how many voters were influenced to change their vote? avg 3
- how many voters were influenced to break the ballot machine? avg 3
 
### random voter

- how many frauds were discovered? 9/10
- which was the most fraudulent action? 
  - 8 broken ballots
  - 1 vote changed 
- how many voters were influenced to change their vote? avg 2
- how many voters were influenced to break the ballot machine? avg 2
