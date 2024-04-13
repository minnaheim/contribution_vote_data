#import "thesis_template.typ": *
#import "common/cover.typ": *
#import "common/titlepage.typ": *
#import "thesis_typ/disclaimer.typ": *
#import "thesis_typ/acknowledgement.typ": *
#import "thesis_typ/abstract_en.typ": *
#import "thesis_typ/abstract_de.typ": *
#import "common/metadata.typ": *

#titlepage(
  title: titleEnglish,
  // titleGerman: titleGerman,
  degree: degree,
  program: program,
  supervisor: supervisor,
  advisors: advisors,
  author: author,
  startDate: startDate,
  submissionDate: submissionDate,
)

#disclaimer(
  title: titleEnglish,
  degree: degree,
  author: author,
  submissionDate: submissionDate,
)

#abstract_en()

#show: project.with(
  title: titleEnglish,
  titleGerman: titleGerman,
  degree: degree,
  program: program,
  supervisor: supervisor,
  advisors: advisors,
  author: author,
  startDate: startDate,
  submissionDate: submissionDate,
)
#pagebreak()
= Introduction
- Relevance/Problem/ Motivation:
  - Koch Industries example (2016 elections)
  - consequences for democracy @Weschle_2022b
- Literature & Methods used
  - based on strattman, empirical and theoretical part, (causal identification
    strategy) use of campaign contribution and roll call data, OLS/probit
- Outline
  - first, theoretical review of campaign contribution literature, then model to
    estimate contribution effect

#pagebreak()

= Money in Politics
- why do candidates need contribution?
  - election every 2 years, in house of representatives
  - need contributions to fund campaigns
- how does money in politics work?
  - contribution types (PAC, individual)
  - contribution goals (enrichment, campaign contributions, revolving door)
    @Weschle_2022c
- consensus: spending in politics has risen over time (opensecrets sources,
  @Stratmann_2005 p.141), explained by Lott, higher in states with bigger gov.
  @Stratmann_2005 p.148

// == Legislation
// p.149 in @Stratmann_2005
// - 1994 transparency act
// - Bipartisan Campaign Reform Act of 2003
// - State regulations - contribution limits,

// == campaign contributions & elections -> less important for analysis
// - coate, if special interest contribution, less voters, more contribution (voters suspicious of favor trading) @Stratmann_2005
// - Asymmetry in effectiveness of spending, endogeneity and OVB
// - difficult to find causal effect between contributions and vote shares @Stratmann_2005 p.137-138
// - also, sometimes more campaign contributions because of tighter race, so negative correlation vote share and contribution (OVB - competition, bipartisan factors) @Stratmann_2005 p.138
// - bias stronger in house, than senate, p.138
// - spending not accurate representation for campaigning, diff. Montana and LA.

== Campaign Contributions
- why is there campaign contribution, what does it achieve? -> better election
  @Stratmann_2005 @Weschle_2022c p.24
- but no correlation between campaign spending and vote shares, @Weschle_2022c
  p.24, (also other authors who state this)
- stratmann says - correlation due to the support of similar interests, so we have
  simultaneous equation bias - p.1 @stratmann-2002
- but just saying that money doenst influence vote outcomes would be shortsighted,
  need to include other factors:
  - strategic spending, closeness of race, spending limits, etc. @Weschle_2022c p.25
  - industry specific results, specific legilastion, p.27.28 @Weschle_2022c
  - after all, there is good evidence that more campaign spending affects
    politicians and policy @Weschle_2022c p.26 (just have to consider more factors,
    different approaches?)
  - Economic Literature states that the campaign contributions received depend on:
    @stratmann-1995 p.128
    - interest of the voter base (constituency) -> SOURCE
    - PAC contributions depend on the incumbency status of legislators
    - expected closeness of outcomes
- 2 motives on what campaign donors receive in return, influence , i.e. change
  mind, or support those cands. that have yours @Weschle_2022c pp.26-28 - small
  scale contributors do follow both methods.
- correlation isnt enough, other factors influence, campaign contributions
  endogenously determined by a multitude of factors. @bronars-lott-1997 p.318
- 3 types of candidates receiving contribution, also what is the goal of the
  contributor - access to the candidate, influence elections, most likely to win
  @Stratmann_2005 p.146

== Causal Effect of Campaign Contributions on Representatives' Voting Decisions.
*Main question*: Do incumbents cater to wishes of special interest groups, bec.
of their contribution or do they get contribution because their views coincide
with the special interests groups (mind-changers)? @Stratmann_2005 p.143

\
Bronars & Lott tried to do this....
- when retire and not standing for re-election, how do they vote, on two similar
  bills. @bronars-lott-1997 two types, vote buyers, ideological sorting (if vote
  buy, change contributions & change vote is given, if ideology, then not.)
  - effect of changes in campaign contributions during a politician's last term in
    office. more to do with politician's retirement, less their
    preferences/contributions.
  - politicians should represent their ideology/votes, ideally (even without threat
    of re-election)
  - if not, politicians will deviate from constituent's wishes, cost of shirking
    decreases. p. 319
  - evidence: close races, conservative PACs to conservative candidates, and to
    shift opinion within party,etc. @Stratmann_2005 p. 147-148

\
Stratmann, 1995 - campaign contributions and votes,does the timing of
contributions matter?
- main statements: contributions from current election cycles are more relevant
  that the contributions from previous election cylces (short over long term),
  PACs conclude different contracts with representatives, not ones that are first
  contributions in one session and then votes as soon as they are voted, but
  almost simultaneous votes

\
Other studies also failed to estimate a causal effect:
- no academic consensus on the matter, contributions dont actually result in
  changes of candidates positions @stratmann-2002 p.1
- reasons for this incl.: lack of cross-sectional studies (repetition),
  simultaneous equation bias, correlation != causation, i.e. voters support
  companies who support them anyways..

\
What some of the failed studies did not inlcude...
- address this by regressing and controlling for ind. propositions, counties,
  geographical area @Stratmann_2005 p.142
- causal relationship may be found by looking at repeated votes @Stratmann_2005
  p.143-144 @stratmann-2002
- timing as important factor, increase 2 months @Stratmann_2005 p.144
- model setup: must allow for endogeneity of contributions, dichotomus nature of
  dependent vote variable (yes/no) and non-negativity of campaign comntributions.
  @stratmann-1991 p.606

Lead over to Research Design, where I incorporate these things.

#pagebreak()

= Research Design (Methodology)
== Type of Votes
* Stratmann paper defines: vote preconditions*
> repeate votes to measure change...
+ change in voting behaviour
+ winners & losers clearly defined
+ no vote before/ after repeated → aka only these votes (first vote as a
  benchmark)
+ “legislators do not typically take clearly articulated positions in their voting
  campaigns”
+ financial contributions the highest contributors per interest group (doesn’t
  hold for energy/nat resources, only about 9th, not
  1st)[https://www.opensecrets.org/industries?cycle=2020]
+ substantial amount of legislators receive money from oil&gas interest groups
  (here: 114: 406 /435, 115: 397/ 435, and 116: 408/435) ?

\

== Topic of Votes (Methane Pollution Safeguard)
*why this topic?*
- fossil fuel industry as a significant contributor of campaign contributions
- topic of incredible relevance (interest of mine?)
- relevance means large amount of votes
*why these bills?*
- repeated 6 times, where 2 are the same bill, and 5 out of 6 are exactly the same
  topic, only 113th bill is a tad bit different
- more detail on the bills, why revoted, why in different sessions...
*how to change study/assumptions from above*
- legislators do not take clear positions on topics (even before, with Glass
  Stagall Act, this was a stretch, here it is definetly given) -> individual FE to
  account for this.
- financial contributions from these industries are the highest & similar in size
  (not given here, large but not largest, not similar in size. Plot difference in
  contributions - from Opensecrets stats by industry.)
- large amount of mind changers (incl. plot) ... no, still enough

== Hypotheses
- Effects usually minimal, if significant @stratmann-2002 ?
- change in votes is positively related with change in contributions (if little)
- more time relevant votes have a more significant effect on votes, than the
  aggregate contributions, @stratmann-1995

#pagebreak()
= Data
== Data Types
=== rollcall data
- stratmann prerequisites: uses cross-sectional panel data (panel data erhoben
  multiple times, like ts.) → only works w/ similar bills
  - yes, methane bills (6 different kinds -> from LCV Scorecard)
  - why kind of votes? what kind of bills?

=== contribution data
- sources: opensecrets bulkdata campaign contributions (election data 2012-2022)
- stratmann prerequisites: votes in 1991 and 1998, contributions in 1991-1992 and
  1995-1996. use contributions from 1991-92 as a base year, since no prior
  legislation done.1991-1992 contributions taken either as reward of vote in 1991
  or as punishment,but… maybe timing or “rewarding” or “punishing” contributions
  are not momentary,so also take 1989-1990 and 1995-1996 and 1991-1992 to
  1997-1998 into account.
  - decided on taking only 6 mo. prior to vote contributions of individual and PAC
    contributions to all candidates of house, and all individual contributions in
    general.
    - show plots of when looking at 6 mo. prior to vote, which election periods are
      relevant (i.e. 2013 vote, 2014 and 2016 elections most relevant)
    - regardless of for which election the contributions were, only the time
    committed mattered @stratmann-1995, argues that if we only consider the
    contributions of the previous election cycle, not that of the current cycls,
    p.1.
    - why such strong recency focus? (because votes were
    closely paced)
  - also tried with taking entire election period...difficult if votes are within
    the same congressional session (i.e. 115th session two methane votes)

== Data Processing
=== Cleaning
==== Representatives
- imported Bioguide Representative Data (important for bio data, party, district,
  etc. weren't so extensive in rollcall and contribution data)
- *problem:* LCV scorecard did not have IDs for all votes, just the last one, only
  from 2021 onwards. Thus merge was difficult later. But... used regardless
  because predetermined which votes were pro-environmental and which were
  anti-environmental, and they only showed those which were env. related rollcalls
  which is all of what it is about.
- had I used GOVTRACK ID, i would have had an easier time with the merge of IDs,
  but the rollcall votes are not relevant, since not env. relevant, not all
  amendments to bills are environmentally related, esp. for bills such as these,
  where many insititutions are mentioned. and since environmental votes are the
  main part of the study, this was most important.
- used clean strings to remove special characters and case-sensitivtity, merge
  with fuzzyjoin to include all reps with max. distance of 4 (i.e. Micheal and
  Mike) in the names, perfect match in state, district, etc.
==== Rollcall data
- because i used LCV scorecard, already predetermined which were pro-environmental
  votes, which were anti-environmental votes, drawback of no merge with ID.
- merge together rollcall votes, determine vote changes, vote counts, to make
  analysis easier
==== Campaign Contributions
- contributions in aggregate form quite clean, in time-related form, quite
  difficult to import due to size and small RAM
- to clean bulk data, created a script used shell bec. easier access to files,
  could run it one by one, also used lazyload, then piping. -> all bec. of small
  RAM and large files avoiding to use the raw data, aka pre-cleaning makes it
  bearable but time intensive.
- in aggregate form, just need to join together relevant contributions (clean and
  dirty energy per representative)
- useful libraries like congress package not used, because did not use API to get
  data
=== Merging
- about 60% mergable based on ID
  - github df with govtrack ID, bioguide ID, opensecrets ID from reputable sources
  - from 2021 vote onwards, LCV has bioguide ID
  - why not take non-LCV votes? aka votes from govtrack, with ID? didnt have all
    roll-call votes, i.e. usually not those with relevant environmental amendments
    to bills.
- 40% of the data are representatives who were not there in 117th congress, had to
  merge manually, i.e. merge by name using fedmatch to remove special characters
  and case-sensitivtity, merge with fuzzyjoin to include all reps with max.
  distance of 4 (i.e. Micheal and Mike) in the names, perfect match in state,
  district, etc. -> insert code block?

=== Final Dataframe for Analysis
- only R, D, no Liberatrians, Independents
- only vote repeaters
- pivot longer (for FE df)

#pagebreak()

= Models
== Linear Probability Model with Individual Fixed Effects
- Altough most basic model, needed to estimate the linear relationship between ALL
  contributions and votes.
+ basic OLS
  - votes: pro-env/anti-env
  - contributions: all / grouped env/non-env
  - no FE / with FE -> differences?
+ individual OLS
  - df FE (base year, pivot longer, ∆contribution, person-FE)
  - only incl. mind changers (only variations in voting behavior are relevant
    @stratmann-2002 p.11)
  - vote change in which direction (pro -> contra env = 0?) & vice versa

== Logit / Probit (which Stratmann used)
- literature on why OLS is bad, and logit/probit is good.
- as Robustness Checks, since OLS sometimes over/underestimates @Stratmann_2005
  p.143
- Stratmann uses a conditional fixed effects logit model @Allison @Chamberlin
  @stratmann-2002
- Stratmann uses probit model (only those who changed mind)

#pagebreak()
= Results

#pagebreak()
= Discussion
== Limitations
=== differences with Strattman due to difference in legislation
== Improvements
What to improve, work on or touch upon with more resources:
- use more open source data (congress APIs
  (https://github.com/LibraryOfCongress/api.congress.gov/)), congressional data
  (https://github.com/unitedstates/congress-legislators), congress
  packages(https://github.com/IPPSR/congress)
- use API in general, for opensecrets data and co. easier to work with, more
  libraries (congress in r?)
-
- analyse difference in congress person's age, experience, etc. (are young/old
  legislators more likely to change their votes given contributions)

#pagebreak()
= Conclusion

// -------------- CRAP LINE ------------------------

// #acknowledgement()
// #abstract_de()

// #cover(
//   title: titleEnglish,
//   degree: degree,
//   program: program,
//   author: author,
// )

// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Introduce the topic of your thesis, e.g. with a little historical
//   overview.
// ]

// == Problem
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Describe the problem that you like to address in your thesis to show the
//   importance of your work. Focus on the negative symptoms of the currently
//   available solution.
// ]

// == Motivation
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Motivate scientifically why solving this problem is necessary. What kind
//   of benefits do we have by solving the problem?
// ]

// == Objectives
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Describe the research goals and/or research questions and how you address
//   them by summarizing what you want to achieve in your thesis, e.g. developing a
//   system and then evaluating it.
// ]

// == Outline
// #rect(width: 100%, radius: 10%, stroke: 0.5pt, fill: yellow)[
//   Note: Describe the outline of your thesis
// ]

// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Describe each proven technology / concept shortly that is important to
//   understand your thesis. Point out why it is interesting for your thesis. Make
//   sure to incorporate references to important literature here.
// ]
// = Related Work
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Describe related work regarding your topic and emphasize your (scientific)
//   contribution in contrast to existing approaches / concepts / workflows. Related
//   work is usually current research by others and you defend yourself against the
//   statement: “Why is your thesis relevant? The problem was al- ready solved by
//   XYZ.” If you have multiple related works, use subsections to separate them.
// ]

// == Overview
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Provide a short overview about the purpose, scope, objectives and success
//   criteria of the system that you like to develop.
// ]

// == Objectives
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Derive concrete objectives / hypotheses for this evaluation from the
//   general ones in the introduction.
// ]
// == Findings
// #rect(width: 100%, radius: 10%, stroke: 0.5pt, fill: yellow)[
//   Note: Interpret the results and conclude interesting findings
// ]

// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Summarize the most interesting results of your evaluation (without
//   interpretation). Additional results can be put into the appendix.
// ]

// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[

// == Limitations
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Describe limitations and threats to validity of your evaluation, e.g.
//   reliability, generalizability, selection bias, researcher bias
// ]

// = Summary
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: This chapter includes the status of your thesis, a conclusion and an
//   outlook about future work.
// ]

// == Status
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Describe honestly the achieved goals (e.g. the well implemented and tested
//   use cases) and the open goals here. if you only have achieved goals, you did
//   something wrong in your analysis.
// ]
// === Realized Goals
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Summarize the achieved goals by repeating the realized requirements or use
//   cases stating how you realized them.
// ]

// === Open Goals
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Summarize the open goals by repeating the open requirements or use cases
//   and explaining why you were not able to achieve them. Important: It might be
//   suspicious, if you do not have open goals. This usually indicates that you did
//   not thoroughly analyze your problems.
// ]
// == Future Work
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Tell us the next steps (that you would do if you have more time). Be
//   creative, visionary and open-minded here.
// ]
// #rect(
//   width: 100%,
//   radius: 10%,
//   stroke: 0.5pt,
//   fill: yellow,
// )[
//   Note: Recap shortly which problem you solved in your thesis and discuss your
//   *contributions* here.
// ]