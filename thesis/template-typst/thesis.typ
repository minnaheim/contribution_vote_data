#import "thesis_template.typ": *
#import "common/cover.typ": *
#import "common/titlepage.typ": *
#import "thesis_typ/acknowledgement.typ": *
#import "thesis_typ/abstract_en.typ": *
#import "common/metadata.typ": *
#import "@preview/glossarium:0.4.0": make-glossary, print-glossary, gls, glspl
#show: make-glossary

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
environment @skocpol2016koch, alongside the Two-Party system becoming more
polarized @polarisation. The public's perceptions mirror these trends: 84
percent of US residents think that money influences politics excessively and
express a desire to see changes made to the campaign finance system to lessen
the influence of wealthy donors @bonica[p.~1].

But how do campaign donors influence politics? The prime example is the brothers
David and Charles Koch, who are one of the most influential donors, and have a
multifaceted approach when it comes to their involvement in US politics. On the
one hand, they shape the mindset of the US population through organized groups,
think tanks, and networks of other mega-donors with similar political and social
ideologies, such as the Koch Network @Hertel-Fernandez_Skocpol_Sclar_2018.

On the other hand, the fossil fuel conglomerate Koch Industries, headed by
Charles Koch, funds the electoral campaigns of Republican presidential and
congressional candidates @skocpol2016koch and have spent more than 123 million
USD on elections. Especially over the past ten years, Koch Industries have
increased their campaign contributions by at least 10% per election cycle,
amounting to 28 million USD in the 2022 election cycle, with approximately
90-97% of these congressional contributions going to Republican candidates
(https://www.opensecrets.org/orgs/koch-industries/summary?id=d000000186).

Given the participation that wealthy fossil fuel donors like the Koch brothers
have in US elections, the question is why donors such as these contribute
immense sums to congressional elections. Surely, profit-maximizing firms such as
the Koch Industries do not merely contribute millions of USD to congressional
campaigns without considering their return on investment @stratmann-2017. Thus,
the question is what campaign contributors are to receive in return for their
donations. Charles Koch's position at Koch Industry, David Koch's history in
climate change denial @doreian2022koch[pp. 2-8], and their donor and advocacy
roles in the United States make one wonder what the consequences of fossil
fuel-related campaign contributions to the US Congress could mean for US
environmental policies.

These questions will be analyzed in this paper. The influence of fossil fuel and
environmentally related contributions on the voting behavior of US House members
on methane pollution bills will be analyzed. The analysis is based on the paper
of #cite(<stratmann-2002>, form: "prose"), who exploits the time series nature
of campaign contributions and roll-call votes to approach a causal
identification strategy to measure the effect of financial contributions on
roll-call votes. Regarding campaign contribution, however, #cite(<stratmann-2002>, form: "prose") uses
the aggregate contributions for each election cycle, whereas, in his 1995 paper,
only the contributions leading up to the vote are included, regardless of
election cycle @stratmann-1995. Although both contribution types are explored,
this paper will focus on the latter contribution type for the final analysis.// if i use 1995 stratmann's "data", then shouldn't I also include his models ?

@moneyinpolitics will give a short literature review on the economics and
political science perspectives on money in politics, with a focus on the causal
relationship between campaign contributions and the representatives' voting
decisions. @research-design presents the research design, details the reasoning
behind analyzing environmental legislation and the methane pollution roll-call
votes in particular, and presents the hypotheses regarding the effect of
contribution on voting decisions. @data presents the data types and processing
for the analysis and @models presents the models used. @results reports the
results and @disc provides the discusses the results and concludes the paper.

#pagebreak()

= Money in Politics <moneyinpolitics>

// three types of money in politics
To understand the relationship between campaign contributions and
representatives' voting decisions, the concept for money in US politics needs to
be introduced. #cite(<Weschle_2022c>, form: "prose") defines three types of
money in politics, namely self-enrichment, campaign contribution, and golden
parachute jobs. The first type happens when politicians are in office, and
receive resources from special interest groups. The second is when politicians
receive campaign contributions during elections to fund their campaigns.
According to Weschle, the last type of money in politics is the golden parachute
jobs, which are financially lucrative positions offered to ex-politicians.

== Campaign Contributions
// why focus on campaign contributions - largest increase?
Although each type of political funding has significant and distinct
repercussions for democracy and the voting behavior of politicians
@Weschle_2022c, campaign contributions in US politics are of particular
importance for the analysis presented in this paper. One reason for this, is
that there has been a stark increase in contributions to political campaigns
over time @stratmann-2017[p.1] @stratmann-2005[p.141]. With both aggregate and
per legislator campaign contributions increasing within the last 40 years,
understanding the reasons behind the donations could help researchers and
policymakers deal with this issue.

#figure(
  image("figures/avg_contrib_house.jpg", width: 100%),
  caption: [
    Average Contributions to House Members#footnote(
      "Since the 2024 election cycle is due in November 2024, the contributions are not comparable to 2022 yet",
    ), 1990-2022, Source: @opensecretscontribs
  ],
) <avg-contributions>

#figure(
  image("figures/total_contrib_congress.jpg", width: 100%),
  caption: [
    Total Cost of Election#footnote("where * stands for a Presidential Election Cycle, 1990-2022"),
    Source: @OpenSecretscostofelections
  ],
) <cost-of-election>

// legislative background
One of the primary reasons for the noted increase in both the total costs of
presidential and congressional elections over the last 30 years, as well as the
average campaign contributions per representative, is a significant change in
legislation. In 2010, the US Supreme Court ruled on the landmark case Citizens
United v. Federal Election Commission (FEC). This decision addressed whether
Congress could limit independent expenditures by corporations. Traditionally,
campaign contributions are structured as individual and Political Action
Committee (PAC) contributions, as shown in #cite(<opensecretskoch>, form: "prose") data.
Individual contributions are those over 200 USD made by natural persons who are
employed in the industry, or their family members @griers, whereas PACs
represent corporate or labor interests @Weschle_2022a. The Citizens United v.
FEC ruling affirmed that both natural and legal persons—individuals and
corporations—possess equivalent rights to spend on US congressional campaigns
@foreman[p.194]. This decision ultimately allowed for unlimited independent
expenditures related to elections#footnote(
  "United States Citizens United v. Federal Election Commission, January 21, 2010",
).

// why do candidates need contributions?  -  improve election values
Even if campaign contributions have risen over time, the reason as to why
politicians receive them should be clarified. US Citizens who would like to
become members of the United States Congress, such as the House of
Representatives, which is the chamber of Congress which this analysis focuses
on, need to become elected through a bi-yearly congressional election. To
improve the chances of election, these candidates get financial contributions,
which they spend on advertisements, rallies, and flyers to attract more votes
@Weschle_2022c[p.~24].

// Reason for Contribution
Yet, why would corporations donate to candidates via PACs or individual
contributions, if their contributions are not returned? Stratmann makes the
assumption that since corporations are inherently for-profit, they do not donate
to organizations without wanting to profit from doing so. Economists and
political scientists hypothesize that companies' campaign spending is strategic
@stratmann-2017 @Denzau-Munger-1986 @Weschle_2022c[p.~25]. What exactly these
companies receive in return for their contribution, however, is unclear
@stratmann-2017. Stratmann defines three possible motives for contributions: the
first is access to the candidate, the second is to influence elections and the
third is to contribute to the candidate most likely to win
@stratmann-2005[p.~146] @stratmann-2017[p.~13]. #cite(<Weschle_2022c>, form: "prose") determines
that what campaign donors receive in return for contributing to candidates is
either influence, meaning they change the opinion of the candidate by
contributing to their campaign, or the support of a candidate that has your
interest at heart, with specifically small scale contributors following both
methods.

Besides discussing the reasons for campaign contributions, the question is also
whether there is a positive correlation between candidates receiving
contributions and receiving increased vote shares. If this were the case, then
campaign spending would be more straightforward, since this would mean that
successful election can be presumed.

== Contributions and Candidates' Election successes <contributions-success>

One would assume that receiving more campaign contributions would relate to a
higher chance of getting elected, yet there is no clear correlation between
campaign contributions and the vote shares which candidates receive
@stratmann-2005 @Weschle_2022c[p.~24]. In fact, there are a host of factors that
influence the amount of campaign contributions politicians receive, which are
often endogenous to a candidate's vote shares @Weschle_2022c[p.~24].

Geographical factors play a role in contribution, for example. A contribution
amount is worth more in some congressional districts than in others, since costs
like rallying and advertising are priced differently @stratmann-2009. Similarly,
contribution limits imposed on certain US states cap the contribution amount
candidates may receive @Weschle_2022c[p.~25], and candidates from states with
larger governments receive more contributions on average @stratmann-2005[p.148]
@bronars-lott-1997. Factors that depend on the nature of the election also
influence the level of contributions, since the expected competitiveness of the
election outcome also changes the average contribution amounts. Incumbents#footnote("A current office holder seeking re-election.") who
expect their position to be threatened will be incentivized to gather more
donations#footnote("Donations and contributions are used synonymously in this paper.") @Weschle_2022c[p.~8] @stratmann-2017[p.~25].
The partisan lean of a state also determines which candidates are up for race
@stratmann-2017[p.~9]. PAC contributions in particular depend on the incumbency
status of the candidate, since incumbents receive more contributions on average
@Selling2023 @fouirnaies2014financial. When academic papers like that of #cite(<Weschle_2022a>, form: "prose") examine
factors such as those mentioned above, they find that increased campaign
spending is associated with higher vote shares for representatives.

== Campaign Contributions and Representatives' Voting Decisions.

When it comes to the relationship between campaign contributions from special
interests and representative's voting decisions in that interest's favor, many
researchers see a correlation. Yet, the deduction of what that means for the
relationship between campaign contributions and votes is difficult to make. Do
incumbents cater to the wishes of special interest groups, because of their
contribution or do they get contributions because their views coincide with the
special interest groups @stratmann-2005[p.~143] @KauKeenanRubin[p.~275]?
Similarly, it is difficult to distinguish between two possible explanations for
donations to politicians: either donors merely sympathize with and support
politicians who share their views, or donations actually influence the
politicians' decisions (i.e., donations actually buy votes) @bronars-lott-1997
@chappell[p.83].//  Moreover, even if interest groups fund lawmakers who support them regardless, a significant relationship between money and votes does not prove that money influences politics. Situations like these leave room for simultaneous equation bias @stratmann-2002 @burris2001two @chappell.

To overcome understand these questions, causality must be established. Yet
determining causality when there is a positive association between donations and
roll-call votes is one of the most challenging issues in the literature on
campaign finance. The idea that money may be exchanged for votes is contested by
two competing causal theories. Firstly, donors often provide to organizations
and individuals that are inclined to support their policy ideas @burris2001two.
Secondly, it is possible that donations function more as rewards or punishments
for previous roll-call votes than as catalysts for more voting @stratmann-1991.
In the first case, the ideology of the lawmaker acts as a confusing factor,
making the link between money and votes fictitious. The second situation
involves the concept of reverse causality @Selling2023 @stratmann-2017.

Given the importance of determining causal relationships for money in politics,
several researchers have tried to identify such a relationship between voting
and contributions and have not found effects, such as #cite(<bronars-lott-1997>, form: "prose"),
who analyzed how the voting behavior of politicians changed when they did not
stand for re-election. Ideally, politicians should represent their ideology,
even without facing the threat of re-election, yet if their vote is 'bought'
then their contributions and voting behavior change, since the cost of shirking
decreases @bronars-lott-1997[p.319]. #cite(<Ansolabehere>, form: "prose") analyzed
40 empirical papers and concluded that there is limited evidence indicating
interest group contributions have an impact on roll-call votes @griers.

Others, however, have found that contributions do change voting behavior:
#cite(<stratmann-1995>, form: "prose") analyzed the timing of contributions, and
instead of analyzing how the contributions of the previous cycle relates to the
voting behavior of politicians, he took the contributions from current election
cycles, since short term contributions are more relevant for voting behavior,
according to him. #cite(<Bertrand>, form: "prose") find indirect evidence of
lobbying companies providing special interest groups access to politicians when
these groups contribute (as opposed to giving only issue-specific information to
congress members) @matter. #cite(<baldwinmagee>, form: "prose") also find
linkages of roll-call votes on specific trade agreement-related bills and the
contributions from businesses and labor groups. #cite(<McAlexander2020>, form: "prose"),
in their paper on the electoral gap in environmental voting, determine that
since the public's inclination for environmental protection is greater than the
oil and gas sector's, candidates who get large campaign contributions from
businesses tend to vote more in favour of the environment when elections come
around.

Given that some results find causal relationships between contributions and
others find no effect, most researchers conclude that there is no academic
consensus on this matter @stratmann-2017[p.13]. Part of the reason there is no
academic consensus on causal relationships is because of the nature of the
studies, which are cross-sectional in design, where the correlation between
contributions and votes is given due to the support of similar interests,
resulting in simultaneous equation bias @stratmann-2002[p.1] @burris2001two
@chappell.

The studies which found causal links between campaign contributions and voting
behavior have a common denominator: research in particular fields or
legislation. #cite(<baldwinmagee>, form: "prose"), for example analyzed trade
agreement related bills, #cite(<stratmann-2002>, form: "prose") analyzed
financial bills @stratmann-1995 @kang2015 @stratmann-1995 and the timing of
financial contributions, and found significant effects. Hence, one needs to
analyze distinct roll-call votes and a rather restricted policy setting
@kang2015 @stratmann-1991[p.607] @chappell.

Moreover, #cite(<stratmann-2002>, form: "prose") criticizes that most studies
done in the field lack a convincing identification strategy to determine the
causal relationship between legislative voting behavior and campaign
contributions. One significant problem is from the possibility of reverse
causation, "meaning that while contributions have an impact on roll call votes,
it is also possible that legislators who cast roll call votes which are
favorable to interest groups receive contributions from these groups"
@stratmann-2017[p.14]. Common criticism in the field is attributed not only to
studies whose analysis does not focus on a specific legislation or account for
reverse causality, but also those who do not control for individual counties and
geographical areas @stratmann-2005[p.142] @griers. Moreover, only by looking at
repeated votes and thus changes in voting behavior, a link can be determined
between contribution and voting @stratmann-2005[pp.143-144] @stratmann-2002.
Considering a closer time-frame for contribution has also proven to increase
plausibility @stratmann-1995.

Given the extensive research done on money in politics, and the causal
relationship between campaign contributions and roll-call voting behavior, this
paper will aim to take the above stated specifications to analyze a causal
relationship between campaign contributions and roll-call votes in the
environmental context.

#pagebreak()

= Research Design <research-design>
This section will deal with the reasoning behind the chosen roll-call votes and
campaign contributions, and the hypotheses which are set up for the analysis.

== Stratmann's Specifications <vote_spec>
// Conditions met: Vote repition, winners & losers defined,
#cite(<stratmann-2002>, form: "prose"), who follows a similar methodology as
this paper, defines the following roll-call votes preconditions for his
research: the votes are not only repeated but also exhibit changes in voting
behavior @KauKeenanRubin[p.276] @stratmann-2002. Moreover, the winners and
losers of the votes need to be defined, and the precise subject voted on should
not be repeated again. This way, patterns in contribution and voting behavior
can be deduced more easily. These conditions are met in this analysis. There are
six roll-call votes which are related to methane pollution safeguards, and these
are not repeated to this date. Since these votes relate to the acceptance or
rejection of an increase in environmental regulation, the winners and losers of
the votes are clearly defined.

// Conditions not met: clearly articulated positions, contribution industry size
There are conditions, however, which Stratmann sets up, that are not met in this
paper. On the one hand, he stipulates that the research should treat a topic
where representatives do not typically take a clear stance in their election
campaigns @stratmann-2002[p.4]. This is not met here, since environmental
positions are usually quite polarizing, and most legislators have clear
positions on environment, due to their party line and also their personal
conviction @McAlexander2020.

Stratmann argues that it is crucial for representatives to secure campaign
contributions from pertinent interest groups, such as those advocating for and
against environmental and fossil fuel interests. In this paper, a significant
distinction is made because a large number of legislators receive contributions
from the fossil fuel industry. Specifically, the Energy and Natural Resources
interest groups, predominantly linked to fossil fuels, ranked as the ninth
largest contributor in the 2022 congressional elections, donating a total of 196
million USD. In contrast, contributions from environmental groups were
considerably lower @OpenSecretsInterestGroups.

//  plot about number of representatives who receive contribution
// add grid here
#grid(
  columns: 2,
  gutter: 5,
  [#figure(
      image("figures/pro_plot_contribs.svg", width: 100%),
      caption: [Histogram of pro-environmental \ contributions among representatives],
    ) <env-contribs>],
  [#figure(
      image("figures/anti_plot_contribs.svg", width: 100%),
      caption: [Histogram of anti-environmental \ contributions among representatives],
    ) <anti-env-contribs>],
)

Examining the figures above reveals distinct differences in the distribution of
pro- and anti-environmental campaign contributions. Pro-environmental
contributions are generally lower, while anti-environmental contributions tend
to be larger and more spread out. This variance is also illustrated by the
y-intercept line in the plots, which represents the average contribution to
representatives from both groups.

Thus, it is more difficult to compare the contribution sizes of these interest
groups. Lastly, Stratmann determines that there need to be a substantial amount
of changes in voting behaviors of the representatives, yet in this case, only 23
representatives out of 529 change their vote over time, see @mind-changers.// insert mind changers plot here (confirm 23/529?)

== Methane Pollution Votes <roll-call-subject>

// what are methane pollution safeguards, what are methane emissions and why are they important, why related to oil & gas industry.
// methane pollution safeguards is...

Although as shown in the section above, the roll-call bills do not fit all of
the preconditions stipulated by #cite(<stratmann-2002>, form: "prose"),
analyzing environmental policy and the propensity for representatives to deviate
based on contributions is still a relevant topic and has significant
repercussions for democracy if a causal relationship does exist.

While environmental issues are polarizing for both the public and
representatives, suggesting that representatives might have fewer incentives to
change their positions, #cite(<McAlexander2020>, form: "prose") found that most
environmental policies shift the cost burden to industries. Consequently, the
general public tends to hold a more favorable view of environmental issues
compared to the average interest group. This discrepancy suggests that if
campaign contributions were to influence voting behavior, representatives might
be more inclined to adopt positions that align more closely with the interests
of their contributors, often resulting in weaker environmental stances
@McAlexander2020.

Another reason to choose these bills for the analysis can be attributed to the
fact that, as stated above, the Energy and Natural Resources interest groups are
some of the biggest contributors to congressional elections
@OpenSecretsInterestGroups and thus also have the biggest potential to be
analyzed, since these contributions are not only large in volume but also in
distribution, as stated in @intro.

#figure(
  table(
    columns: 5,
    [*Legislation*],
    [*Roll-Call\ Vote*],
    [*Session*],
    [*Year*],
    [*Subject*],
    table.hline(),
    [H. R. 2728],
    [601],
    [113],
    [2013],
    [would maintain the authority of the Department of the Interior to cut back on
      methane emissions from gas and oil development on public lands.],
    [H. R. 5538],
    [434],
    [114],
    [2016],
    [includes a rider to prevent the Environmental Protection Agency (EPA) from
      implementing the first-ever limitations on methane emissions from new and
      modified sources in the oil and gas industry, which are the newly decided
      methane pollution standards.],
    [H. R. 3354],
    [488],
    [115],
    [2017],
    [would obstruct the EPA's attempts to regulate methane emissions from sources
      that are newly developed and modified inside the oil and gas industry.],
    [H. R. 6147],
    [346],
    [115],
    [2018],
    [would hinder the EPA's efforts to decrease methane emissions in the oil and gas
      industry from both new and modified sources from the oil and gas industry],
    [H. R. 3055],
    [385],
    [116],
    [2019],
    [would impede the EPA's attempts to reduce methane emissions from both new and
      modified sources related to the oil and gas industry.],
    [S.J. Res. 14],
    [185],
    [117],
    [2021],
    [would reverse the EPA's 2016 methane rules for sources from the oil and gas
      sector, both new and amended.],
  ),
  caption: [The Six Roll-Call Votes on Methane Pollution Safeguards analyzed in this paper],
) <roll-call-votes>

The six roll-call votes which will be analyzed in this paper, sourced at
(https://scorecard.lcv.org) can be seen in @roll-call-votes. The reasoning
behind choosing these six bills is that they all amend the resources allocated
to the EPA and the Department of Interior. Since the legislation enacted by
Congress governs the executive wing, which includes the EPA
@McAlexander2020[p.43], these roll-call votes are fundamental in gauging the
environmental opinions of representatives. Moreover, the bills are quite similar
in nature, since they all concern the same departments, and precisely the
methane pollutions and -emissions generated through the oil and gas industries,
and are thus industry specific.

Although in the #cite(<stratmann-2002>, form: "prose") paper the two roll-call
votes all pertained to the amendment of the same bill, this paper uses multiple,
closely related, roll-call votes, and thus ensures that there is more variation
in voting behavior than there would be, if only two roll-call votes were
available.

#figure(table(
  columns: 3,
  stroke: none,
  [],
  [*No Change in Voting*],
  [*Change in Voting*],
  table.hline(),
  [*Pro-Environmental Vote*],
  [259],
  [8],
  [*Anti-Environmental Vote*],
  table.vline(),
  [278],
  [23],
), caption: [Representative's Voting Positions]) <mind-changers>

Even so, out of 568 representatives who voted on more than one of the six
roll-call votes, only 23 representatives changed their voting behavior in this
analysis. Of these 23 representatives, there were 31 vote changes in total, as
seen in @mind-changers. Moreover, the frequency of these successively scheduled
votes—held in 2013, 2016, 2017, 2018, 2019, and 2021—increases the likelihood
that representatives participate in multiple voting sessions, unlike in the #cite(<stratmann-2002>, form: "prose") paper,
where the two roll-call votes were in 1991 and 1998, which are 3 congressional
sessions apart.

== Hypotheses <hypothesis>

Given the topics of the roll-call votes, see @roll-call-subject, which are
environmental in nature, and the fact that environmental issues are topics which
are usually of public interest indicates that most representatives have
predetermined environmental positions and are less likely to change these
throughout their time in office @McAlexander2020. This can also be seen in the
data from the roll-call votes in @mind-changers. Therefore, the first hypothesis
posits that if the coefficients are statistically significant, the impact of
pro-environmental or anti-environmental contributions on the environmental
voting behavior of representatives will be minimal.

Considering the differences in contributions among pro- and anti- environmental
individuals and groups, as highlighted in @vote_spec, it's evident that
anti-environmental entities, such as those in the oil and gas sector,
financially support congressional elections more substantially than
pro-environmental advocates. Consequently, the second hypothesis posits a
stronger positive correlation between shifts from pro-environmental to
anti-environmental voting patterns and anti-environmental contributions. In
contrast, pro-environmental contributions, though less substantial, are
hypothesized to have a reduced and less effective influence on voting behaviors,
given the limited financial input from pro-environmental groups and individuals

In his paper, #cite(<stratmann-2002>, form: "prose") demonstrates that junior
representatives experience a greater effect in vote change from contributions,
whereas their senior counterparts maintain more steadfast positions. Similarly,
the third hypothesis states that legislators in their early congressional terms
are more susceptible to altering their environmental voting behaviors.

Lastly, since partisan affiliation and ideology is rather polarized in the
United States @polarisation, and that usually, Republicans receive higher
campaign contributions on average, see @avg-contributions, the fourth hypothesis
states that contributions will be more effective in determining voting behavior
for Republican representatives than for Democratic representatives.

// Lastly, since @stratmann-1995 stipulated that contributions which are given
// shortly before the vote have higher impacts on congressional voting behavior
// than contributions from the past election cycle. Taking this into consideration,
// the fourth hypothesis is that votes in a time frame of six months prior to the
// vote will have more significant effects on voting behavior than contributions
// from the congressional session before, since the amount of contributions change
// compared to the timing of votes @stratmann-1998.

#pagebreak()
= Data <data>

The empirical framework stipulated in @research-design requires the comparison
of voting behavior of the US representatives and the campaign contributions
which they received. Hence, the data for the analysis consists of three
different types of data joined together: data on the representatives, their
contribution data and the roll-call data of the six votes. The following chapter
gives a short description of the data types, where they were sourced, and the
data processing for the analysis.

== Representative data <rep-data>

In order to conduct the analysis, a comprehensive dataset of all US
representatives who attended the relevant congressional sessions (113th-117th),
including biographical information to control for age, gender, etc. was used for
the analysis#footnote(
  "For reference, the biographical and financial data of US congressional members needs to be disclosed publicly, thus this is not classified information.",
). Identification was also required in order to be able to unambiguously
attribute each roll-call vote and each contribution to a particular
representative and not have to deal with matching problems.

Given these requirements, the data on the US representatives was sourced from
the github repository congress-legislators
(https://github.com/unitedstates/congress-legislators), which is created and
managed by a shared commons, and includes detailed information for all
historical and current US congressional members, including various IDs they have
across US legislative data providing platforms. Since the above data is not
ordered according to congressional sessions which each representative partook
in, data from the Biographical Directory of the United States Congress
(https://bioguide.congress.gov) was used to match the data on current and
historical legislators with a list of the representatives participating in each
separate congress.

== Roll-call data <roll-call>

As Stratmann stipulated in his paper, to be able to analyze changes in voting
behavior, the cross-sectionality of panel data needs to be exploited, and the
votes need to be categorized clearly into winners and losers @stratmann-2002.
This also means, that one needs to be able to deduce from the votes which
candidates voted pro- one interest group, and anti- the other one.

Due to this specification, the data from the League of Conservation Votes (LCV)
Scorecard (https://scorecard.lcv.org) was used throughout this paper. The
website categorizes roll-call votes as either pro-environmental or
anti-environmental. However, using this data presented challenges, primarily
because the LCV Scorecard did not include representatives' IDs before 2021.
About 60% of the representatives in the latest roll-call vote were also present
in earlier votes and could be matched using their IDs. For the remaining 40%,
matching had to rely solely on first names, last names, party affiliations, and
state representations. This approach led to several merging difficulties, which
will be detailed more in @merging.

Considering these circumstances, utilizing one of the many other roll-call data
providing websites, such as Govtrack US, Congress.gov and C-Span would have been
more useful, since these match representatives with a unique identifier. This
was not possible, however, because these websites do not publish all roll-call
votes but only the most relevant, i.e. the roll-call votes which passed a bill.
For this analysis, however, only the environmentally related roll-call votes are
relevant and these are often not published on the aforementioned websites. Thus,
the LCV Scorecard Website was used to source roll-call data, despite their
incomplete use of IDs for representatives.

// Data Processing & Cleaning
Considering the circumstance that the 2021 votes had a different format than the
2013-2019 votes, the representative's names were often different, and thus could
not be joined easily to create an aggregate roll-call data frame.

#figure(```r
fuzzy_match <- function(x, y, max_dist = 5) {
    return(stringdist::stringdist(x, y) <= max_dist)
}
roll_call_full_<- fuzzy_full_join(
    methane_116,
    methane_117,
    by = c("name", "Party", "District"),
    match_fun = list(fuzzy_match, `==`, `==`)
)
```, caption: [Fuzzy join used to join Representative Data]) <fuzzyjoin>
To overcome this, the R package `fuzzyjoin` was used @fuzzjoin. Using the
functions `clean_strings` to remove special characters and `fuzzy_match` and
`fuzzy_full_join` to join, a maximum distance between two values can be
determined. In the `fuzzy_full_join` function, I defined that the names between
the two data frames can be matched if they are at most 5 characters distance
from one another, while the variables `Party` and `District` need to be
identical to match, see @fuzzyjoin.

== Contribution data <contrib-data>

=== Time Frame of Contributions <contribs-choice>

// decision 6mo vs. aggregate.
As discussed in @intro, Stratmann uses two different approaches to measuring the
effect of campaign contributions on voting behavior. In his paper, #cite(<stratmann-1995>, form: "prose")
explores whether contributions given at approximately the same time as the vote
are more important in determining voting behavior than contributions of previous
congressional elections. He concludes that current election contributions, in
the topic of dairy legislation, play a larger role in determining voting
behavior than that of the previous election. In the #cite(<stratmann-2002>, form: "prose") paper,
Stratmann uses the aggregate campaign contributions allocated to representatives
in the election post and prior to the congressional session, i.e. contributions
from the 1989-1990 and 1995-96 vote to explain the 1991 and 1998 vote. He uses
the 1991-92 and 1997-98 contributions to gauge whether there are punishments or
rewards for the representative's voting behaviors. In both cases he finds a
positive correlation between contributions from special interest groups and a
vote in their favor.

By focussing on the contributions from previous elections and contributions
which happen almost simultaneously to the vote, these papers by Stratmann
neglect to analyze whether the mid- to short-term contributions play a role in
determining voting behavior. After all, firms are profit-maximizing, and
contribute strategically and in close temporal proximity to roll-calls to
maximize their influence on voting behavior @Selling2023. By contributing closer
to the vote and, they assure that representatives do not back out of their
promises to support the special interest groups' causes @stratmann-1998. By
including a more restricted time frame for contribution, such as six months
prior to the vote, these trends can be captured @griers, without extending the
time frame to such an extent that the contributions of the closely paced votes
(September 13, 2017 and July 18, 2018) in the 115th congressional session
overlap. Therefore, although both strategies are analysed in this paper, see
Appendix A3, for the main analysis only the the main analysis, only
contributions within six months of the vote are are included in the main
analysis.

Yet, since both variations are were analyzed, both will be explained: Firstly, I
calculated the contribution variables using data from the previous election
cycle, following the methodology outlined in several academic studies, including
@stratmann-2002 @Selling2023 @KauKeenanRubin @chappell @stratmann-1991. This
approach evaluates whether aggregate contributions from past election cycles may
influence representatives' voting behavior in environmental matters. Secondly, I
focused exclusively on campaign contributions from individuals and interest
groups that supported either pro-environmental or anti-environmental positions,
received by representatives within the six months leading up to the relevant
vote. Unlike the first approach, this method does not consider contributions
from specific election periods, such as those during which the legislator was
elected or those concurrent with the legislative session, but rather
concentrates on contributions directly preceding the vote.

#figure(table(
  columns: 4,
  stroke: none,
  [*Vote Date*],
  [*Cutoff Date*],
  [*Cycle*],
  [*Nr. of Contributions*],
  table.hline(),
  [June 25th 2021],
  [Dec 25th 2020],
  [2022],
  [4965],
  [],
  [],
  [2020],
  [34],
  table.hline(),
  [June 20th 2019],
  [Dec 19th 2018],
  [2020],
  [5191],
  [],
  [],
  [2018],
  [30],
  table.hline(),
  [Jul 18th, 2018],
  [Jan 17th 2018],
  [2018],
  [7749],
  table.hline(),
  [Sep 13th 2017],
  [Feb 12th 2017],
  [2018],
  [7148],
  table.hline(),
  [Jul 13th 2016],
  [Jan 12th 2016],
  [2018],
  [1],
  [],
  [],
  [2016],
  [7142],
  table.hline(),
  [Nov 20th 2013],
  [Mar 19th 2013],
  [2014],
  [7085],
  table.hline(),
), caption: [Consolidated contribution data with vote and cutoff dates]) <congresses-contribs>
//   *plot* contributions from before (e.g. relevant contributions over time, with
//   cutoff date, 2012 (misses vote 6mo. prior completely, 2014 right in the middle,
//   2016 in between))
// plot for cutoff date and contributions. with cutoff data vertically and the amount of contributions (in plots_2.qmd)

In analyzing the timing of contributions relative to congressional votes, a
clear pattern emerges as detailed in @congresses-contribs. Since most votes
occur late in the session, contributions from the six months preceding each vote
mostly originate from the current Congress. Occasionally, they also include
contributions from the previous Congress.

=== Contribution Data Sources and Processing

Campaign contribution data is readily available through a multitude of open
source platforms #footnote(
  "such as Sunlightlabs: https://sunlightlabs.github.io/datacommons/bulk_data.html and the Database on Ideology, Money in Politics, and Elections (DIME), but which were not suitable for this analysis",
). Among those is the Center for Responsive Politics which provides contribution
data in Bulk Data form (https://www.opensecrets.org/open-data/bulk-data), which
includes PAC contributions to US representative candidates and individual
contributions to candidates.

To process the contribution data of the entire election prior to the vote, the
oil&gas-, methane-, natural gas-, coal-, environmental- and alternative energy
contributions were imported for all incumbents, and then cleaned and categorized
into pro-environmental and anti-environmental contributions and joined with a
list of all representatives per session.

Cleaning the bulk data used for the timely contributions proved to be more
complex, due to the size of the files. Since I have a comparatively small 8 GB
RAM, and that the PAC and individual contribution text files had over 2 million
rows and were over 15 GB large at times made the importing let alone processing
tedious, even when including the state-of-the-art tidyverse @tidyverse package's
tools and functions, such as piping and lazyloading. To resolve this, I wrote
several shell scripts which check whether a cleaned file exists, and if not,
cleans the file anew. This saved time and RAM space in two ways: On the one
hand, cleaned files would not be re-cleaned uselessly, and on the other hand,
shell scripting ensures a better utilization of RAM space when working with
large files, such as these of individual and PAC campaign contributions.

After the pre-cleaning process through the scripts, only Individual and PAC
contributions were kept which were allocated to incumbents. Using the
OpenSecrets RealCodes
(https://www.opensecrets.org/downloads/crp/CRP_Categories.txt), only the
non-negative contributions contributions from pro-environmental and
anti-environmental (fossil fuel) donors were kept.

== Merging <merging>

To merge the three types of aforementioned data together, two types of merges
(or joins, synonymous in R) were done. About 60% of the data was able to be
merged together based on a set of Unique Identifiers, which was Bioguide ID for
the roll-call data. Post primary merge, the rest of the data, which was not able
to be merged was filtered out and merged based on the `fedmatch` @fedmatch
package's functions `fuzzy_match` and `fuzzy_join` functions as shown in
@fuzzyjoin. Finally, the two merged data frames were concatenated.

Finally, only about 30 representatives were not able to be merged and thus
removed. The reason for this is because these anomalies either joined or left
Congress halfway through the session or switched from one congressional chamber
to the next, and thus these members appeared in some data frame, but not in the
others, i.e. incumbents are marked as representatives but were not included in
the vote and did not receive contribution, since they were not part of a regular
election.

For the final data frame used for analysis, the 731 representatives (over
113th-117th congresses) were further decreased, to only include representatives
relevant to the analysis. This includes representatives, who voted on more than
one relevant bill. Without this specification, one couldn't analyze differences
in voting behavior. Moreover, only Republicans and Democrats were included,
since Independent and Libertarians are too few to be able to compare.

// relevant?
// Lastly, to make the dataframe suitable for analysis, I used the pivot_longer function to pivot the dataframe to include only the Vote, Contributions (pro-environmental and anti-environmental seperately) and the

#pagebreak()

= Econometric Models <models>

// give information about why remove some variables -> LPM control -> FEs
In order to test the changes in voting behavior due to campaign contributions,
the model setup must allow for a dichotomous dependent variable, i.e.
pro-environmental vote (1) or anti-environmental vote (0) and for the
non-negativity of contributions @stratmann-1991 @stratmann-2002 @chappell.

Two types of models are the linear probability model (LPM) and the logit, both
of which are widely used in the economic literature, but both of which have some
drawbacks. The LPM is an ordinary least squared multiple linear regression with
binary dependent variables. The benefits of using a LPM to analyze the effect of
campaign contributions on voting behavior is the fact that the linear regression
can be used to estimate the effects on the observed dependent variable, so
coefficients are comparable over models and groups. One downside of the LPM,
however, is the possibility for the predicted probability to be out of range, by
being either higher than 1 or lower than 0 @mood.

In order to counter this, one can use a nonlinear regression model, such as the
logit regression or logit model, which also measures dichotomous dependent
variables but the predicted probability will always stay within range of 0 to 1.
Comparing models with various independent variables or significantly
interpreting the results is challenging when using logistic regression since the
underlying cumulative distribution function of this model is a standard logistic
distribution. Thus, changes in log-odds are not as intuitive to interpret as
direct probabilities in a linear regression. Moreover, #cite(<mood>, form: "prose") explains
that logistic effect measures can capture unobserved heterogeneity even in cases
where there is no correlation between the omitted variables and the independent
variables @Selling2023.

Although the linear regression sometimes predicts probabilities outside of the
range, LPMs usually fit about as well as logit models, even in cases of
nonlinearities @long1997regression @Selling2023, and their results are easier to
predict than those of logit models @mood, which is why the LPM will be used as a
main model for this paper. To encompass the major downsides of the LPM, however,
the logit Model will be included as a robustness check.

// Why not 2SLS -> @stratmann-2002 p.1
// say that OBV in logit & LPM? @mood?

== LPM and Logit <models-precisely>

As discussed above, the LPM and logit models will be used for the analysis #footnote(
  [Throughout my analysis, I replicated Stratmann's (2002) probit model, which
    includes only those representatives who changed their votes over time, and takes
    the changes in contribution level as explanatory variables, without control
    variables or fixed effects (FE)s. Given my small sample, however, the
    contribution change coefficients could not be estimated, which is why this model
    is not included in neither the model specification nor the results.],
). The model shown in @lpm is the multivariate linear regression, whereas the
model shown in @logit is the conditional logit regression. For both models, let: $X#sub[1]$ be
the pro-environmental contributions, and $X#sub[2]$ be the anti-environmental
contribution, $bold(x)$ be the vector of control variables, $delta#sub[t]$ the
time fixed effect (FEs) and $gamma#sub[i]$
the individual fixed effects, all of which are shown in @model-spec.

$ "Vote"#sub[i,t] = alpha + beta#sub[1]X#sub[1,t] + beta#sub[2]X#sub[2,t] + gamma#sub[i] + delta#sub[t] + bold(x)'zeta#sub[i,t] + epsilon#sub[i,t] $ <lpm>

$ P("Vote"#sub[i,t] = 1|bold(x), beta#sub[1,2], gamma#sub[i]) = F(beta#sub[1,2]'bold(x)#sub[it], gamma#sub[i]) $ <logit>

In their most basic specification, both @lpm and @logit include the entire
sample of representatives who voted more than once on the set of the six roll
call votes, without discriminating based on voting behavior. When moving from
most generous to the strictest models, the main difference between the two
models is that in the LPM model, both legislator and year fixed effects are
used, whereas in the conditional logit model, specified by #cite(<stratmann-2002>, form: "prose"),
only legislator fixed effects are used.

Using these models as a base, I explored different ways of measuring the
relationship between voting behavior and contributions. One variation is to
isolate each vote and include all time-relevant contributions from previous
votes and those from the current vote, see @lpm-per-vote in the appendix for
these results. This tests the assumptions made in @contribs-choice, and takes
into account not only the short term contributions when an environmental vote is
coming up, but also the previous contributions on the same topic, to measure
whether voting is also affected by contributions for previous relevant votes.

In one model specification, only representatives who maintained consistent
environmental voting behavior across the six roll-call votes were included. This
approach allows for an analysis of whether the presence or amount of
contributions influences legislators, even when no changes in voting behavior
occur. Essentially, this assesses whether interest groups contribute regardless
of voting changes. Conversely, all models were applied solely to representatives
who altered their voting throughout the six roll-call votes. This method
facilitates a causal identification strategy, enabling conclusions to be drawn
only when there are variations in voting behavior @stratmann-2002, see @party
for these results.

== Model specification <model-spec>

Using the models outlined in @models-precisely, this paper analyzes the
relationship of votes and campaign contributions ranging from using the most
generous model specifications, such as using control variables, to the
strictest, using individual (legislator) fixed effects.

To control for confounding influence between a treatment and an outcome and
approach a consistent causal interpretation @control, the following control
variables are used: the legislator's party and whether their party had House
Majority during that term @McAlexander2020 @stratmann-2002. These control
variables are used since party is a good determinant for a legislator's
ideological leaning, and whether their party has the majority in the House
determines the power which the group has over the House of Representatives.

To control for the junior/senior legislators stipulated in @hypothesis, I
decided to add both the `birth year` and `seniority`, which is number of terms
in House the representative served, to control for the difference in age and
experience which might distort the voting behavior @stratmann-2002 @Selling2023.
By controlling for differences in geographical residence of the representatives,
using `district` #footnote(
  [As to be seen in @desc-stats, about 300 rows lack the variable district, since
    this information was only available selectively in the above mentioned data
    sources. After careful consideration, I decided to include the variable
    regardless, since it is significant and improves the model, albeit observations
    with NA-values for district not being included for three of the models shown in
    @main_models.],
), `state` and `geographical` #footnote(
  [the variable `geographical` has the 50 US states grouped into four categories:
  Northwest (NW), South (SO), West (WE), Midwest (MW), according to the United
  States Census Bureau at
  https://www2.census.gov/geo/pdfs/reference/GARM/Ch6GARM.pdf],
) and the district level I remove possible differences in voting behavior
attributed to the location of representatives.

Based on roll-call records, the Dynamic Weighted (DW)-Nominates are a widely
used indicator of a representative's ideology in a multidimensional policy
space, which serve as a strong predictor of the voting decisions of
representatives @rosenthalpoole @matter. By including the absolute value of the
first and second dimension of the `DW-Nominate` (https://voteview.com) as
control variables, I control for differences in ideology that might explain
voting behavior. It is easier to prove causality when a variable for legislator
ideology is included, as this eliminates the variation in roll-call voting that
might be attributed to the lawmaker's ideological inclination @Selling2023.
Furthermore, according to #cite(<roscoe>, form: "prose"), adding an ideology
variable to the equation is the only practical approach to account for the
influence of friendly donating.

I also control for the gender of the legislator, as the gender pay gap tends to
apply not only to income but also to campaign contributions. Furthermore, to
account for voting consistency, I introduce another dummy variable indicating
whether the legislator changed their vote on on or more of the six votes. This
helps to determine whether vote-changing behavior affects the volume of campaign
contributions they receive. Finally, I define dummy variables which indicate
whether representatives received pro- or anti-environmental contributions in the
time-period before the votes. This allows me to measure the extensive margin of
contribution, i.e. how the fact that a representative received a contribution
relates to their voting behavior. By including these dummy variables and the
amount of the donation, I also measure the intensive margin. In this way, I can
analyze whether the actual amount of the contribution changes the voting
behavior of a representative who has received a contribution in the first place.

Regarding roll-call votes, the six roll-call votes included do not amend the
same bills, but I assume that they are all the same bill as they all relate to
the same subject and institutions, see @roll-call, and therefore I will not
control for differences in bills @griers.

By including the aforementioned control variables, I am able to fix certain
factors that I can measure and assume have confounding effects on the predicted
probability. Were I to leave the regressions as is, then there could still be
potential omitted variable bias in my analysis. I am bound to miss either
variables that I did not know affect my results, or variables that I cannot
measure. Unobservables, or the inability to include in a model every variable
that influences a result, are the root cause of the issues. The variance in the
dependent variable resulting from unobserved or omitted variables is known as
unobserved heterogeneity @mood.

Applying two-way fixed effects to the LPM #footnote(
  [As stated in @models-precisely, the conditional logit model only includes
    one-way fixed effects, due to the nature of the multinomial model. Thus, I have
    decided to include only geographical, state, party and legislator fixed effects
    for each logit regression.],
) @Imai-Kim-2019, one can account for unobservable elements that remain constant
across time and another unit (such as party or state), and thus remove unit and
time invariant confounding @griers. In this paper, four types of two way FEs are
used: In the more generous version, I fix for the variables geographical region
and year, since this measures only the change in contributions within a year and
same geographical location. By fixing for the geographical region of a state and
not the actual state, I am controlling for some differences within the US, such
as culture and migration, but not making the model so strict as to account for
all differences in states. By controlling for years, on the other hand,
time-variant differences such as environmental perception or disasters are not
taken out of context and compared with years with little environmental
happenings.

In a stricter version, I fix for year and state. This provides more accurate
results on the geographical level. As mentioned above in @contributions-success,
differences in states and their election such as the size of government or the
competitiveness of the election influence the amount of contributions which
incumbents receive. By controlling for states, not only the differences in
elections and contributions are fixed, but differences in economic conditions,
population sizes and possible differences in state ties to the fossil fuel
industries and severely environmentally affected states are not compared to one
another, since these differences are important enough to influence both
contributions and voting behavior.

The third type of fixed effects employed are the party and year FEs. This way, I
can adjust for the the influence that political party orientation might have on
the results, along with the same temporal factors as before. This may capture
differences in policies, ideologies, or priorities that vary systematically
between parties @Selling2023.

Lastly, in the strictest model, I fix for both legislators and years. The reason
behind fixing for something as small as a single representative, is because it
gives the ability to control for omitted variables which are constant over time
for each legislator such as the representative's background, which is complex
and high dimensional and bound to affect the individuals voting behavior
@Huntington @stratmann-2002. Not only am I thus able to address the omitted
variable bias which I was not able to address through my previous two-way fixed
effects, such as the representative's eloquence and negotiation skills,
proximity to the fossil fuel industry and environmental industry, but I am able
to remove previous FEs#footnote(
  [And almost all control variables used in the previous models, which do not
  change over time and over the same legislator. Only the `seniority` variable
  changes within representatives over time, which is why it is included in this
  model specification.],
), such as the state or geographical fixed effects, since these usually do not
change for a representative over time. Therefore, to determine the impact of
donations on voting changes, I only use the change in donations within a year
and specific member, which allows me to predict the impact of donations most
accurately @griers.

#pagebreak()
= Results <results>

== Effectiveness of Contributions <hypo-2>
One of the hypotheses stated in @hypothesis is that the effect of pro and
anti-environmental campaign contributions, if statistically significant, would
be minimal. As visible from the regression outputs in the appendix, this was not
the case. Using control variables to state and year fixed effects in the LPM
with all representatives, the campaign contributions from environmental sources
and non-environmental sources were highly significant.

// LPM all representatives with control variables & log transformed
The most generous LPM shown in as the first model in @main_models, which
includes only control variables shows that when increasing the pro-environmental
contribution to representatives by 1000 USD, the probability of the
representative voting pro-environmentally increases by 0.7214 percent on
average, ceteris paribus. In return, when increasing anti-environmental
contribution by 1000 USD, the probability of a representative voting
pro-environmentally decreases by an average of 0.06 percent, holding all else
constant. Both of these coefficients are highly significant. Given that the
contributions from both anti and pro-environment are highly skewed, I applied a
logistical transformation on the contribution variables, and found that the
effect of the anti-environmental contribution variable increases to -0.015
ceteris paribus and the significance of the pro-environmental contribution
variable is est. to be an average of 0.027 ceteris paribus, on the same
significance level. See @lpm-log-trafo for these results.

// contribution dummy
When including the dummy variables of pro- or anti- environmental contributions
leading up to each vote, the results show no significance in the most general
linear regression with control variables. Only when including state and year
fixed effects does the anti-environmental dummy show statistical significance on
a 0.05 level. For the state and year fixed effects model, the interpretation is
as follows: A representative receiving anti-environmental contributions
decreases their probability of voting pro-environmentally by 2.6 percent on
average, and for each additional 1000 USD, the probability of a
pro-environmental vote decreases further by 0.05 percent, ceteris paribus.

// fixed effects
As shown in @main_models, when fixing the LPM model by US state and year, the
contribution coefficients remain highly significant with a 1000 USD increase in
pro-environmental contribution increasing the probability of a pro-environmental
vote by 0.7 percent and a 1000 USD increase in anti-environmental contribution
decreasing the probability of a pro-environmental vote by 0.05 percent. When
applying individual (legislator) and year fixed effects, a 1000 USD increase in
pro-environmental contribution increase the probability of a pro-environmental
vote by 0.4 percent on average, ceteris paribus. The anti-environmental
contribution coefficient, however is not significant at all.

#figure(
  image("figures/lpm_main.png", width: 100%),
  caption: [Main Linear Probability Models summarized],
) <main_models>

The results in @main_models show, that there is a highly significant relation
between a pro-vote and pro-contributions, and vice versa. As discussed in
@vote_spec, the average pro-environmental contributions for the representatives
within six months prior to the vote was approximately 1,000 USD whereas the
anti-environmental contributions averaged out to 19,800 USD. Putting this into
the context of the results shown in @main_models, where a 1,000 USD
pro-environmental contributions increases environmental voting by 0.7 percent
and anti-environmental contributions decreasing it by 0.06 percent, the impact
of anti-environmental contributions is likely more effective due to their higher
average amount—approximately 19,800 USD compared to 1,000 USD for
pro-environmental contributions. Therefore, anti-environmental contributions
appear to have a stronger effect on environmental voting, reflecting the
disparity in average contribution amounts.

// Interpretation of these validity of the results
When looking at @main_models, the adjusted $R^2$ values in the first four models
are very high and might raise suspicion of multicolinearity within the predictor
variables #footnote(
  [Although the Individual Fixed Effects model shows an adjusted R-squared of
  -0.311, estimated with the `plm` function,the linear probability model estimated
  with the `lm` function with the exact same specifications,coefficients, standard
  errors and p-values has a much higher adjusted R-squared of 0.95. The reason as
  to why I still included this model and not the other, is that the fixed effects
  coefficients for the lm would show up in the model summary, and thus the model
  would be too long to be included in the stargazer output.],
). Yet, the Variance Inflation Factor (VIF) values of all variables are below 5,
with most of them being between 1 and 1.25, and a correlation plot shows similar
results, that no variables are suspiciously highly correlated with one another.
This means that the high adjusted $R^2$ values are not due to multicolinearity,
but rather due to the high explanatory power of the model, which can be
attributed to the fact that most of the control variables are highly significant
and have a high explanatory power on their own, such as the representative's
party and DW-Nominate dimensions which are already very good predictors of the
representatives voting decisions on their own. Hence, the first hypothesis from
this paper can be rejected, since the effect of pro and anti-environmental
contributions on voting behavior is not minimal, considering each effect is
measured on a per 1000 USD scale and is also rather highly significant.

#figure(
  image("figures/logit_main.png", width: 80%),
  caption: [Main Conditional Logit Models summarized],
) <main_logit>

// add logit/probit results
The results from the conditional logit used as a robustness check, see
@main_logit, show similar trends as the linear probability models above. When
regressing Vote against the contribution and control variables, see column 1 in
@main_logit, we see that pro-environmental contributions affect a
pro-environmental vote positively, and anti-environmental contributions
negatively. Given that these coefficients have the same signs and significance
level, I conclude that these results are robust. When looking at the conditional
logit from columns 2,3 and 4 in @main_logit, these results are also highly
significant and show similar results to their corresponding LPM with fixed
effects, thus these results are also robust.

Finally, as discussed in @model-spec, the individual votes were regressed with
the corresponding pro- and anti-contribution of the roll-call votes leading up
to the vote in question. See @lpm-per-vote in the appendix. Interestingly
enough, when looking at the early votes, i.e. vote in the 113th and 114th
congress, then the campaign contributions six months prior, no matter if anti-
or pro-environmental, are insignificant, whereas in the votes in the 116th and
117th congress, the votes from the earlier sessions are more significant on
average. This could indicate that especially when it comes to repeated votes on
the same topics, not the actual short-term contribution within six months of the
vote influences voting behavior, but the contributions from the earlier relevant
votes is more effective in determining voting behavior. This could indicate,
that representatives do form long term relationships with their contributors,
but not necessarily within a congressional election#footnote(
  [as discussed in @contribs-choice, where the effect contribution of an entire
    congressional prior to the vote had the same effect as the contributions six
    months prior to vote.],
), but over multiple, in this case, up to 5 congressional periods.

== Contribution and Vote Changes

In the second hypothesis, changes from pro to anti-environmental votes are
predicted to be more positively correlated with anti-environmental
contributions, and pro-environmental contributions less effective. Considering,
however, that only 23 representatives changed their votes over the course of the
six roll-call votes, with only 31 vote changes in total, no conclusions can be
drawn from this LPM model, and in return, no conclusions can be drawn about the
propensity of contributions, whether pro or anti-environmental in nature, to
change the voting behavior of representatives.

// should i include this?
// When regressing the pro-environmental contributions with all other variables
// listed above, including the Vote dummy variable, which signifies a
// pro-environemntal vote at 1, then we can interpret that a pro-environmental
// contribution warrants. Interestingly enough, for a change from the democrat to
// the republican party, the pro-environmental contributions for a representative
// increase by an average of 1.6 USD, ceteris paribus. Interestingly enough, if
// democrats have the majority in the house of representatives, the average pro
// environmental contributions to representatives decrease by 45 USD. These are
// interesting trends

//  add regression results here from vote_change_to_pro ~ contributions (all were insiginificant, but still, should mention that both the actual vote and the vote change was regressed)

// hypothesis proven? if yes, then the results... corroborate the hypotheses

== Seniority on Vote Changes

The third hypothesis stated in @hypothesis is that junior representatives are
more likely to change their voting behavior due to campaign contributions than
senior representatives, given that they are not experienced enough to have
stable opinions on the matter, as shown by #cite(<stratmann-2002>, form: "prose").
To address this, I incorporated the previously mentioned seniority and birth
year control variables into the regression models, as outlined in @model-spec.
Since seniority details the number of terms the representative has partaken in
and the birth year represents the age of the legislator, I also checked that the
correlation between the two variables would not be high enough to cause
multicolinearity, which it was not, with a correlation of -0.57, and a VIF of
1.27 and 1.28 respectively.

// general LPM and logit/probit
When looking at the LPM model with all representatives, the seniority variable
was not significant, and the birth year variable was significant at a 0.01
level, with a one year increase in birth year increasing the probability of a
pro-environmental vote by 0.007 percent on average, holding all else constant.
The same trends were found when fixing the model by state and year, with the
birth year variable being significant at a 0.001 level and having an effect of
0.013 percent increase in pro-environmental voting for a one year increase in
birth year, and the seniority variable being significant only at a 0.05 level
with a one term increase in seniority increasing the environmental voting
probability by 0.018 percent. When fixing the model by legislator and year
(using plm instead of lm), the birth year variable was not significant at all,
and the seniority variable was significant at a 0.01 level, with a one term
increase in seniority decreasing the probability of a pro-environmental vote by
0.0001 percent on average, holding all else constant. Similar results and
significance for the birth year variable emerge when fixing the legislator,
whereas the seniority variable is not significant at all.

// Interpretation
Since only birth year is mostly significant and seniority is not, one can
conclude that younger representatives are more likely to vote pro
environmentally in these votes holding all else constant, which compared to the
results from the first hypothesis, the effect of a one year younger
representative in voting pro-environmentally is larger than that of 1000 USD in
pro-environmental contributions. Whereas seniority affects the voting only when
fixing for state and year, which means that the more experienced the
representative is, the more prone they are to vote pro-environmentally in these
votes.

Still, although these results show the propensity of younger representatives to
vote pro-environmentally in these votes, this does not mean that young people
are more prone to vote changes. To determine this, the LPM model of only the
representatives who changed their votes is taken into consideration, yet here
neither birth year nor seniority are significant, and thus no conclusions can be
drawn in respect to the third hypothesis.

== Partisan Contributions

In the fourth hypothesis, the effect of contributions on voting behavior is
stated to be more significant for Republican representatives than for Democratic
representatives. To check whether this might be the case I fixed not only year
but also party in the two way fixed effects LPM and logit models. The results in
@party in the appendix show that the effect of anti- and pro- contribution does
not change from the baseline LPM model without fixed effects, and the
significance of these coefficients does not decrease either. When applying the
conditional logit regression, on the other hand, the effects of contributions
are higher, and show similar trends as the LPM model, on the same level of
significance, ceteris paribus.

When it comes to the explanation of voting behavior, it is clear that Party has
a huge impact on the voting decisions. In general, the `PartyR` coefficient in
@main_models, which is -0.901. Meaning, that a representative's (hypothetical)
change from the Democratic to the Republican Party would decrease their
environmental votes by 90%, ceteris paribus. Additionally, the average fossil
fuel and environmental contributions which republicans receive is approximately
30 times higher than that of a Democrat. Republicans in this analysis receive an
average of 30,000 USD in anti-environmental contributions in the cumulative time
periods of the six roll-call votes, whereas Democrats receive only about 9,500
USD. Moreover, Republicans receive an average of 1,250 USD from
pro-environmental sources, whereas Democrats receive only an average of approx.
750 USD from pro-environmental sources#footnote(
  "These results were calculated through the analysis, see the link to my github repository for these values.",
). One conclusion which can be drawn when analyzing the effect of contributions
on votes, and holding party constant, is that since Republicans receive more
contributions, the effect of contribution on their voting behavior is higher.

// as discussed in @hypo-2, the
// differences in pro-environmental and anti-environmental contributions is large
// and thus the perceived effectivity of contributions in securing votes is
// similarly distorted. More importantly, the environmental contributions prove to
// be targeted towards Democratic representatives,

// possibly due to the fact that the pro-environmental funds are limited in the
// first place, and thus the contributions should be more effective, rather than
// the anti-environmental contributions, which are more widely distributed, less
// differentiated and greater on average. This is also to be seen in the results of
// the LPM, which shows that if only one of the two contribution coefficients is
// significant, then usually only the pro-environmental contributions are
// significant, see @main_models column 5, for example.

//  add recency -> vote 4,5,6 with all prior contributions, to see whether more recent contributions have higher effect than less recent ones.. (6mo prior vs. aggregate?)

//  final result: relation between contributions and votes can be confirmed, but not the whether contributions are the actual reason for vote changes.. so no causal conclusion to be drawn from these results.

#pagebreak()
= Discussion and Conclusion <disc>

The main goals for the thesis was to explore the relationship of
pro-environmental and anti-environmental, specifically fossil-fuel, campaign
contributions have on the voting behavior of US Representatives on the topic of
methane pollution safeguard related roll-call votes. Moreover, this paper
contributes to the extensive academic literature on this topic, by analyzing the
effect of environmentally related campaign contributions on the representative's
voting on methane pollution safeguards, a topic on which there are few studies.
By using not only Stratmann's logit models and aggregate election but also a
linear probability model with time-related contribution, I am further extending
this area of research. This paper finds that campaign contributions shape how
the representatives votes on this particular matter. Elected officials are more
likely to vote in agreement with the individual and PAC's contributions, if
these interest groups contribute within six months of the vote.

Albeit including variables which track a representative's political ideology
through roll-call votes (namely the DW-Nominate dimensions), and including
legislator fixed effects to avoid omitted variable bias and thus including
important metrics to measure causal relationships @stratmann-2002 @Selling2023,
no causal relationship between environmentally related campaign contributions
and changes in environmental voting behavior could be significantly estimated.

Several reasons preclude establishing a causal relationship in this study,
despite its methodology being heavily influenced by #cite(<stratmann-2002>, form: "prose"),
who identified causality in his work. One significant limitation is the small
sample size of representatives who altered their votes over the six roll-call
votes, see @mind-changers. Additionally, the inherently polarizing and decisive
nature of environmental issues among representatives means that changes in
voting behavior are inherently rare. Moreover, the causality of the models used
by #cite(<stratmann-2002>, form: "prose") warrants scrutiny, especially given
his questionable assumptions in selecting the Glass-Steagall Act for
analysis—such as the presumption that financial legislation does not engage
public interest, thereby affording representatives greater freedom in their
voting decisions.

// circle back to the intro: should we give donors such as the koch brothers even more chance to influence politics, no: change legislation to lessen the effect which money has in politics, especially for crucial issues such as the environment.
The implications of these results are that there is a clear relationship between
anti(pro) environmental contributions and anti (pro) environmental voting
behavior of representatives and that dependent on the positions which
representatives take, they have the possibility to earn their campaigns
incredible amounts of donations, from the fossil fuel industry, for example. In
a system where legislation should be made with the population in mind, the
possibility of incumbents receiving campaign contributions has a bad aftertaste
for the health of the American democracy @Weschle_2022b. Moreover, given the
steep rise in expenditures for congressional elections over the past 20 years,
the effect which moneyed interest will have on votes will likely increase.

While this paper provides valuable insights, it has several limitations, which
point to opportunities for future work.First, more robustness checks should be
included. By including more relevant models and relevant variables, such as each
state's gdp per capita related to the fossil fuel industry, results could be
concluded with more certainty. Touched upon briefly in this paper, by regressing
the pro vote of representatives with the campaign contributions not only six
months prior, but also the six months prior to vote contributions of all similar
votes before might show that representatives take contributions of previous
similar votes as a baseline to determine their current votes.

As shown in @results, methane related voting behavior can be explained very well
given the representative's party and DW-Nominate, meaning that the party line
and ideology is a strong influencer for a legislators vote, and that most
representatives tend to keep within those party lines. Thus, it would be
interesting to analyze the campaign contributions not to individuals but parties
themselves, and how this affects the party's votes on certain issues
@Selling2023

Another interesting topic for research would be to analyze changes in voting
behavior given by the nature of roll-call votes. Since these happen
alphabetically, representatives whose names are further along the alphabet might
be able to deviate from party lines given a vote is already won/lost.

Using different sources of campaign contributions would also be an interesting
approach. These include not individual and PAC contributions, but Super PAC
contributions, which can be unlimited in size and cannot be directly allocated
to a political candidate @griers. Finally, another interesting approach would be
to use more of the countless open source resources available to import campaign
and representative data by using Application Platform Interfaces (API), which
significantly ease the data collection process. Resources such as the congress
API (https://github.com/LibraryOfCongress/api.congress.gov/), or the tidycensus
R package (https://walker-data.com/tidycensus/).