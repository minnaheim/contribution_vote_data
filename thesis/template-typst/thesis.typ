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
= Introduction <intro>
The United States has seen a dramatic increase in wealth and income gaps in
recent decades, with the wealthy and powerful seeking to shape the political
environment @skocpol2016koch, alongside the bipartisan system becoming more polarised @polarisation. The public's perceptions mirror
these trends: 84 percent of US residents think that money influences politics
excessively and express a desire to see changes made to the campaign finance
system to lessen the influence of wealthy donors @bonica p.1.

The brothers David and Charles Koch, are one of the most influential donors who
have a multifaceted approach when it comes to their involvement in US politics.
On the one hand, they shape the mindset of the US population through organised
groups, think-tanks and networks of other mega-donors with similar political and
social ideologies, such as the Koch Network @Hertel-Fernandez_Skocpol_Sclar_2018.

On the other hand, the fossil fuel conglomerate Koch Industries, headed by Charles Koch, fund the electoral campaigns of (Republican) presidential and congressional
candidates @skocpol2016koch and have spent more than 123 million USD on elections. Especially over the past ten years, Koch Industries
have increased their campaign contributions by at least 10% per election cycle,
amounting to 28 Millon USD in the 2022 election cycle, with approximately 90-97%
of these congressional contributions going to Republican candidates
@OpenSecretsKochIndustries.

Given the participation which wealthy (fossil fuel) donors like the Koch brothers have
in US elections, the question is why donors such as these contribute immense
sums to congressional elections? Surely,
profit-maximizing firms such as the Koch Industries do not merely contribute
millions of USD to congressional campaigns without considering their return on investment @stratmann-2017. Thus, the question is what campaign contributors are
to receive in return for their donations. Given Charles Koch's position at the Industry and fossil fuel related
conglomerate Koch Industries and David Koch's history in climate change denial
@doreian2022koch pp. 2-8, and their donor and advocacy roles in the United
States makes one wonder what the consequences of fossil fuel related campaign
contributions to the US congress could mean for US environmental policies.

These questions will be analysed in this paper. The influence of
fossil fuel and environmentally related contributions on the voting
behavior of US House members on methane pollution bills will be analysed. The Analysis is based
on the Paper of Thomas Stratmann @stratmann-2002, who exploits the time series
nature of campaign contributions and rollcall votes to approach a causal identification strategy to
measure the effect of financial contributions on rollcall votes. Regarding
campaign contribution, however, @stratmann-2002 uses the aggregate contributions
for each election cycle, whereas in his 1995 paper, only the
contributions leading up to the vote are included, regardless of election cylce @stratmann-1995.
Although both contribution types are explored, this paper will focus on the latter contribution strategy.// if i use 1995 stratmann's "data", then shouldn't I also include his models ?

The chapter 2 of this paper will give a short literature review on the economics
and political science perspectives on money in politics, with a focus on the
causal relationship between campaign contributions and the representatives'
voting decisions. Chapter 3 presents the research design, details the reasoning
behind analysing environmental legislation and the methane pollution rollcall
votes in particular, and presents the hypotheses regarding the effect of
contribution on voting decisions. Chapter 4 presents the data types and
processing for the analysis and chapter 5 presents the models used. Chapter 6
reports the results and chapter 7 provides the discusses the results and concludes the paper.

#pagebreak()

= Money in Politics <moneyinpolitics>

// three types of money in politics
To understand the relationship between campaign contributions and
representatives' voting decisions, the concept for money in US politics needs
to be introduced. Political Scientist Simon Weschle defines three types of money
in politics, namely self-enrichment, campaign contribution and golden parachute
jobs. The first type happens when politicians are in office, and receive
resources from special interest groups. Politicians receive campaign
contributions during elections, to fund their campaigns. According to Weschle,
the last type of money in politics is the golden parachute jobs, which are
financially lucrative positions offered to ex-politicians @Weschle_2022c.

== Campaign Contributions
// why focus on campaign contributions - largest increase?
Although each of these types of money in politics has significant and different
repercussions for democracy @Weschle_2022c and the voting behaviour of politicians, campaign contributions in US
politics are of particular significance for this paper. One reason for
this, is that there has been a stark increase in contributions to political
campaigns over time @stratmann-2017 p.1 @stratmann-2005 p.141 and understanding the reasons behind contributors donating this money to fund campaigns could help policy makers deal with this issue. The average
contributions to members of congress have increased as well within the last 40
years.

#figure(image("figures/avg_contrib_house.jpg", width: 100%), caption: [
  Average Contributions to House Members #footnote(" Since the 2024 election cylce is due in November 2024, the contributions
there are not comparable to 2022 yet"), 1990-2022
]) <avg-contributions>

#figure(image("figures/total_contrib_congress.jpg", width: 100%), caption: [
  Total Cost of Election#footnote("where * stands for a Presidential Election Cycle, 1990-2022") @OpenSecretscostofelections
]) <cost-of-election>

// legislative background
One of the main reasons for the noted increase in not only total costs of presidential and congressional elections over the last 30 years, but also the average campaign contribuions
per representative, is attributable to the change in legislature. In 2010,
the US Supreme Court passed the landmark court case Citizens United v. Federal
Election Commission (FEC), which treated the question of whether Congress has
the authority to limit independent expenditures by corporations. Campaign
contributions are usually structured as individual and Political Action Comittee
(PAC) contributions in the Center for Responsive Politics data#footnote("to be found under https://www.opensecrets.org"). Contributions over 200 USD by natural
persons (or their family members) who work in the industry are individual
contributions @griers. PACs are comittees representing corporation or
labor interests @OpenSecretspac. The Citizens United v. FEC case declared that
natural and legal persons, i.e. persons and corporations have the same campaign
spending rights when it comes to the US congress @foreman p.194. In essence,
this case enabled independent expenditures which are election related to become
unlimited @citizen.

// why do candidates need contributions?  -  improve election values
Even if campaign contributions have risen over time, the reason as to why politicians receive these should be clarified. US Citizens who would like to become
members of the United States Congress, such as the House of Representatives,
which is the chamber of congress which this analysis focuses on, need to become elected through a bi-yearly
congressional election. To improve chances of election, these candidates get
financial contributions, which they spend on advertisements, rallies and handouts
to attract more votes @Weschle_2022c p.24.

// Reason for Contribution
Yet, why would corporations give money
to candidates via PACs or individual contributions, which these will not return? Stratmann makes the assumption that
since corporations are inherently for-profit, they
do not donate to organisations without wanting to profit from doing so. Economists and Political Scientists hypothesise, that  companies' campaign spending is strategic @stratmann-2017
@Denzau-Munger-1986 @Weschle_2022c p.25. What exactly these companies receive in return
for their contribution, however, is unclear @stratmann-2017. Stratmann defines three motives for contributions: the first is access to the candidate,
the second is to influence election and the third is to contribute to the
candidate most likely to win @stratmann-2005 p.146 @stratmann-2017 p.13. Weschle
determines that what campaign donors receive in return to contributing to
candidates is either influence, meaning they change the opinion of the candidate
by contributing to their campaign, or the support of a candidate that has your
interest at heart, with specifically small scale contributors following both methods
@Weschle_2022c pp.26-28.

// Überleitung, reason for contribution to correlation between 2 vars
Besides dicussing the reasons for campaign contributions, the question
is also whether there is a positive correlation between candidates receiving
contributions and receiving increased vote shares. If this were the case, then
campaign spending would be more straightforward, since this would mean that
successful election can be assumed.

== Contributions and a Candidate's election sucess <contributions-success>
// -> CHANGE THIS SECTION - NOT CONTRIBUTION AND VOTE SHARES, BUT CONTRIBUTION AND VOTES IN CONTRIBUTORS INTEREST
// can we assume correlation?
// keep this section?

One would assume that receiving more campaign contributions would relate to a
higher chance of getting elected, yet there is no clear correlation between
campaign contributions and the vote shares which candidates receive
@stratmann-2005 @Weschle_2022c p.24. In fact, there are a host of factors that
influence the amount of campaign contributions politicials receive, which are often
endogenous to a candidate's vote shares @Weschle_2022c p.24.

// factors to include to explain correlation between contribs & votes
Geographical factors play a role in contribution, for example. A contribution
amount is worth more in some congressional districts than in others, since costs
like rallying and advertising are priced differently @stratmann-2009. Similarly,
contribution limits imposed on certain US states cap the contribution amount
candidates may receive @Weschle_2022c p.25, and candidates from states with
larger governments receive more contributions on average @stratmann-2005 p.148
@bronars-lott-1997. Factors which depend on the nature of the election also
influence the level of contributions, since expected closeness of the election
outcome also changes the average contribution amounts, i.e. incumbents#footnote("A current office holder seeking re-election.") who
expect their position to be threatened will be incentivised to gather more donations
@Weschle_2022c, @stratmann-2017 p.8. p.25. The partisan lean of a state
also determines which candidates are up for race @stratmann-2017 p.9. PAC
contributions in particular depend on the incumbency status of the candidate,
since incumbents receive more contribution on average @Selling2023
@fouirnaies2014financial. When academic papers such as that of @Weschle_2022c
include factors such as those listed above, increased campaign spending does relate to
higher vote shares for representatives.

== Campaign Contributions and Representatives' Voting Decisions.

When it comes to the relationship between campaign contributions from special interests and representative's voting decisions in that interest's favor, many researchers see a correlation. 
Yet, the deduction of what that means for the relationship between campaign contributions and votes is difficult to make.Do incumbents cater to wishes of special interest groups,
because of their contribution or do they get contribution because their views
coincide with the special interests groups @stratmann-2005 p.143 @KauKeenanRubin
p.275? Similarly, it is difficult to distinguish between two possible
explanations for donations to politicians: either donors merely sympathise with
and support politicians who share their views, or donations actually influence
the politicians' decisions (i.e., donations actually buy votes)
@bronars-lott-1997 @chappell p.83.
//  Moreover, even if interest groups fund lawmakers who support them regardless, a significant relationship between money and votes does not prove that money influences politics. Situations like these leave room for simultaneous equation bias @stratmann-2002 @burris2001two @chappell.

To overcome these challenges, causality must be established. Yet determining causality when there is a positive association between donations and roll call votes is one of the most challenging issues in the literature on campaign finance. The idea that money may be exchanged for votes is contested by two competing causal theories. Firstly, donors often provide to organisations and individuals that are inclined to support their policy ideas @burris2001two. Secondly, it is possible that donations function more as incentives for previous roll call votes than as catalysts for more voting @stratmann-1991. In the first case, the ideology of the lawmaker acts as a confusing factor, making the link between money and votes fictitious. The second situation involves the concept of reverse causality @Selling2023 @stratmann-2017.

Given the importance of determining causal relationships for money in politics,
several researchers have tried to identify such a relationship between voting
and contributions and have not found effects, such as Bronars & Lott, which
analysed how the voting behavior of politicians changed when they did not stand
for re-election. Ideally, politicians should represent their ideology, even
without facing threat of re-election, yet if their vote is 'bought' then their
contributions and voting behaviour changes, since the cost of shirking decreases
@bronars-lott-1997 p.319. Ansolabehere et al. analysed 40 empirical papers and
concluded in a seminal paper that there is limited evidence indicating interest
group contributions have an impact on roll-call votes @Ansolabehere @griers.

Others, however, have found that contributions do change voting behaviour:
Stratmann analysed the timing of contributions, and instead of analysing how the
contributions of the previous cycle relates to the voting behaviour of
politicians, Stratmann took the contributions from current election cylces,
since short term contributions are more relevant for voting behavior, according
to him @stratmann-1995. Betrand finds indirect
evidence of lobbying companies providing special
interest groups access to politicians when these groups contribute (as opposed to giving
only issue specific information to congress members)@Bertrand @matter. Baldwin and Magee also find linkages of
rollcall votes on specific trade agreement related bills and the contributions
from businesses and labor groups @baldwinmagee. McAlexander, in his paper on the
electoral gap in evironmental voting determines that since the public's inclination for environmental protection is greater than the oil and gas sector's, candidates who get large campaign contributions from businesses tend to vote more in favour of the environment when elections come around. @McAlexander2020. 
// Also Mian et al. find that campaign
// contributions alter rollcall votes @mian.

Given that some results find causal relationships between contributions and
others find no effect, most researchers can conclude that there is no academic consensus on
this matter @stratmann-2017 p.13. Part of the reason there is no academic consensus on causal
relationships is because of the nature of the studies, which are cross-sectional
in design, where correlation between contributions and votes is given due to the
support of similar interests, so we have simultaneous equation bias
@stratmann-2002 p.1 @burris2001two @chappell.

The studies which found causal links between campaign contributions and voting
behaviour have a common denominator: research in particular fields or
legislation. Baldwin and Magee, for example, @baldwinmagee analysed trade
agreement related bills, @stratmann-2002 analysed financial bills
@stratmann-1995 @kang2015 @stratmann-1995 and the timing of financial
contributions, and found significant effects. Hence, one needs to analyse distinct
rollcall votes and a rather restricted policy setting" @kang2015 @stratmann-1991 p.607
@chappell.

Moreover, Stratmann critisises that most studies done in the field lack a convincing identification strategy to determine the causal relationship between legislative voting behavior and campaign contributions. One significant problem is from the possibility of reverse causation, which suggests that although contributions influence roll call votes in favor of interest groups, it's also feasible for legislators to accept contributions from these groups.
@stratmann-2017 p.14

Common criticism in the field is attributed not only to studies whose analysis
does not focus on a specific legistlation or account for reverse causality, but
also those who do not control for individual counties and geographical areas
@stratmann-2005 p.142 @griers. Moreover, only by looking at repeated votes and thus
changes in voting behaviour, a link can be determined between contribution and
voting @stratmann-2005 p.143-144 @stratmann-2002. Considering a closer
time-frame for contribution has also proven to increase plausibility
@stratmann-1995.

// - model setup: must allow for endogeneity of contributions, dichotomus nature of
//   dependent vote variable (yes/no) and non-negativity of campaign comntributions.
//   @stratmann-1991 p.606

Given the extensive research done in money in politics, and moreover in the
(causal) relationship between campaign contributions and rollcall voting
behaviour, this paper will aim to take the above stated specifications to
analyse a causal relationship between campaign contributions and rollcall votes
in the environmental context.

#pagebreak()

= Research Design <research-design>
This section will deal with the reasoning behind the chosen roll call votes and
and the hypothesis which are set up for the
analysis.

== Roll Call Vote Specifications <vote_spec>
// Conditions met: Vote repition, winners & losers defined,
Thomas Stratmann @stratmann-2002, who in his 2002 paper follows a similar
methodology to determine the causal relationship between campaign contributions
and the representative's vote shares, defines the following rollcall votes
preconditions for his research: the votes are not only repeated but also exhibit
changes in voting behaviour @KauKeenanRubin p.276 @stratmann-2002. Moreover, the
winners and losers of the votes need to be defined, the precise subject voted on
should not be repeated again. This way patterns in contribution and voting
behaviour can be deduced more easily. These conditions are met in this analysis.
There are six roll call votes which are related to methane pollution safeguards
(i.e. the methane emissions of fossil fuel companies), and these are not
repeated to this date, since the vote relates to the acceptance or rejection of
an increase in environmental regulation, the winners and losers of the votes are
clearly defined.

// Conditions not met: clearly articulated positions, contribution industry size
There are conditions, however, which Stratmann sets up which are not met in this
paper. On the one hand, he stipulates that the research should treat a topic
where representatives do not typically take clear stance in
their election campaigns @stratmann-2002 p.4. This is not met here, since
environmental positions are usually quite polarising, and most legislators have clear
positions on environment, due to their party line and also their personal
conviction @McAlexander2020. Stratmann also states that substantial amounts of
representatives should receive campaign contributions from the relevant interest
group, here pro- and anti environmental and fossil fuel related contributions.
This is split in this paper, since a substantial amount of legilators receive contributions
from fossil fuel industry, and the Energy and Natural Resources interest
groups was the 9th biggest interest group contributor in 2022 with a total of
196 Billion USD contributed over the 2022 congressional election. The
environmental contributions, on the other hand, are a fraction of this
@OpenSecretsInterestGroups. Thus, it is more difficult to compare the
contribution sizes of these interest groups. Lastly, Stratmann determines that
there need to be changes in voting behaviours of the representatives, yet in
this case, only 23 representatives out of 529 change their vote over time.// insert mind changers plot here (confirm 23/529?)

== Methane Pollution Votes <rollcall-subject>

// what are methane pollution safeguards, what are methane emissions and why are they important, why related to oil & gas industry.
// methane pollution safeguards is...

Although as shown in the section above, the rollcall bills do not fit all of the
preconditions stipulated by Stratmann @stratmann-2002, analysing
environmental policy and the propensity for representatives to deviate based on
contributions is still a relevant topic and has significant reprecussions for
democracy if a causal relationship does exist.

Although environmental subjects are polarising for the public and for
representatives, which might indicate that representatives have less incentives
to change their opinions, McAlexander @McAlexander2020 has found that most
environmental policies direct the cost of a sound environmental to industries,
so the public has a generally more favorable environmental opinion than an
average interest group, which indicates that if campaign contributions could
change the voting behaviour of representatives, then representatives would
prefer to take up positions that favour the interest groups more, i.e. less
strong environmental positions @McAlexander2020.

Moreover, the reason to choose these bills for the analysis can be attributed to
the fact that, as stated above, the energy and natural resources interest groups
are some of the biggest contributors to congressional elections
@OpenSecretsInterestGroups and thus also have the biggest potential to be
analysed, since these contributions are not only large in volume but also in
distribution, as stated in the Introduction.

//  plot about number of representatives who receive contribution

The six bills chosen for this paper are the following: The 2013, 113th
congressional session, Rollcall Vote 601 of Bill Number: H. R. 2728. The
Protecting States' Rights to Promote American Energy Security Act would
preserve the Department of the Interior's ability to reduce methane emissions
from oil and gas drilling operations on public lands. @lcv2013 The 2016, 114th
congressional session, Roll Call 434 of Bill Number: H. R. 5538. The Department
of the Interior, Environment, and Related Agencies Appropriations Act, 2017,
would include a rider into the main bill to stop the EPA from enforcing its
recently determined methane pollution regulations, which are the first-ever caps
on methane emissions from new and altered sources in the oil and gas industry.
@lcv2016 The 2017, 115th congressional session, Roll Call 488 of Bill Number: H.
R. 3354, would hinder the Environmental Protection Agency's efforts to control
methane emissions from newly created and altered sources inside the oil and gas
industry. @lcv2017 The 2018, 115th congressional session, Roll Call 346 Bill
Number H. R. 6147, would hinder the Environmental Protection Agency's (EPA)
efforts to decrease methane emissions in the oil and gas industry from both new
and modified sources from the oil and gas industry @lcv2018 The 2019, 116th
congressional session, Roll Call 385, Bill Number H.R. 3055, would hinder the
Environmental Protection Agency's (EPA) from implementing standards to reduce
methane emissions from both new and modified sources from the oil and gas
industry @lcv2019. The 2021, 117th congressional session, Roll Call 185 Senate
Joint Resolution 14, (taken up by both the house and senate) would have rolled
back on the EPA 2016 methane standards for both new and modified sources from
the oil and gas industry @lcv2021.

The reasoning behind choosing these six bills is that they all amend the
resources allocated to the Environmental Protection Agency (EPA) and the
Department of Interior. Since the legislation enacted by Congress governs the
executive wing and the EPA @McAlexander2020 p.43, these rollcall votes are
fundamental in gauging the environmental opinions of representatives. Moreover,
the bills are quite similar in nature, since they not only all concern the same
departments, but also precisely the methane pollutions and -emissions,
generated through the oil and gas industries, and are thus industry specific.

#figure(table(
  columns: 3,
  stroke: none,
  [],
  [*No Change in Voting*],
  [*Change in Voting*],
  [*Pro-Environmental Vote*],
  [259],
  [8],
  [*Anti-Environmental Vote*],
  [278],
  [23],
), caption: [Representative's Voting Positions]) <mind-changers>

Although in @stratmann-2002's paper the two rollcall votes all pertained to the
amendment of the same bill. This paper uses multiple, closely related, rollcall
votes, and thus ensures that there is more variation in voting behaviour than
there would be, if only two rollcall votes were available. Out of 568
representatives who voted on more than one of the six rollcall votes, only 23
representatives changed their voting behaviour, and of these 23 representatives,
there were 31 vote changes in total, as seen in @mind-changers. Moreover, the
fact that these rollcall votes are closely paced, i.e. 2013, 2016, 2017, 2018,
2019, 2021, means that there is a higher chance that representatives participate
in more than one vote, unlike in @stratmann-2002's paper, where the two rollcall
votes were in 1991 and 1998, which are 3 congressional sessions apart. Thus, the
chance of a representative partaking in multiple votes decreased substantially.

== Hypotheses <hypothesis>

Given the topics of the rollcall votes, see @rollcall-subject, which are
environmental in nature, and the fact that environmental issues are topics which
are usually of public interest, indicates that most representatives have
predetermined environmental positions and are less likely to change these
throughout their time in office @McAlexander2020. This can also be seen in the
data from the rollcall votes @mind-changers. Hence, the first hypothesis is that the 
effects of pro-environmental or anti-environmental contributions on the
enviornmental voting behaviour of representatives will be minimal, if
significant.

Given the differences in contribution sizes from the various interest groups,
see @vote_spec, i.e. oil and gas (thus anti-environmental) individuals and
interest groups contribute significantly more to congressional elections than
pro-environmental individuals and interest groups, the second hypothesis states
that changes from pro-env. to anti-env. votes will be more positively correlated
with anti-environmental contributions, and the pro-env. contributions will be
less significant and less effective, given the low propensity of pro-environmental groups and individuals to
contribute to representatives.

In his paper, Stratmann shows that for junior representatives, the marginal effect of
contribution was greater, whereas senior representatives were more steadfast in
their positions @stratmann-2002 . Similarly, this paper/model predicts that legislators in their
early congressional terms are more likely to change their voting.// change if dummy seniority, not 1-3 if necessary!!!

Lastly, since partisan affiliation and ideology is rather polarised in the
United States @polarisation, and that usually, republicans receive higher
campaign contributions on average, see @avg-contributions, the fourth hypothesis
states that contributions on voting behaviour will be more effective 
for republican representatives than for democratic representatives.

// Lastly, since @stratmann-1995 stipulated that contributions which are given
// shortly before the vote have higher impacts on congressional voting behavior
// than contributions from the past election cylce. Taking this into consideration,
// the fourth hypothesis is that votes in a time frame of six months prior to the
// vote will have more significant effects on voting behaviour than contributions
// from the congressional session before, since the amount of contributions change
// compared to the timing of votes @stratmann-1998.

// causal hypothesis where?

#pagebreak()
= Data

The empirical framework stipulated in @research-design requires the comparison
of voting behaviour of the US representatives and the campaign contributions
which these received. Hence, the data for the analysis consists of three data
'types' joined together: data on the representatives, their contribution data and
the rollcall data of the six votes. The following chapter consists of the description of the
data types, where they were sourced, and the data processing for the analysis.

== Representative data <rep-data>

In order to conduct the analysis, a comprehensive dataset of all US
representatives who attended the relevant congressional sessions (113th-117th), including biographical information to control for age, gender, etc. in the analysis. Identification was also required in order to be able to unambiguously attribute each roll call vote and each contribution to a particular representative and not have to deal with matching problems.

Given these requirements, the data on the US representatives was sourced from
the github repository congress-legislators#footnote("https://github.com/unitedstates/congress-legislators"), which is created and managed by a
shared commons, and includes detailed information for all historical and current
US congressional members, including various IDs they have across US legislative
data providing platforms. Since the above data is not ordered according to
congressional sessions which each representative partook in, data from the Biographical Directory of the United States Congress#footnote("https://bioguide.congress.gov")
was used match the data on current and historical legilsators with a list of the
representatives participating in each seperate congress.

== Rollcall data <rollcall>

As Stratmann stipulated in his paper, to be able to analyse changes in
voting behaviour, the cross-sectionality of panel data needs to be exploited,
and the votes need to be categorised clearly into winners and losers @stratmann-2002. This also
means, that one needs to be able to deduce from the votes which candidates voted
pro- one special interest group, and anti- the other one.

Due to this specification, the data from the League of Conservation Votes#footnote("https://scorecard.lcv.org")
Scorecard was used throughout this paper. The website predetermines which
rollcall votes are pro-environmental and which are anti-environmental. One of
the major downsides of using this data, however, was that the LCV Scorecard does not include representatives' IDs to prior to 2021, meaning that only in the last vote were IDs
matched to each representative. Although approximately 60% of representatives
present in the last rollcall vote were also present in the votes prior and thus
were able to be matched by IDs, about 40% of the representatives had to be
matched by first and lastnames, parties and states, only, which caused merging
errors, which will be detailed more in @merging.

Considering these circumstances, utilizing one of the many other rollcall data
providing websites, such as Govtrack US, Congress.gov and C-Span would have been
more useful, since these match representatives with a unique identifier. This
was not possible, however, because these websites do not publish all rollcall
votes but only the most relevant, i.e. the rollcall votes which passed a bill. For this
analysis, however, only the environmentally related rollcall votes are relevant and
these are often not published on the aforementioned websites. Thus, the LCV
Scorecard Website was used to source rollcall data, despite their incomplete use
of IDs for representatives.

// Data Processing & Cleaning
Considering the circumstance that the 2021 votes had a different format than the
2013-2019 votes, the representative's names were often different, and thus could
not be joined easily to create an aggregate rollcall dataframe.

```r
fuzzy_match <- function(x, y, max_dist = 5) {
    return(stringdist::stringdist(x, y) <= max_dist)
}
roll_call_full_<- fuzzy_full_join(
    methane_116,
    methane_117,
    by = c("name", "Party", "District"),
    match_fun = list(fuzzy_match, `==`, `==`)
)
```
To overcome this, the R package fuzzyjoin @fuzzjoin was used. Using the
functions clean_strings to remove special characters and fuzzy_match and
fuzzy_full_join to join, a maximum distance between two values can be
determined, here 5 characters. in the fuzzy_full_join, I defined that the names
between the two dataframes can be matched if they are at most 5 characters
distance from one another, while the variables Party and District need to be
identical to match.

== Contribution data <contrib-data>
=== Time Frame of Contributions <contribs-choice>

// decision 6mo vs. aggregate.
// CHANGE ANALYSIS - IN AGGREGATE, TO MATCH THIS. FIRST VOTE = POST VOTE ELECTION
As discussed in @intro, Stratmann uses two different approaches to measuring the
effect of campaign contributions on voting behaviour. In his @stratmann-1995
paper, Stratmann explores whether contributions closer to the vote are more
important in determining voting behaviour than contributions of previous
congressional elections. He concludes that current election contributions, in his
case of dairy legislation, are more determining for voting behaviour than that
of the previous election. In the @stratmann-2002 paper, Stratmann uses the
aggregate campaign contributions allocated to representatives in the election
post and prior to the congressional session, i.e. contributions from the
1989-1990 and 1995-96 vote to explain the 1991 and 1998 vote and the
contributions from the election happening paralell to the vote i.e. Stratmann
uses the 1991-92 and 1997-98 contributions to guage whether there are
punishments or rewards for the representative's voting behaviors. In both cases
he finds a positive correlation between contributions from special interest groups and a vote in their favor.

// although some researchers believe that rollcall serve as rewards or punishments @stratmann-1991, taking only

To account for these differences in campaign contribution selection, I explored
both aforementioned options: On the one hand, I calculated the contribution variables based on
the previous election cycle, based on several academic papers who take the same
approach @stratmann-2002 @Selling2023 @KauKeenanRubin @chappell @stratmann-1991
to guage whether aggregate contributions from election cylces may influence the
voting behaviour of representatives in the environmental context. On the other
hand, I included only the campaign contributions from individuals and interest
groups which supported a pro or anti environmental vote, which were given to
representatives 6 months prior to the relevant vote. This means that I include
not specific election periods, i.e. current or previous, but relevant
contributions that roll in shortly before the vote. This is based on the
hypothesis 4 stipulated in @hypothesis, that contributions are time related.

//   stroke: (x, y) => (
//   y: 1pt,
//   left: if x > 0 { 0pt } else { 1pt },
//   right: if (x + 1) == [] { 1pt } else { 0pt },
// ),
//  change stroke, to cover 2 boxes if belong together, and 1 if not, and add 16_2
#figure(table(
  columns: 4,
  stroke: none,
  [*Vote Date*],
  [*Cutoff Date*],
  [*Cycle*],
  [*Nr. of Contributions*],
  [June 25th 2021],
  [Dec 25th 2020],
  [2022],
  [4965],
  [],
  [],
  [2020],
  [34],
  [June 20th 2019],
  [Dec 19th 2018],
  [2020],
  [5191],
  [],
  [],
  [2018],
  [30],
  [Jul 18th, 2018],
  [Jan 17th 2018],
  [2018],
  [7749],
  [Sep 13th 2017],
  [Feb 12th 2017],
  [2018],
  [7148],
  [Jul 13th 2016],
  [Jan 12th 2016],
  [2018],
  [1],
  [],
  [],
  [2016],
  [7142],
  [Nov 20th 2013],
  [Mar 19th 2013],
  [2014],
  [7085],
), caption: [Consolidated contribution data with vote and cutoff dates]) <congresses-contribs>
//   *plot* contributions from before (e.g. relevant contributions over time, with
//   cutoff date, 2012 (misses vote 6mo. prior completely, 2014 right in the middle,
//   2016 in between))
// plot for cutoff date and contributions. with cutoff data vertically and the amount of contributions (in plots_2.qmd)

In determining the Congresses from which contributions are included in the six months prior, the following pattern emerges, seen in @congresses-contribs: since most votes are taken quite late in the Congresses, the contributions for the six months prior usually include contributions from the current Congress, and only sometimes from the previous Congress.

A discussion of these two types of campaign contributions, i.e. aggregate contributions from the previous election and the use of contributions from the current election, shows that these two papers both give the total contributions of an industry to candidates in an election and that only the time of relevance is different @stratmann-1995 @stratmann-2002. Yet what these two
papers, and many with similar methodology, neglect to analyse is whether more
timely contributions are more effective in affecting the voting behaviour of
candidates. After all, most contributors who are profit-maximizing contribute
strategically and in close temporal proximity to roll calls to maximize their
influence on voting behaviour @Selling2023 and thus contribute closer to the
vote, in order to assure that representatives do not back out of their promises
to support the special interst groups' causes @stratmann-1998. By including a
more restricted time frame for contribution, such as six months prior to the
vote, these trends can be captured @griers, without extending the time frame to
such an extent that the contributions of the closely paced votes (September 13, 2017
and July 18, 2018)in the 115th congressional session overlap. Which is why,
albeit analysing both strategies in this paper,for the main analysis, only the
contributions within six months prior to the votes will be included. #footnote(
  "A comparison of both the aggregate and the timely contributions included in the models can be found in the appendix.",
)

=== Contribution Data Sources and Processing

Campaign contribution data is readily available through a multitude of open
source platforms #footnote(
  "such as Sunlightlabs: https://sunlightlabs.github.io/datacommons/bulk_data.html and the Database on Ideology, Money in Politics, and Elections (DIME), but which were not suitable for this analysis",
). Among those is the Center for Responsive Politics which provides contribution
data in Bulk Data#footnote(
  "The bulkdata can be accessed through https://www.opensecrets.org/open-data/bulk-data",
) form, which includes PAC contributions to US representative candidates and
individual contributions to candidates, PACs, etc..

To clean the aggregate contribution data, the relevant contribution data was
imported. The oil&gas-, methane-, natural gas-, coal-, environmental- and
alternative energy contributions were imported for all incumbents, and then
these were cleaned and categorized into pro-environmental and anti-environmental
contributions,and joined with a list of all representatives per session.

Cleaning the bulk data for the timely contributions was more complex due to
the size of the files and the comparatively small 8 GB RAM I had available.
Given that the PAC and individual contribution text files had over 2 million
rows and were over 15 GB large at times, made the importing let alone processing
tedious, even when including the state-of-the-art tidyverse @tidyverse package's tools and functions, such as
piping and lazyloading. To resolve this, I wrote several shell scripts which
check whether a cleaned file exists, and if not, cleans the file anew. This saved
time and RAM space in two ways: On the one hand, cleaned files would not be
re-cleaned uselessly, and on the other hand, shell scripting ensures a better
utilization of RAM space when working with large files, such as these of
individual and PAC campaign contributions.

After the pre-cleaning process through the scripts, only Individual and PAC
contributions were kept which were allocated to incumbents. Using the
OpenSecrets RealCodes #footnote(
  "which can be found under https://www.opensecrets.org/downloads/crp/CRP_Categories.txt",
), only the non-negative contributions contributions from pro-environmental and anti-environmental (fossil fuel)
sources were kept.

== Merging <merging>

To merge the three types of aforementioned data together, two types of merges
(or joins, synonymous in R) were done. About 60% of the data was able to be
merged together based on a set of Unique Identifiers, which was Bioguide ID for
the rollcall data. Post primary merge, the rest of the data, which was not able
to be merged was filtered out and merged based on the fedmatch @fedmatch package's functions
fuzzy_match and fuzzy_join functions as shown in the code block in @rollcall.
Finally, the two merged dataframes were concatinated.

Finally, only about 30 representatives were not able to be merged and thus
removed. The reason for this is because these anomalies either joined or left
congress halfway through the session or switched from one congressional chamber to the next, and thus these members appeared in some
dataframe, but not in the others, i.e. incumbents are marked as representatives but were
not included in the vote and did not receive contribution, since they were not
part of a regular election.

For the final dataframe used for analysis, the 731 representatives (over
113th-117th congresses) were further decreased, to only include representatives
relevant to the analysis. This includes representatives, who voted on more
than one relevant bill. Without this specification, one couldn't analyse
differences in voting behaviour. Moreover, only Republicans and Democrats were
included, since Independent and Libertarians are too few to be able to compare.

// relevant?
// Lastly, to make the dataframe suitable for analysis, I used the pivot_longer function to pivot the dataframe to include only the Vote, Contributions (pro-environmental and anti environmental seperately) and the

#pagebreak()

= Econometric Models

// give information about why remove some variables -> LPM control -> FEs
In order to test the for the changes in voting behaviour due to campaign
contributions, the model setup must allow for a dichotomous dependent variable,
i.e. pro-environmental vote (1) or anti-enviornmental vote (0) and for the
non-negativity of contributions @stratmann-1991 @stratmann-2002 @chappell.

Two types of models that come into question for these are the Linear Probability
Model (LPM) and the Logit, which are both frequently used in economic
literature, but both come with their up- and downsides. The LPM is an ordinary
least squared linear regression with binary dependent variables. The benefits of
using a LPM to analyse the effect of campaign contributions on voting behaviour
is the fact that the linear regression can be used to estimate the effects on
the observed dependent variable, so coefficients are comparable over models and
groups @mood. One downside, however, is that there is a possibility for the
predicted probability to be out of range, by being either higher than 1 or lower
than 0.

In order to counter this, one can use the logistical regession or logit model,
which also measures dichotomous dependent variables but the predicted
probability will always stay within range of #range(2)\. Comparing models with
various independent variables or significantly interpreting the results is
challenging when using logistic regression since the distribution of the
logistic regression is non-linear and thus changes in log-ods are not as
intuitive to interpret as direct probabilities. Moreover, Mood explains that
logistic effect measures can capture unobserved heterogeneity even in cases
where there is no correlation between the omitted variables and the independent
variables @mood @Selling2023.

Although the linear regression sometimes predicts probabilities outside of
range, LPMs usually fit about as well as logit models, even in cases of
nonlinearities @long1997regression @Selling2023, and their results are easier to
predict than those of logit models @mood, which is why the LPM will be used as a
main model for this paper. To encompass the major downsides of the LPM, however,
a Logit Model will be included as a robustness check.

// Why not 2SLS -> @stratmann-2002 p.1
// say that OBV in logit & LPM? @mood?

== LPM, Logit and Probit <models-precisely>
// find better titles...

// As mentioned in @model-spec, the most generous model is the linear probability
// model shown in @lpm.
The Linear Probability Model shown in @lpm is the most basic and generous model used.

$ "Vote"#sub[i,t] = alpha + beta#sub[1t]"Contributions"#super[pro-env] + beta#sub[2t]"Contributions"#super[anti-env] \ + gamma#sub[i] + delta#sub[t] + x + epsilon $ <lpm>

This model includes the entire sample of representatives who voted more than
once on the set of the six roll call votes, it is non-discriminatory based on
voting behaviour, where $beta$ are the explanatory variables of interest,
Contributions from pro and anti-environmental sources, $X$ is the matrix of
control variables, $delta#sub[t]$ are the time fixed effects and $gamma#sub[i]$ are
the individual fixed effects, all of which are detailed in @model-spec.

Using @lpm as a base, I explored different ways of measuring the relationship between voting behaviour and contributions. One variation is to isolate each vote and include all relevant posts from previous votes and those from the current vote. This tests the assumptions made in @contribs-choice, and takes into account not only the short term contributions when an environmental vote is coming up, but also the previous contributions on similar topics, to measure whether voting depends on contributions for previous relevant votes.

To address the hypotheses made in @hypothesis, the @lpm model was also used to
measure the relationship which contributions have on voting in general, to the
see the "simple" relation between voting and contributions.// rewrite this..
In return, the LPM model was also applied to only those representatives who
changed their voting over the course of the six rollcall votes. This way the
causal identification strategy is approached, since only with variations in
voting can these conlcusions can be drawn @stratmann-2002

As robustness checks, the entire above process will be repeated using the model shown in @logit. This is the conditional logit model used by Stratmann in his 2002 paper @stratmann-2002.

$ P(y#sub[it] = 1|x, beta#sub[1,2], gamma#sub[i] + delta#sub[t]) = F(beta#sub[1,2]'x#sub[it], gamma#sub[i] + delta#sub[t]) $ <logit>

By changing the underlying $F()$, i.e. once a logistic function, and another time the  standard normal cumulative distribution function, both the probit and the logit models can be used as a robustness check for the model shown in @lpm. Using the model shown in @logit, the entire LPM specifications will be repeated here.
// change this to be in place after the 2nd paragraph?

// if use conditional logit model -> as
// -> stratmann uses a (conditional) fixed effects logit model @Allison @Chamberlin
//   @stratmann-2002
// mention using the stratmann specifications for the logit model - aka a conditional logit model with legislator fixed effects -> modeling this with bife function.

== Model specification <model-spec>

Using the models shown in @models-precisely, this paper will analyse the relationship of votes and campaign contributions ranging from using the most
generous model specifications, such as using control variables and most strict, using
individual fixed effects.

To control for confounding influence factors between a treatment and an outcome
and approach a consistent causal interpretation @control, the following control
variables are used: the legislator's party and whether their party had House
Majority during that term @McAlexander2020 @stratmann-2002, these control
variables are used since party is a good determinant for a legislator's
ideological leaning, and whether their party has the majority determines the
power which the group has over the house of representatives.

To control for the junior/senior legislators stipulated in @hypothesis, I
decided to add both the birthyear and seniority, which is number of terms in
house the representative served,to control for the difference in age and
experience which might distort the voting behaviour @stratmann-2002. By
controlling for differences in geographical residence of the representatives,
using state, geographical #footnote(
  "the variable Geographical has the 50 US states grouped into four categories: Northwest (NW), South (SO), West (WE), Midwest (MW), according to the United States Census Bureau under https://www2.census.gov/geo/pdfs/reference/GARM/Ch6GARM.pdf",
) and the district level we remove possible differences in voting behaviour
attributed to the location of representatives.

//  by including a variable for legislator ideology, thereby removing the variance in roll call voting attributable to the legislator’s ideological predisposition, helps establish causality.
//  A meta-analysis comparing these two approaches concluded that “the only effective way to control for the impact of friendly giving is to include an ideology variable in the equation” (Roscoe and Jenkins 2005, 63)


Based on roll-call records, the DW-Nominates are a widely used indicator of a
representative's policy opinion in a multidimensional policy space, which serve
as a strong predictor of the voting decisions of representatives @rosenthalpoole
@matter. By including the absolute value of the first and second dimension of
the DW-Nominate#footnote("accessible under https://voteview.com") as control
variables, we control for differences in ideology that might explain voting
behaviour. Regarding the rollcall votes, the six rollcall votes included do not
all pertain to the same bills, but I make the assumption that they are all the
same bill considering they all touch upon the same topic and institutions, see
@rollcall, and thus I will not control for differences in bills @griers.

// - potential OVB?
// The problems stem from unobservables, or the fact that we can seldom include in
// a model all variables that affect an outcome. Unobserved heterogeneity is the
// variation in the dependent variable that is caused by variables that are not
// observed (i.e. omitted variables) @mood

By including control variables, I am able to fix certain factors that I can
measure and assume have confounding effects on the predicted probability. Using
two-way fixed effects (FE) @Imai-Kim-2019, however, one can account for unobservable
elements that remain constant across time, and thus remove time invariant
confounding @griers. In this paper, four types of two way fixed effects are used: In
the more generous version, I fix for the variables geographical region and year,
since this measures only the change in contributions within a year and same
geographical location.// why fix for geo region

In a stricter version, I fix for year and state. This provides more accurate
results on the geographical level. As mentioned above in @contributions-success, differences in states and their election such as the size of government or the closeness of the election influence the amount of contributions which incumbents receive. By controling for states, not only the differences in elections and contributions are fixed, but differences in economic conditions, population sizes and possible differences
in state ties to the fossil fuel industries and severely environmentally
affected states are not compared to one another, since these differences are
important enough to influence both contributions and voting behaviour. By
controling for years, on the other hand, time-variant differences such as
environmental perception or enviornmental disasters are not taken out of context
and compared with years with little environmental happenings.

The third type of fixed effects employed are the party and state fixed effects. This way, I can adjust for the the influence that political party orientation might have on the results, along with the same temporal factors as before. This may capture differences in policies, ideologies, or priorities that vary systematically between parties @Selling2023.

Lastly, in the strictest model, I fix for both legislators and years. The reason
behind fixing for something as large as the representative, is because it gives
the able to control for omitted variables which are constant over time for each
legislator such as the representative's background, which is complex and high
dimensional and bound to affect the individuals voting behaviour @Huntington
@stratmann-2002. Not only am I thus able to address the omitted variable bias
which I was not able to address through my control variables since they are
difficult to measure @griers, such as the representative's eloquence and
negotiation skills, proximity to the fossil fuel industry and/or environmental
industry, etc. but I am able to remove previous FEs, such as the state or
geographical fixed effects, since these usualy do not change within a
representative over time. Therefore, to determine the impact of donations on voting changes, we only use the change in donations within a year and specific member, which allows us to predict the impact of donations most accurately @griers.


#pagebreak()
= Results
// rename hypothesis stuff.

== Effectiveness of Contributions
One of the hypothesis stated in @hypothesis is that the effect of pro and anti
environmental campaign contributions would be minimal, if significant. As
visible form the regression outputs in the appendix, this was not the case. From
using control variables to state and year fixed effects in the LPM with all
representatives, the campaign contributions from environmental sources and
non-environmental sources were highly significant.

// LPM all representatives with control variables & log transformed
For the most LPM shown in @lpm including control variables showed that when
increasing the pro environmental contribution to representatives by one USD, the
probability of the representative voting pro-environmentally increases by
0.00007214 percent on average, holding all else constant. In return, when
increasing anti-environmental contribution by one USD, the probability of a
representative voting pro environmentally decreases by an average of 0.000006
percent, holding all else constant. Both of these coefficients are significant
on a 0 level. Given that the contributions from both anti and pro-environment
are highly skewed, I applied a logistical transformation on the contribution
variables, and found that although the adjusted $R^2$ increases from 0.91 to
0.92 and the effect of the anti-environmental contribution variable increases to
-0.0121 holding all else constant and with the same significance level, the
sigifnicance of the pro-environmental contirubiont vairbale is est. to be an
average of 0.011, holding all else constant, but the significance level of the
estimator decreases.

// fixed effects
When fixing the LPM model by US state and year, the adjusted $R^2$ stays at 0.91
and the contribution coefficients remain highly significant with a one USD
increase in pro-environmental contribution increasing the probability of a
pro-environmental vote by 0.0000698 percent and a one USD increase in
anti-environmental contribution decreasing the probability of a
pro-environmental vote by 0.0000048 percent. Only when applying legislator and
year fixed effects does the significance of the pro-environmental contributions
decrease to a 0.01 level, with a one USD increase in pro-environmental
contribution increasing the probability of a pro-environmental vote by 0.0000361
percent on average, holding all else constant. The anti-environmental
contribution coefficient however is not significant at all, yet the predictors
are very good in explaining variations in the dependent variable, with an
adjusted $R^2$ of 0.953.

// Interpretation of coefficients
// - relatively high value of coefficients, given that the pro and anti env. contributions are distributed in the following way.. (show boxplots of contributions)
// - in general, pro-env contributions a lot less in amount and a lot less reps get them on avg. than anti-env contributions (thus explains significance of variables... the pro-env contributions are more "targeted" and effective, since they might have less budget to start with)

// Interpretation of these validity of the results
Althoug these adjusted $R^2$ values are very high and might raise suspicion of
multicoloinearity within the predictor variables, the VIF values of all
variables are below 5, with most of them being between 1 and 1.25, and a
correlation plot shows similar results, that no variables are suspiciously
highly correlated with one another. This means that the high adjusted $R^2$ values
are not due to multicolinearity, but rather due to the high explanatory power of
the model, which can be attributed to the fact that most of the control
variables are highly significant and have a high explanatory power on their own,
such as the representative's party and DW-Nominate dimensions which are already
very good predictors of the representatives voting decisions on their own.
Hence, the first hypothesis from this paper can be rejected, since the effect of
pro and anti environmental contributions on voting behaviour is not minimal,
considering each effect is measured on a per USD scale and is also rather highly
significant.

// add logit/probit results
//  add info about pro and anti dummy... ever significant?

== Contribution and Vote Changes

In the second hypothesis, changes from pro to anti environmental votes are
predicted to be more positively correlated with anti environmental contribuions,
and pro environmental contributions less effective. Considering, however, that
only 23 representatives changed their votes over the course of the six rollcall
votes, with only 31 vote changes in total, no conclusions can be drawn from this
LPM model, and in return, no conclusions can be drawn about the propensity of
contributions, whether pro or anti environmental in nature, to change the voting
behaviour of representatives. Not only are the estimated models, see Appendix,
estimating insignificant coefficients, but the adjusted $R^2$ is very low with
0.23, especially given the value of this metric in the previous models.

The only conclusion which can be drawn in respect to this hypothesis, is the
fact that the effect of contributions was indeed not the same, when comparing
pro environmental and anti environmental sources. The differences in
pro-environmental and anti-environmental contributions is very large, see
@contrib-data, in the first place. Moreover, the environmental contributions
prove to be targeted torwards democratic representatives, possibly due to the
fact that the pro-environmental funds are limited in the first place, and thus
the contributions should be more effective, rather than the anti-environmental
contributions, which are more widely distributed, less differentiated and
greater on average. This is also to be seen in the results of the LPM, which
shows that if, not both contribution coefficients are highly significant, then
usually only the pro-environmental contributions are significant, see the
results from the LPM with legislator and year fixed effects, for example.

//  add regression results from contribs ~ other variables, to show that pro-env contributions are more targeted...

//  add regression results here from vote_change_to_pro ~ contributions (all were insiginificant, but still, should mention that both the actual vote and the vote change was regressed)

// hypothesis proven? if yes, then the results... corroborate the hypotheses

== Seniority on Vote Changes

// no multicolinearity
The third hypothesis stated in @hypothesis is that junior representatives are
more likely to change their voting behaviour due to campaign contributions than
senior representatives, given that they are not experienced enough to have
stable opinions on the matter. To analyse this, I added the afore mentioned in
@model-spec seniority and birthday (birthyear) control variables into the
regressions. Since seniority details the number of terms the representative has
partaken in and the birthyear represents the age of the legislator, I also
checked that the correlation between the two variables would not be high enough
to cause multicolinearity, which it was not, with a correlation of -0.57, and a
VIF of 1.27 and 1.28 respectively.

// general LPM and logit/probit
When looking at the LPM model with all representatives, the seniority variable
was not significant, and the birthyear variable was significant at a 0.01 level,
with a one year increase in birthyear increasing the probability of a
pro-environmental vote by 0.007 percent on average, holding all else constant.
The same trends were found when fixing the model by state and year, with the
birthyear variable being significant at a 0.001 level and having an effect of
0.013 percent increase in pro-environemtnal voting for a one year increase in
birthyear, and the seniority variable being significant only at a 0.05 level
with a one term increase in seniority increasing the environmental voting
probability by 0.018 percent. When fixing the model by legislator and year
(using plm instead of lm), the birthyear variable was not significant at all,
and the seniority variable was significant at a 0.01 level, with a one term
increase in seniority decreasing the probability of a pro-environmental vote by
0.0001 percent on average, holding all else constant. Similar results and
significance for the birthday variable emerge when fixing the legislator,
whereas the seniority variable is not significant at all.

// Interpretation
Since only birthyear is mostly significant and seniority is not, one can
conclude that younger representatives are more likely to vote pro
environmentally in these votes holding all else constant, which compared to the
results from the first hypothesis, the effect of a one year younger
representative in voting pro enviornmentally is larger than that of one unit USD
in pro environmental contributions. Whereas seniority affects the voting only
when fixing for state and year, which means that the more experienced the
representative is, the more prone they are to vote pro environmentally in these
votes.

Still, although these results show the propensity of younger representatives to
vote pro environmentally in these votes, this does not mean that young people
aremore prone to vote changes. To determine this, the the LPM model of only the
representatives who changed their votes is taken into consideraiton, yet here
neither birthyear nor seniority are significant, and thus no conclusions can be
drawn in respect to the second hypothesis.

== Partisan Contributions

In the fourth hypothesis, the effect of contributions on voting behaviour is
stated to be more significant for republican representatives than for democratic
representatives.

To check whether this might be the case I fixed not only year but also party in
the two way fixed effects LPM and Logit/Probit models. The results show that
when fixing for these two effects for the LPM of all representatives the results
are highly significant, as before. More interestingly, however, even when fixing
party and year in the two subsamples, where only representatives are included
who did (not) change their voting, the contribution coefficients are highly
significant, which can not be said when including other two way fixed effects
such as state and year, or legislator and year. This could be the case because
on the one hand, party is a dummy variable, and all other fixed effects have
more than 2 specifications, and are thus stricter models. Alternatively, since
the predicted variable is a pro-environmental vote, which in nature is affected
by ideology and politics, it is understandable as to why fixing for differences
in party lines and ideology would be more significant than fixing for other
variables.

// should i even include this hypothesis, if its just that 6mo > aggregate, already talked about this, shouldn't be a topic.
//  add recency -> vote 4,5,6 with all prior contributions, to see whether more recent contributions have higher effect than less recent ones.. (6mo prior vs. aggregate?)

// COMPARE RESULTS, ADJ R^2 ETC. WITH THE STRATMANN MODEL
// mention no-change results -> no contribution coefficient is significant...

//  final result: relation between contributions and votes can be confirmed, but not the whether contributions are the actual reason for vote changes.. so no causal conclusion to be drawn from these results.


// be critical of paper (either here or discussion)?

#pagebreak()
= Discussion and Conclusion

The main goals for the thesis was to explore the relationship of pro environmental and anti-environmental, specifically fossil-fuel, campaign contributions have on the voting behaviour of US. Representatives on the topic of methane pollution safeguard related rollcall votes. This paper finds that campaign contributions shape how the representatives votes on this particular matter. Elected officials are more likely to vote in agreement with the individual and PAC's contributions, if these interest groups contribute within six months of the vote.

Albeit including variables which track a representative's political ideology through rollcall votes (namely the DW-Nominate dimensions), and including legislator fixed effects to avoid omitted variable bias and thus including important metrics to measure causal relationships @stratmann-2002 @Selling2023, no causal relationship between environmentally related campaign contributions and changes in environmental voting behaviour could be significantly estimated. 
 
An explanations as to why no causal relationship can be concluded from this study, even though @stratmann-2002, whose methodology heavily influenced this paper, has found causality, is due to the small sample size of representatives which changed their votes over the course of the six votes, and the nature of the environmental topic, which is much more polarising and decisive among representative, and thus changes in voting behaviour are rare from the get-go. Moreover, whether his models were causal in the first place should be questioned in the first place, given that his assumptions for choosing the Glass-Stagall Act in the first place are shaky at times, such as that financial legislation is not of public interest and thus representatives have more voting leeway.
// question methodology by stratmann - old, compared to today?

// circle back to the intro: should we give donors such as the koch brothers even more chance to influence politics, no: change legislation to lessen the effect which money has in politics, especially for crucial issues such as the environment.
The implications of these results is that there is a clear relationship between anti(pro) environmental contributions and anti (pro) environmental voting behaviour of representatives and that dependent on the positions which representatives take, they have the possibility to earn their campaigns incredible amounts of donations, from the fossil fuel industry, for example. In a system where legislation should be made with the population in mind, the possibility of incumbents receiving campaign contributions has a bad aftertaste for the health of the american democracy @Weschle_2022b. Moreover, given the steep rise in expenditures for congressional elections over the past 20 years, the effect which moneyed interest will have on votes will likely increase.

While this paper provides valuable insights, it has several limitations, which point to opportunities for future work.

Touched upon briefly in this paper, by regressing the pro enviornmental vote of representatives with the campaign contributions not only six months prior, but also the 6mo. prior to vote contributions of all similar votes before might show that representatives take contributions of previous similar votes as a baseline to determine their current votes. 

As shown in results, methane related voting behaviour can be explained very well given the representative's party and DW-Nominate, meaning that the party line and ideology is a strong influencer for a legislators vote, and that most representatives tend to keep within those party lines. Thus, it would be interesting to analyse the campaign contributions not to individuals but parties themselves, and how this affects the party's votes on certain issues @Selling2023

Another interesting topic for research would be to analyse changes in voting behaviour given by the nature of rollcall votes. Since these happen alphabetically, representatives whose names are further along the alphabet might be incentivised to  deviate from party lines given a vote is already won/lost.

Using different sources of campaign contributions would also be an interesting approach. These include not individual and PAC contributions, but Super PAC contributions, which can be unlimited in size and cannot be directly allocated to a political candidate @griers.

Finally, another improvement to this paper would be to use more of the countless open source resources available to import campaign and representative data by using Application Platform Interfaces (API), which significantly ease the data collection process. Resources such as the congress API #footnote("to be found at: https://github.com/LibraryOfCongress/api.congress.gov/") or the tidycensus R package #footnote("documentation for which can be found at: https://walker-data.com/tidycensus/").


// -------------- CRAP LINE ------------------------
// == Legislation
// p.149 in @stratmann-2005
// - 1994 transparency act
// - Bipartisan Campaign Reform Act of 2003
// - State regulations - contribution limits,

// == campaign contributions & elections -> less important for analysis
// - coate, if special interest contribution, less voters, more contribution (voters suspicious of favor trading) @stratmann-2005
// - Asymmetry in effectiveness of spending, endogeneity and OVB
// - difficult to find causal effect between contributions and vote shares @stratmann-2005 p.137-138
// - also, sometimes more campaign contributions because of tighter race, so negative correlation vote share and contribution (OVB - competition, bipartisan factors) @stratmann-2005 p.138
// - bias stronger in house, than senate, p.138
// - spending not accurate representation for campaigning, diff. Montana and LA.
// #acknowledgement()
// #abstract_de()
