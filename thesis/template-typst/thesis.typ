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
The United States has seen a dramatic increase in wealth and income gaps in
recent decades, with the wealthy and powerful seeking to shape the political
environment @skocpol2016koch. Additionally, the US bipartisan system has
recently become more @polarisation. The public's perceptions mirror these
trends: 84 percent of US residents think that money influences politics
excessively and express a desire to see changes made to the campaign finance
system to lessen the influence of wealthy donors @bonica p.1.

The Koch Industries, a privately held Industrial conglomerate, are one of the
biggest donors to US politics. They are known especially for their involvement
in the 2016 election cycle, where they spent "more than twice what the
Republican national committee spent in the previous presidential election"
@skocpol2016koch p.8.

// == Koch Industries example (2016 elections)
// - political shift in US politics, differences in income and wealth, powerful and
//   wealthy want to influence elections/politics, @skocpol2016koch mixed with
//   polarisation of bipartisan parties @polarisation
// - even 84 percent of citizens believe that money has too great an influence in
//   politics and express a desire to reform the campaign finance system to limit the
//   influence of wealthy donors" @bonica p.1
// - Koch Industries as one of the biggest donors...
// - especially involvement in the 2016 election - plegded to spend more than twice
//   that of republican comittee, support the republican party and the far-right
//   @skocpol2016koch p.8
- most republicans received contributions from oil&gas, with constently over 80%
  of rebublicans receiving oil&gas contributions from 2016-2024.
  @OpenSecrets2024PartisanIndustries
- Koch Industries have multifaceted approach, one through campaign contributions,
  another through organized groups and networks of political mega-donors
  (reshaping "gedankengut"), @Hertel-Fernandez_Skocpol_Sclar_2018 p.1 such as
  through the "koch network":

  #quote(
    attribution: [Skocpol @skocpol2016koch p.8],
  )[
    The Koch network is not just a congeries of big money donations from the two
    brothers themselves, or a loose, undisciplined array of advocacy groups and
    political action committees to which the principals send checks. Instead, the
    network has by now evolved into a nationally federated, full-service,
    ideologically focused parallel to the Republican Party.
  ]

- although with their Koch network and ideology they can do so much, the
  contributions are relevant bec. quantifiable. increased so much over time (rank
  5 over 29k in contributions in 2024 @OpenSecretsKochIndustries)

#figure(image("figures/FusionCharts.jpg", width: 80%), caption: [
  Average Contributions to Members of Congress, 1990-2022
])
- Not only does this have dire consequences for democracy (e.g. wealthy donors
  being able to influence policy) @Weschle_2022b
- But... the Koch Brothers, esp. David Koch's role in climate change denying,
  @doreian2022koch p.2,8 @skocpolfernandez2016 and given their role in being able
  to contribute to congresspeople and influence the "gedankengut" of the US
  citizens, makes one wonder what the consquences for environmental policy is.

- this is exactly what is to be analysed in this paper, e.g. how energy related
  (anti and pro env.) campaign contributions to house members effects their votes
  on environmental legislation.

== Literature & Methods used
- based on strattman @stratmann-2002 (methodology & models) @stratmann-1995
  (contribution data), empirical and theoretical part, (causal identification
  strategy) use of campaign contribution and roll call data, OLS/probit
- Outline
  - first, theoretical review of campaign contribution literature, with a focus on
    the causal relationship between contributions and votes, then linear and
    logit/probi model to estimate the effect of anti/pro env. contributions on
    pro/anti env. votes

#pagebreak()

= Money in Politics
- how does money in politics work?
  - contribution types (PAC, individual)
  - tradeoff for congressmen, vote acc. to voter base (get re-elected) and vote acc.
    to donors (get money to spend on campaigning) @KauKeenanRubin p.273
  - contribution goals (enrichment, campaign contributions, revolving door)
    @Weschle_2022c
- consensus: spending in politics has risen over time (opensecrets sources,
  @Stratmann_2005 p.141), explained by Lott, higher in states with bigger gov.
  @Stratmann_2005 p.148 @stratmann-2017 p.1 ("money given in contributions to
  political campaigns has grown substantially")
  - *plot* campaign contributions over time (steady increase), aka more relevant to
    analyse
  - *plot* distribution of campaign contributions - who gets contributions, over
    time more congress people get some?
- campaign contributions rose over time because of landmark US Supreme court case
  Citizens United v. FEC "in 2010, which cleared the way for unlimited
  election-related ‘independent expenditures’ previously capped in 24 U.S.
  states." @citizen

== Campaign Contributions
- especially in campaign contributions, increase... ?
- why do candidates need contribution?
  - election every 2 years in house of representatives
  - need contributions to fund campaigns, to run for election. this money is spent
    on advertisments and rallies, handouts, etc. @Weschle_2022c p.24
- why is there campaign contribution, what does it achieve? -> better election
  @Stratmann_2005 @Weschle_2022c p.24
- but no clear correlation between campaign spending and vote shares which
  candidates receive, in the US, @Weschle_2022c p.24, (also other authors who
  state this) - there is endogeneity - depends on a host of factors, ie.e.
  closeness/competition in race, contribution limits in some states, strategic
  spending @Denzau-Munger-1986, @Weschle_2022c p.25
== Correlation Contributions & Votes in Corporate Interests
- in general, consensus that there is no link between PAC contributions and votes
  in that PACs favor @Selling2023 p.1 @fellowes-wolf2004 p.315, @fiorina1999new
  p.216
Depends on:
// Institution related
- industry specific results, specific legislation, p.27.28 @Weschle_2022c
- after all, there is good evidence that more campaign spending affects
  politicians and policy @Weschle_2022c p.26 (just have to consider more factors,
  different approaches?)
- Economic Literature states that the campaign contributions received depend on:
  @stratmann-1995 p.128
  - party spread of the voter base "by the distribution of left-wing/right-wing
    voters in the district in which candidates are running" @stratmann-2017 p.9
- PAC contributions depend on the incumbency status of legislators, since there is
  a "tendency of companies to direct their contributions to incumbents"
  @Selling2023 @fouirnaies2014financial
- expected closeness of outcomes -> "if incumbents expect that challengers pose no
  real threat, then incumbents will spend much less than if challengers did pose a
  threat" p.8 @stratmann-2017
- correlation isnt enough, other factors influence, campaign contributions
  endogenously determined by a multitude of factors. @bronars-lott-1997 p.318
- a contribution dollar doesnt go the same way, dep. on district where adv. is
  spent @stratmann-2009
// Reason for Contribution
- assumption that "the firms are profit-maximizing and don’t make contributions
  for reasons that do not benefit their bottom line" that the contribution is not
  for nothing...what they recevie, however is unclear @stratmann-2017 p.13
- 2 motives on what campaign donors receive in return, influence , i.e. change
  mind, or support those cands. that have yours @Weschle_2022c pp.26-28 - small
  scale contributors do follow both methods.
- 3 types of candidates receiving contribution, also what is the goal of the
  contributor - access to the candidate, influence elections, most likely to win
  @Stratmann_2005 p.146 @stratmann-2017 p.13

To summarise... many different specifications needed, no clear consensus
- part of the reason there is no academic consensus is because of the nature of
  the studies, cross-sectionality design, where correlation between contributions
  and votes (aka that money buys votes) is given due to the support of similar
  interests, so we have simultaneousequation bias - p.1 @stratmann-2002
  @burris2001two @chappell
- Important is to understand, from which side the causation runs...
  @stratmann-2002 p.1 @bronars-lott-1997
- endogeneity issue...
- need to "exploiting specific votes and a rather narrow policy setting" @kang2015
  @stratmann-1991 p.607 @chappell

Why did these studies fail?

#quote(
  attribution: [@stratmann-2017 p.14],
)[These studies lacked a convincing identification strategy to estimate the causal
  effect of campaign contributions on legislative voting behavior. One major issue
  arises due to possible reverse causality, meaning that while contributions have
  an impact on roll call votes, it is also possible that legislators who cast roll
  call votes which are favorable to interest groups receive contributions from
  these groups.]

== Causal Effect of Campaign Contributions on Representatives' Voting Decisions.
*Main question*: Do incumbents cater to wishes of special interest groups, bec.
of their contribution or do they get contribution because their views coincide
with the special interests groups (mind-changers)? @Stratmann_2005 p.143
@KauKeenanRubin p.275

#quote(
  attribution: [@matter, p.6 Bronars and Lott @bronars-lott-1997],
)[
  So far, causal evidence on this question is scarce as it is challenging to
  disentangle whether donors simply sympathize with and donate to politicians with
  political positions close to their own positions (i.e., donations are simply an
  expression of support), or whether donations actually affect the observed
  politicians’ decisions (i.e., donations actually buy votes).
]
same said for @chappell p.83. cannot conclude that contributions affect voting
behavior of US representatives Evidence of Causal Relationship....\
#quote(
  attribution: [@matter p.6 @bertrand],
)[provides indirect evidence in support of vote buying, by showing that lobbying
  firms provide special interests access to politicians (as opposed to only giving
  issue-specific information to Members of Congress)]

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
McAlexander, 2020 @McAlexander2020 - Elections and Policy Responsiveness:
Evidence from Environmental Voting in the U.S. Congress:
- shows that the association between upcoming elections and pro-environmental
  voting grows more positive when candidates receive campaign contributions from
  the oil and gas industry, again consistent with the idea that the gap in the
  public and the interest groups' policy preferences explains the electoral
  effect. (electoral gap meaning the difference between what they vote due to the
  contributions and the votes they make to suit their voter base and get
  re-elected) - "Candidates that receive generous campaign contributions from the
  oil and gas industry increase their pro-environment voting at election time,
  because they understand that the public's preference for environmental
  protection is stronger than that of the oil and gas industry".

\
Baldwin, Magee 1997,
- linkages between voting behavior on specific roll call votes and campaign
  contributions from industry, labor unions, PACs

// Solution... I will include these things
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
+ change in voting behaviour @KauKeenanRubin p.276
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
- fossil fuel industry as a significant contributor of campaign contributions (as
  shown above)
- most voter bases have predetermined positions, which legislators are likely to
  keep, see @stratmann-2002 preconditions
#quote(
  attribution: [McAlexander @McAlexander2020],
)[ As most environmental policies impose concentrated costs on industries to
  protect the broader public from harm (e.g., Aidt, 1998), it is typically the
  case that the public prefers stronger environmental policies than the average
  interest group ]
- topic of incredible relevance (interest of mine?), many votes... relevance means
  large amount of votes
- american public and even more so, congress members have become more polarised on
  env. issues @McAlexander2020
- environmental issue is important enough, that candidates still need to
  articulate positions, dep. on the average voter @list2006elections
*why these bills?*
- all amend the funding/resources allocated to the EPA, which is "the Congress
  plays a central role in the formulation of federal environmental policy. The
  authority of the executive wing and the Environmental Protection Agency (EPA) to
  regulate behavior is based on legislation enacted by the Congress"
  @McAlexander2020
- repeated 6 times, where 2 are the same bill, and 5 out of 6 are exactly the same
  topic, only 113th bill is a tad bit different
- more detail on the bills, why revoted, why in different sessions...
*how to change study/assumptions from above*
- legislators do not take clear positions on topics (even before, with Glass
  Stagall Act, this was a stretch, here it is definetly given) -> individual FE to
  account for this.
- financial contributions from these industries are the highest & similar in size
  (not given here, large but not largest, not similar in size.
  - *plot* difference in contributions - from Opensecrets stats by industry.)
- large amount of mind changers (incl. plot) ... no, still enough
- Stratmann works with campaign contributions from the electoral campaigns of
  house members, i analyse these too, and additionally include votes of only 6 mo.
  prior to vote, to accomplish 2 things: acct for 2 votes on methane pollution
  safeguards in 115th congress and bec. more accurate, acc to @stratmann-1995 not
  only election period before, but current one, next one (all overlap in time of
  contribution.)
  - *plot* contributions from before (e.g. relevant contributions over time, with
    cutoff date, 2012 (misses vote 6mo. prior completely, 2014 right in the middle,
    2016 in between))
  - *plot* stats of the composition of the 6 mo. prior to vote contributions i.e.
    2012 0 contribs, 2014 3000, 2016 2000...

== Hypotheses
- Effects usually minimal, if significant @stratmann-2002 ?
- change in votes is positively related with change in contributions (if little)
- more time relevant votes have a more significant effect on votes, than the
  aggregate contributions, @stratmann-1995

#pagebreak()
= Data
== Data Types
=== representative data
- source: github dataframe (of current and historical legislators) and bioguide
- needed to use representative data to match with contributions. Since
  contributions always were to everyone, and/or to house candidates, needed to
  keep only those who then made it to the house.
- moreover, needed to import representative data from github to get the IDs to
  then match rollcall and contribution data together.
=== rollcall data
- stratmann prerequisites: uses cross-sectional panel data (panel data erhoben
  multiple times, like ts.) → only works w/ similar bills
  - yes, methane bills (6 different kinds -> from LCV Scorecard)
  - why kind of votes? what kind of bills?

=== contribution data
- sources: opensecrets bulkdata campaign contributions (election data 2012-2022)
- data were PAC contributions to candidates and individual contributions (to PACs,
  candidates, etc.) -> source: opensecrets bulk data documentation
- stratmann prerequisites: votes in 1991 and 1998, contributions in 1991-1992 and
  1995-1996. use contributions from 1991-92 as a base year, since no prior
  legislation done.1991-1992 contributions taken either as reward of vote in 1991
  or as punishment,but… maybe timing or “rewarding” or “punishing” contributions
  are not momentary,so also take 1989-1990 and 1995-1996 and 1991-1992 to
  1997-1998 into account.

Validate Decision on which types of contributions to use based on:
#quote(
  attribution: [Skocpol @skocpol2016koch p.8],
)[
  Finally, there is the question of time lag. What is the temporal relation
  between contributions (cause) and roll call votes (effect)? Some recommend using
  short time intervals, like months or even weeks (Stratmann 1998; Wawro 2001).
  They argue that firms make contributions in close temporal proximity to roll
  calls to maximize influence. Yet, the dominant view is that donor-legislator
  relationships develop over longer periods (Clawson, Neustadtl, and Weller 1998;
  Gordon 2005; Peoples 2010; Romer and Snyder 1994).
]
- decided on taking only 6 mo. prior to vote contributions of individual and PAC
  contributions to all candidates of house, and all individual contributions in
  general.
  - *plots* of when looking at 6 mo. prior to vote, which election periods are
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
You can find the entire data processing, plots and analysis on my github
profile.

=== Cleaning
==== Representatives
- imported Bioguide Representative Data (important for bio data, party, district,
  etc. weren't so extensive in rollcall and contribution data)
- *problems:* LCV scorecard did not have IDs for all votes, just the last one,
  only from 2021 onwards. Thus merge was difficult later. But... used regardless
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
- changes in members halfway, i.e. shows up in representative list, but not in
  rollcall, or in contributions, etc.
- (changes in congress from house to senate, github df then shows as only assen,
  not rep history)
==== Rollcall data
- because i used LCV scorecard, already predetermined which were pro-environmental
  votes, which were anti-environmental votes, drawback of no merge with ID.
- merge together rollcall votes, determine vote changes, vote counts, to make
  analysis easier
- *problems:* rollcall data from 2013-2019 was uniform, same names, cols, etc.
  vote from 2021 had different format, names were different, had Bioguide ID so
  when concatinating all rollcalls of the the 6 votes together, the last one didnt
  match, i.e. couldnt "join" based on names (had to fuzzyjoin and merge based on
  party, district, etc.)
==== Campaign Contributions
- data processing:
  - aggregate: import all industry/sector data for each election (to all house
    candidates), then join together, by reps - include only house members. join
    together to create wide format panel data. Final step: categorize by pro-env
    contributions and anti-env contributions
  - bulkdata: use only individual and PAC data, select only members of congress and
    then for the RealCodes choose only relevant ones, e.g. E (energy related) and
    oil, etc. related -> source bulkdata documentation for industry summarize all
    pro-env realcode contribs per rep into +/- env contributions
- *problems:* contributions in aggregate form quite clean, in time-related form,
  quite difficult to import due to size and small RAM
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
Why use which models? first LPM because....
#quote(
  attribution: [Selling @Selling2023],
)[Another aspect to consider is that the outcome variable is dichotomous. That
  calls for the use of logistic regressions. However, logistic regression makes it
  difficult to interpret results substantially or compare models with different
  independent variables. That is because, as Mood (2010) tells us, logistic effect
  measures reflect unobserved heterogeneity, even when the omitted variables are
  uncorrelated with the independent variables. According to her, a possible
  solution to this problem is to run linear probability models (LPMs). LPMs
  usually fit about as well as logistic models, even in the case of nonlinearities
  (Long 1997).]

- still use Logit/Probit for robustness...
== Linear Probability Model with Individual Fixed Effects
- takes into account that dichotomous nature of votes, and non-negativity
  constraint of votes @chappell p.77
- compare results aggregate contributions and time related contributions (6 mo.
  prior to vote)
- Altough most basic model, needed to estimate the linear relationship between ALL
  contributions and votes.
+ basic OLS
  - votes: pro-env/anti-env
  - contributions: all / grouped env/non-env
  - no FE / with FE -> differences?
+ sessionized OLS
  - one regression for each vote (vote ~ contribution from election cylce/6 mo.
    prior)
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
- use more open source software and data (congress APIs
  (https://github.com/LibraryOfCongress/api.congress.gov/)) and congress
  packages(https://github.com/IPPSR/congress)
- analyse difference in congress person's age, experience, etc. (are young/old
  legislators more likely to change their votes given contributions)
- analyse not the contributions to the candidate/representative themselves, but to
  their party, given strong partisan split, and that reps want to keep within
  party lines @Selling2023
- differences in voting behaviour on environmental issues given system of voting
  in house (lastnames A-Z), members with last names at the end of the alpahabet
  more likely to deviate from party lines given vote is already won/lost.
- contributions act as rewards for past votes, not to incentivise future votes
  @stratmann-1991
- include models from @stratmann-1995, that work with time related data and not
  just aggregate electoral data, like in @stratmann-2002
- use DW-Nominate to make study more robust... compare partisan lines
- this can lead to OVB, since "has no good measure for whether a challenger poses
  a
threat" -> by using 2SLS we can overcome this @stratmann-2017 p.9

#pagebreak()
= Conclusion

// -------------- CRAP LINE ------------------------
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