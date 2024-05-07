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
environment @skocpol2016koch. Additionally, the US bipartisan system has
recently become more polarised @polarisation. The public's perceptions mirror
these trends: 84 percent of US residents think that money influences politics
excessively and express a desire to see changes made to the campaign finance
system to lessen the influence of wealthy donors @bonica p.1.

The Koch brothers (David and Charles), are one of these influential donors, who
have a multifaceted approach when it comes to their involvement in US politics.
On the one hand, they shape the "mindset" of the US population through organised
groups, think-tanks and networks of other mega-donors with similar political and
social ideologies, such as the Koch Network @Hertel-Fernandez_Skocpol_Sclar_2018
p.1.
//  i know the quote is wrong..
#set quote(block: true)
#quote(
  attribution: [Skocpol @skocpol2016koch p.8],
)[
  The Koch network is not just a[n]... undisciplined array of advocacy groups and
  political action committees to which the principals send checks. Instead, the
  network has by now evolved into a nationally federated, full-service,
  ideologically focused parallel to the Republican Party.
]

On the other hand, the Koch Industries, headed by Charles Koch, not only
influence elections through their Network, but they donate insane sums of money
to fund the electoral campaigns of Republican presidential and congressional
candidates @skocpol2016koch. Especially over the past ten years, Koch Industries
have increased their campaign contributions by at least 10% per election cycle,
amounting to 28 Millon USD in the 2022 election cycle, with approximately 90-97%
of these congressional contributions going to Republican candidates
@OpenSecretsKochIndustries.

Given these trends of campaign contributions in the US Congress, and especially
the participation which wealthy (fossil fuel) donors like the Koch brothers have
in these elections, the question is why donors such as these contribute immense
sums such as these to congressional elections? It is to assume that
profit-maximizing firms such as the Koch Industries do not merely contribute
millions of USD to congressional campaigns without considering their "bottom
line" @stratmann-2017 p.13. Thus, the question is what campaign contributors are
to receive in return for their donations.

Given Charles Koch's position at the Industry and fossil fuel related
conglomerate Koch Industries and David Koch's history in climate change denial
@doreian2022koch pp. 2-8, and their donor and advocacy roles in the United
States, makes one wonder what the consequences of fossil fuel related campaign
contributions to the US congress could mean for US environmental policies.

These questions will be analysed in this paper, i.e. examining the influence of
energy (fossil fuel and environmental related) contributions on the voting
behavior of US House members on methane pollution bills. The Analysis is based
on the Paper of Thomas Stratmann @stratmann-2002, who exploits the time series
nature of contribution and votes to approach a causal identification strategy to
measure the effect of financial contributions on rollcall votes. Regarding
campaign contribution, however, @stratmann-2002 uses the aggregate contributions
for each election cycle, whereas in his 1995 paper @stratmann-1995, only the
contributions leading up to the vote are included, regardless of election cylce.
In this paper, both contribution data approaches will be included.// if i use 1995 stratmann's "data", then shouldn't I also include his models ?

The chapter 2 of this paper will give a short literature review on the economics
and political science perspectives on money in politics, with a focus on the
causal relationship between campaign contributions and the representatives'
voting decisions. Chapter 3 presents the research design, details the reasoning
behind analysing environmental legislation and the methane pollution rollcall
votes in particular, and presents the hypotheses regarding the effect of
contribution on voting decisions. Chapter 4 presents the data types and
processing for the analysis, and chapter 5 presents the models used. Chapter 6
reports the results, chapter 7 provides the discussion of these, and chapter 8
concludes the paper.

#pagebreak()

= Money in Politics <moneyinpolitics>

// three types of money in politics
To understand the relationship between campaign contributions and
representatives' voting decisions, the background for money in US politics needs
to be introduced. Political Scientist Simon Weschle defines three types of money
in politics, namely self-enrichment, campaign contribution and golden parachute
jobs, where the first type happens when politicians are in office, and receive
resources from special interest groups. Politicians receive campaign
contributions during elections, to fund their campaigns. According to Weschle,
the last type of money in politics is the golden parachute jobs, which are
financially lucrative positions offered to ex-politicians @Weschle_2022c.

== Campaign Contributions
// why focus on campaign contributions - largest increase?
Although each of these types of money in politics has significant and different
repercussions for democracy @Weschle_2022c, campaign contributions in US
politics are of particular significance for this paper. One of the reasons for
this, is that there has been a stark increase in contributions to political
campaigns over time @stratmann-2017 p.1 @stratmann-2005 p.141. The average
contributions to members of congress have increased as well within the last 40
years. Since the 2024 election cylce is due in November 2024, the contributions
there are not comparable to 2022 yet.

#figure(image("figures/avg_contrib_house.jpg", width: 100%), caption: [
  Average Contributions to House Members, 1990-2022
])

#figure(image("figures/total_contrib_congress.jpg", width: 100%), caption: [
  Total Cost of Election, 1990-2022 @OpenSecretscostofelections
])

// legislative background
One of the main reasons for the noted increase in not only total campaign
contributions over the last 30 years, but also the average campaign contribuions
per representative might be attributable to the change in legislature. In 2010,
the US Supreme Court passed the landmark court case Citizens United v. Federal
Election Commission (FEC), which treated the question of whether Congress has
the authority to limit independent expenditures by corporations. Campaign
contributions are usually structured as individual and Political Action Comittee
(PAC) contributions in OpenSecrets data, with the former stemming from natural
persons, and the latter from comittees representing corporation or labor
interests @OpenSecretspac. The Citizens United v. FEC case declared that natural
and legal persons, i.e. persons and corporations have the same campaign spending
rights when it comes to the US congress @foreman p.194. In essence, this case
enabled independent expenditures which are election related to become unlimited
@citizen.

// why do candidates need contributions?  -  improve election values
That campaign contributions have increased over the years, and one of the
reasons for this increase, is clear. Still, the necessity of campaign
contributions should still be clarified. US Citizens who would like to become
members of the United States Congress, such as the House of Representatives,
which is what this paper focuses on, need to become elected through a bi-yearly
congressional election. To improve chances of election, these candidates get
financial contributions, which they spend on advertisments, rallies and handouts
to attract more votes @Weschle_2022c p.24.

// Reason for Contribution
Although it is clear that candidates need contributions to fund their campaigns,
the question remains: why would corporations via PACs or individuals give money
to candidates which these will not return? Stratmann makes the assumption that
since corporations are inherently for-profit, they
"don’t make contributions for reasons that do not benefit their bottom line",
meaning that companies' campaign spending is strategic @stratmann-2017
@Denzau-Munger-1986 @Weschle_2022c p.25. What these companies receive in return
for their contribution, however, is unclear @stratmann-2017. Stratmann defines
three types of goals for contributions, the first is access to the candidate,
the second is to influence election and the third is to contribute to the
candidate most likely to win @stratmann-2005 p.146 @stratmann-2017 p.13. Weschle
determines that what campaign donors receive in return to contributing to
candidates is either influence, meaning they change the opinion of the candidate
by contributing to their campaign, or the support of a candidate that has your
interest at heart. Specifically small scale contributors follow both methods
@Weschle_2022c pp.26-28.

// Überleitung, reason for contribution to correlation between 2 vars
Besides the literatur dicussing the reasons for campaign spending, the question
is also whether there is a positive correlation between candidates receiving
contributions and receiving increased vote shares. If this were the case, then
campaign spending would be more straightforward, since this would mean that
successful election can be assumed.

== Correlation Contributions & Candidate's election sucess
// -> CHANGE THIS SECTION - NOT CONTRIBUTION AND VOTE SHARES, BUT CONTRIBUTION AND VOTES IN CONTRIBUTORS INTEREST
// can we assume correlation?
// keep this section?

One would assume that receiving more campaign contributions would relate to a
higher chance of getting elected, yet there is no clear correlation between
campaign contributions and the vote shares which candidates receive
@stratmann-2005 @Weschle_2022c p.24. In fact, there are a host of factors that
influence the amount of campaign contributions of politicials, which are often
endogenously (?) estimated for vote shares @Weschle_2022c p.24.

// factors to include to explain correlation between contribs & votes
Geographical factors play a role in contribution, for example. A contribution
amount is worth more in some congressional districts than in others, since costs
like rallying and advertising are priced differently @stratmann-2009. Similarly,
contribution limits imposed on certain US states cap the contribution amount
candidates may receive @Weschle_2022c p.25, and candidates from states with
larger governments receive more contributions on average @stratmann-2005 p.148
@bronars-lott-1997. Factors which depend on the nature of the election also
influence the level of contributions, since expected closeness of the election
outcome also changes the average contribution amounts, i.e. incumbents who
expect their position to be threatened will be incentivised to spend more
@Weschle_2022c, @stratmann-2017 p.8. p.25. The partisan "leaning" of the state
also determines which candidates are up for race @stratmann-2017 p.9. PAC
contributions in particular depend on the incumbency status of the candidate,
since incumbents receive more contribution on average @Selling2023
@fouirnaies2014financial. When academic papers such as that of @Weschle_2022c
include factors such as those above, increased campaign spending does relate to
higher vote shares for representatives.

== Correlation Campaign Contributions & Votes in Contributor's favor

In general, consensus that there is no link between PAC contributions and votes
in that PACs favor @Selling2023 p.1 @fellowes-wolf2004 p.315, @fiorina1999new
p.216

- correlation between contributions and votes is given due to the support
of similar interests, so we have simultaneous equation bias @stratmann-2002 p.1
@burris2001two @chappell. (can be found in the section below)

- One major issue arises due to
possible reverse causality, meaning that while contributions have an impact on
roll call votes, it is also possible that legislators who cast roll call votes
which are favorable to interest groups receive contributions from these groups."
@stratmann-2017 p.14 (can be found in the section below)

== Causal Effect of Campaign Contributions on Representatives' Voting Decisions.
Even if we have correlation between campaign contributions and the votes in the
contributers interest, it is still important to determine from which side the
causation runs. Do incumbents cater to wishes of special interest groups,
because of their contribution or do they get contribution because their views
coincide with the special interests groups @stratmann-2005 p.143 @KauKeenanRubin
p.275? Similarly, it is difficult to distinguish between two possible
explanations for donations to politicians: either donors merely sympathise with
and support politicians who share their views, or donations actually influence
the politicians' decisions (i.e., donations actually buy votes)
@bronars-lott-1997 @chappell p.83.

// check again whether indirect effects were found in these papers.
Several researchers have tried to identify a causal relationship between voting
and contributions and have not found effects, such as Bronars & Lott, which
analysied how the voting behavior of politicians changed when they did not stand
for re-election. Ideally, politicians should represent their ideology, even
without facing threat of re-election, yet if their vote is "bought" then their
contributions and voting behaviour changes, since the cost of shirking decreases
@bronars-lott-1997 p.319.

Others, however, have found that contributions change voting behaviour:
Stratmann analysed the timing of contributions, and instead of analysing how the
contributions of the previous cycle relates to the voting behaviour of
politicians, Stratmann took the contributions from current election cylces,
since short term contributions are more relevant for voting behavior, according
to him @stratmann-1995. Betrand deduces that lobbying companies provide special
interest groups access to politicians when contributing (as opposed to giving
only issue specific information to congress members), and finds indirect
evidence of this @Bertrand @matter. Baldwin and Magee also find linkages of
rollcall votes on specific trade agreement related bills and the contributions
from businesses and labor groups @baldwinmagee. McAlexander, in his paper on the
electoral gap in evironmental voting shows that "Candidates that receive
generous campaign contributions from the oil and gas industry increase their
pro-environment voting at election time, because they understand that the
public's preference for environmental protection is stronger than that of the
oil and gas industry" @McAlexander2020. Also Mian et al. find that campaign
contributions alter rollcall votes @mian.

Given that some results find causal relationships between contirbutions and
others find no effect, one can conclude that there is no academic consensus on
this matter @stratmann-2017 p.13. Moreover, it is difficult to ascertain from
which direction the causation runs, there has been little causal evidence to
identify "the causal direction of donations on legislators’ voting decisions"
@matter p.6. Part of the reason there is no academic consensus on causal
relationships is because of the nature of the studies, which are cross-sectional
in design, where correlation between contributions and votes is given due to the
support of similar interests, so we have simultaneous equation bias
@stratmann-2002 p.1 @burris2001two @chappell.

The studies which found causal links between campaign contributions and voting
behaviour have a common denominator: research in particular fields or
legislation. Baldwin and Magee, for example, @baldwinmagee analysed trade
agreement related bills, @stratmann-2002 analysed financial bills
@stratmann-1995 @kang2015 @stratmann-1995 and the timing of financial
contributions, and found significant effects. Hence, one needs to analyse "specific
votes and a rather narrow policy setting" @kang2015 @stratmann-1991 p.607
@chappell.

Moreover, Stratmann critisises that most studies done in the field lack "a
convincing identification strategy to estimate the causal effect of campaign
contributions on legislative voting behavior. One major issue arises due to
possible reverse causality, meaning that while contributions have an impact on
roll call votes, it is also possible that legislators who cast roll call votes
which are favorable to interest groups receive contributions from these groups."
@stratmann-2017 p.14

Common criticism in the field is attributed not only to studies whose analysis
does not focus on a specific legistlation or account for reverse causality, but
also those who do not control for individual counties and geographical areas
@stratmann-2005 p.142. Moreover, by looking at repeated votes and thus changes
in voting behaviour, a link can be determined between contribution and voting
@stratmann-2005 p.143-144 @stratmann-2002. Considering a closer time-frame for
contribution has also proven to increase plausibility @stratmann-1995.

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
This section will deal with the reasoning behind the chosen votes (and
contributions) for the analysis, and the hypothesis which are set up for the
analysis.

== Roll Call Vote Specifications from Stratmann <vote_spec>
// Conditions met: Vote repition, winners & losers defined,
Thomas Stratmann @stratmann-2002, who in his 2002 paper follows a similar
methodology to determine the causal relationship between campaign contributions
and the representative's vote shares, defines the following rollcall votes
preconditions for his research: the votes are not only repeated but also exhibit
changes in voting behaviour @KauKeenanRubin p.276 @stratmann-2002. Moreover, the
winners and losers of the votes need to be defined, the precise subject voted on
should not be repeated again, this way patterns in contribution and voting
behaviour can be deduced more easily. These conditions are met in this analysis.
There are six roll call votes which are related to methane pollution safeguards
(i.e. the methane emissions of fossil fuel companies), and these are not
repeated to this date, since the vote relates to the acceptance or rejection of
an increase in environmental regulation, the winners and losers of the votes are
clearly defined.

// Conditions not met: clearly articulated positions, contribution industry size
There are conditions, however, which Stratmann sets up which are not met in this
paper. On the one hand, he stipulates that the research should treat a topic
where representatives "do not typically take clearly articulated positions in
their voting campaigns” @stratmann-2002 p.4. This is not met here, since
environmental positions are polarising, and most legislators have clear
positions on environment, due to their party line, or also their personal
conviction @McAlexander2020. Stratmann also states that substantial amounts of
representatives should receive campaign contributions from the relevant interest
group, here pro- and anti environmental and fossil fuel related contributions.
This is split in this paper, since a substantial amount of legilators receive
more from fossil fuel industry, and the Energy and natural resources interest
groups was the 9th biggest interest group contributor in 2022 with a total of
196 Billion USD contributed over the 2022 congressional election. The
environmental contributions, on the other hand, are a fraction of this
@OpenSecretsInterestGroups. Thus, it is more difficult to compare the
contribution sizes of these interest groups. Lastly, Stratmann determines that
there need to be changes in voting behaviours of the representatives, yet in
this case, only 23 representatives out of 529 change their vote over time.// insert mind changers plot here (confirm 23/529?)

== Topic of Roll call Votes (Methane Pollution Safeguards) <rollcall-subject>

Although as shown in the section above, the rollcall bills do not fit the
preconditions stipulated by Stratmann in @stratmann-2002, analysing
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
congressional session Rollcall Vote 601 of Bill Number: H. R. 2728, the
Protecting States' Rights to Promote American Energy Security Act, would
preserve the Department of the Interior's ability to reduce methane emissions
from oil and gas drilling operations on public lands. @lcv2013 The 2016, 114th
congressional session Roll Call 434 of Bill Number: H. R. 5538, the Department
of the Interior, Environment, and Related Agencies Appropriations Act, 2017,
would include a rider into the main bill to stop the EPA from enforcing its
recently determined methane pollution regulations, which are the first-ever caps
on methane emissions from new and altered sources in the oil and gas industry.
@lcv2016 The 2017, 115th congressional session Roll Call 488 of Bill Number: H.
R. 3354, would hinder the Environmental Protection Agency's efforts to control
methane emissions from newly created and altered sources inside the oil and gas
industry. @lcv2017 The 2018, 115th congressional session Roll Call 346 Bill
Number H. R. 6147, would hinder the Environmental Protection Agency's (EPA)
efforts to decrease methane emissions in the oil and gas industry from both new
and modified sources from the oil and gas industry @lcv2018 The 2019, 116th
congressional session Roll Call 385, Bill Number H.R. 3055, would hinder the
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
departments, but also precisely the methane pollutions and -emissions, not just
any environmental pollution, and these bills specify the methane pollution
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
are usually of public interest indicates that most representatives have
predetermined environmental positions and are less likely to change these
throughout their time in office @McAlexander2020. This can also be seen in the
data from the rollcall votes @mind-changers. Hence, this paper predicts that the
effects of pro-environmental or anti-environmental contributions on the
enviornmental voting behaviour of representatives will be minimal, if
significant.

@stratmann-2002 shows that for junior representatives, the marginal effect of
contribution was greater, whereas senior representatives were more steadfast in
their positions. Similarly, this paper/model predicts that legislators that are
in their first to third session are more likely to change their voting.// change if dummy seniority, not 1-3 if necessary!!!

Given the differences in contribution sizes from the various interest groups,
see @vote_spec, i.e. oil and gas (thus anti-environmental) individuals and
interest groups contribute significantly more to congressional elections than
pro-environmental individuals and interest groups, the third hypothesis states
that changes from pro-env. to anti-env. votes will be more positively related
with anti-environmental contributions, and the pro-env. votes being less
significant and less "effective", given their lessened propensity to contribute
to representatives.

Lastly, since @stratmann-1995 stipulated that contributions which are given
shortly before the vote have higher impacts on congressional voting behavior
than contributions from the past election cylce. Taking this into consideration,
the fourth hypothesis is that votes in a time frame of six months prior to the
vote will have more significant effects on voting behaviour than contributions
from the congressional session before, since the amount of contributions change
compared to the timing of votes @stratmann-1998.

// causal hypothesis where?

#pagebreak()
= Data

The empirical framework stipulated in @research-design requires the comparison
of voting behaviour of the US representatives and the campaign contributions
which these received. Hence, the data for the analysis consists of three data
types joined together: Data on the Representatives, their contribution data and
the rollcall data. The following chapters consists of the description of the
data types, where they were sourced, and the data processing for the analysis.

== Representative data <rep-data>

To be able to conduct the analysis, a comprehensive dataset of all US
representatives who participated in the relevant congressional sessions
(113th-117th) was needed, which includes biographical information, to be able to
control for age, gender, etc. in the analysis. Moreover, identification was
needed, to be able to assign each rollcall vote and contribution definetly to a
certain representative, and not have to deal with matching issues.

Given these requirements, the data on the US representatives was sourced from
the github repository congress-legislators, which is created and managed by a
shared commons, and includes detailed information for all historical and current
US congressional members, including various IDs they have across US legislative
data providing platforms. Since the above data is not ordered according to
congressional sessions which each representative partook in, data from @bioguide
was used match the data on current and historical legilsators with a list of the
representatives participating in each seperate congress.

== Rollcall data

As @stratmann-2002 stipulated in his paper, to be able to analyse changes in
voting behaviour, the cross-sectionality of panel data needs to be exploited,
and the votes need to be categorised clearly into winners and losers. This also
means, that one needs to be able to deduce from the votes which candidates voted
pro- one special interest group, and anti- the other one.

Due to this specification, the data from the League of Conservation Votes
Scorecard was used throughout this paper. The website is predetermines which
rollcall votes are pro-environmental and which are anti-environmental. One of
the major downsides of using this data, however, was that the LCV Scorecard did
not use IDs to prior to 2021, meaning that only in the last vote were IDs
matched to each representative. Although approximately 60% of representatives
present in the last rollcall vote, were also present in the votes prior and thus
were able to be matched by IDs, about 40% of the representatives had to be
matched by first and lastnames, parties and states, only, which caused merging
errors, which will be detailed more in @merging.

Considering these circumstances, utilizing one of the many other rollcall data
providing websites, such as Govtrack US, Congress.gov and C-Span would have been
more useful, since these match representatives with a unique identifier. This
was not possible, however, because these websites do not publish all rollcall
votes but only the most relevant, i.e. the votes which passed a bill. For this
analysis, however, the environmentally related rollcall votes are to be
analysed, and these are often not published on the aforementioned websites.
Thus, the LCV Scorecard Website was used to source rollcall data, despite their
incomplete use of IDs for representatives.

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
To overcome this, the R package fuzzyjoin @fuzzjoin was used. Using the function
fuzzy_match and fuzzy_full_join, a maximum distance between two values can be
determined, here 5 characters. in the fuzzy_full_join, I defined that the names
between the two dataframes can be matched if they are at most 5 characters
distance from one another, while the variables Party and District need to be
identical to match.

== Contribution data <contrib-data>

// decision 6mo vs. aggregate.
// CHANGE ANALYSIS - IN AGGREGATE, TO MATCH THIS. FIRST VOTE = POST VOTE ELECTION
As discussed in @intro, Stratmann uses two different approaches to measuring the
effect of campaign contributions on voting behaviour. In his @stratmann-1995
paper, Stratmann explores whether contributions closer to the vote are more
important in determining voting behaviour than contributions of previous
congressional elections. He concludes that current election contributions in his
case of dairy legislation, are more determining for voting behaviour than that
of the previous election. In the @stratmann-2002 paper, Stratmann uses the
aggregate campaign contributions allocated to representatives in the election
post and prior to the congressional session, i.e. contributions from the
1989-1990 and 1995-96 vote to explain the 1991 and 1998 vote and the
contributions from the election happening paralell to the vote i.e. Stratmann
uses the 1991-92 and 1997-98 contributions to guage whether there are
punishments or rewards for the representative's voting behaviors. In both cases,
he finds positive correlation between contributions of current and prior
elections from special interest groups and a vote in their favor, of which one
can conclude, that multiple congressional election contributions should be taken
into account for each vote.

To account for these differences in campaign contribution selection, I explored
both options: On the one hand, I calculated the contribution variables based on
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

When looking closely at what kinds of contributions are included in the six
months prior, the following pattern emerges:

// table for contributions (2013 vote = 2012, 2010, 2014...)
// plot for cutoff date and contributions.

//     2012 0 contribs, 2014 3000, 2016 2000...
// - sources: opensecrets bulkdata campaign contributions (election data 2012-2022)
// - data were PAC contributions to candidates and individual contributions (to PACs,
//   candidates, etc.) -> source: opensecrets bulk data documentation

Validate Decision on which types of contributions to use based on:
#quote(
  attribution: [@Selling2023],
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

// *Determine which financial data to use for analysis - time related or aggregate,
// the non-used analyses can be found in the Appendix*

//   not https://sunlightlabs.github.io/datacommons/bulk_data.html because only goes
//   till 2014..
// - why not DIME...
// - why not Sunlightlabs
// - Stratmann works with campaign contributions from the electoral campaigns of
//   house members, i analyse these too, and additionally include votes of only 6 mo.
//   prior to vote, to accomplish 2 things: acct for 2 votes on methane pollution
//   safeguards in 115th congress and bec. more accurate, acc to @stratmann-1995 not
//   only election period before, but current one, next one (all overlap in time of
//   contribution.)
//   - *plot* contributions from before (e.g. relevant contributions over time, with
//     cutoff date, 2012 (misses vote 6mo. prior completely, 2014 right in the middle,
//     2016 in between))
//   - *plot* stats of the composition of the 6 mo. prior to vote contributions i.e.

- *data processing:*
- created scripts!
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
- same with tidycensus, also API based

== Merging <merging>
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

Why not 2SLS -> @stratmann-2002 p.1

// - model setup: must allow for endogeneity of contributions, dichotomus nature of
//   dependent vote variable (yes/no) and non-negativity of campaign comntributions.
//   @stratmann-1991 p.606

== Model specification
+ confounding variables
  - argue why the important effects are included.
  - confounding effects -> needed for causal econometrics
  - deterine through literature what needs to be included:

variables we control for (using fixed effects):
- party
- legislator fixed effects (aka)
- state (geoographical area) ?
- district (for robustness)
- age of legislators
- party which had majority during session @McAlexander2020 p.47 @stratmann-2002
- the LCV data include a variable indicating the issue the bill relates to, so
  that we can control for cross-issue variation that may drive the results.
  @McAlexander2020 p.48 -> all the same for me? drilling...
- DW-Nominates (dynamic weighted Nominates)
  - DW Nominates are are a broadly applied measure of a representative’s policy
    position in a multi-dimensional policy space that are computed based on
    roll-call records @matter p.40
  - @rosenthalpoole "It is widely acknowledged that DW-Nominate
  scores are strong predictors of representatives’ voting behavior
  - Data on DW-Nominate scores is provided by voteview.com.
  - gives the propensity of each representative to vote yes/no given given their
    first and second dimension DW-Nominate score values of the respective congress
  - "Ideological positions are calculated using the DW-NOMINATE (Dynamic Weighted
    NOMINAl Three-step Estimation). This procedure was developed by Poole and
    Rosenthal in the 1980s and is a "scaling procedure", representing legislators on
    a spatial map. In this sense, a spatial map is much like a road map--the
    closeness of two legislators on the map shows how similar their voting records
    are. Using this measure of distance, DW-NOMINATE is able to recover the "dimensions"
    that inform congressional voting behavior. The primary dimension through most of
    American history has been "liberal" vs. "conservative" (also referred to as "left"
    vs. "right"). A second dimension picks up differences within the major political
    parties over slavery, currency, nativism, civil rights, and lifestyle issues
    during periods of American history." @voteview
  - here how to do it in R ->
    http://congressdata.joshuamccrain.com/visualization.html (create abs(), )
- environmental catastrophy?
- control for individual (how to include individual, if not ID, doesnt work well)
- log transformation of contribution..

confounding vars from statmann: @stratmann-2002 p.12-13
- employment in banking, insurance nad investment industries
- indicator for party majority in the house
- percentage of last popular votes which members received
- DW-Nominates absolute deviation from the party mean

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
+ all contribs prior to vote
  - this way we avoid recency bias and see whether long term relationships matter
    after all...@stratmann-1995
+ mind-changers OLS
  - df FE (base year, pivot longer, ∆contribution, person-FE)
  - only incl. mind changers (only variations in voting behavior are relevant
    @stratmann-2002 p.11)
  - vote change in which direction (pro -> contra env = 0?) & vice versa

- When arguing why use unit and time fixed effects ...
@Imai-Kim-2019
== Two-way Fixed Effects model
Argue why use this with @Imai_Kim_2021 -> use this vorlage:
http://congressdata.joshuamccrain.com/models.html
+ basic OLS
+ sessionized OLS
+ all contribs prior to vote OLS
+ mind-changers OLS

== Logit / Probit (which Stratmann used)
- literature on why OLS is bad, and logit/probit is good. (since LPM not 0-1, so
  negative effects nicht schätzbar?)
- as Robustness Checks, since OLS sometimes over/underestimates @stratmann-2005
  p.143
- Stratmann uses a conditional fixed effects logit model @Allison @Chamberlin
  @stratmann-2002
- Stratmann uses probit model (only those who changed mind)
+ basic OLS
+ sessionized OLS
+ all contribs prior to vote OLS
+ mind-changers OLS

#pagebreak()
= Results

#pagebreak()
= Discussion
- Not only does this have dire consequences for democracy (e.g. wealthy donors
  being able to influence policy) @Weschle_2022b
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
- use DW-Nominate to make study more robust... compare partisan lines -> MENTION
  IN FOOTNOTES WITH ROBUSTNESS/ MODEL
- this can lead to OVB, since "has no good measure for whether a challenger poses
  a threat" -> by using 2SLS we can overcome this @stratmann-2017 p.9

#pagebreak()
= Conclusion

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