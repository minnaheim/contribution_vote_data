#import "thesis_template.typ": *
#import "common/cover.typ": *
#import "common/titlepage.typ": *
#import "thesis_typ/acknowledgement.typ": *
#import "thesis_typ/abstract_en.typ": *
#import "common/metadata.typ": *
#import "@preview/glossarium:0.4.0": make-glossary, print-glossary, gls, glspl
#show: make-glossary

// show code snippets with background color
#show raw.where(block: false): box.with(
  fill: rgb("#EFEFEF"),
  inset: (x: 3pt, y: 0pt),
  outset: (y: 3pt),
  radius: 2pt,
)

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
polarised @polarisation. The public's perceptions mirror these trends: 84
percent of US residents think that money influences politics excessively and
express a desire to see changes made to the campaign finance system to lessen
the influence of wealthy donors @bonica[p.~1].

But how do campaign donors influence politics? The prime example is the brothers
David and Charles Koch, are one of the most influential donors who have a
multifaceted approach when it comes to their involvement in US politics. On the
one hand, they shape the mindset of the US population through organised groups,
think-tanks and networks of other mega-donors with similar political and social
ideologies, such as the Koch Network @Hertel-Fernandez_Skocpol_Sclar_2018.

On the other hand, the fossil fuel conglomerate Koch Industries, headed by
Charles Koch, fund the electoral campaigns of Republican presidential and
congressional candidates @skocpol2016koch and have spent more than 123 million
USD on elections. Especially over the past ten years, Koch Industries have
increased their campaign contributions by at least 10% per election cycle,
amounting to 28 millon USD in the 2022 election cycle, with approximately 90-97%
of these congressional contributions going to Republican candidates#footnote(
  "found at: https://www.opensecrets.org/orgs/koch-industries/summary?id=d000000186}",
).

Given the participation which wealthy fossil fuel donors like Koch brothers have
in US elections, the question is why donors such as these contribute immense
sums to congressional elections? Surely, profit-maximizing firms such as the
Koch Industries do not merely contribute millions of USD to congressional
campaigns without considering their return on investment @stratmann-2017. Thus,
the question is what campaign contributors are to receive in return for their
donations. Given Charles Koch's position at Koch Industry and fossil fuel
related conglomerate Koch Industries and David Koch's history in climate change
denial @doreian2022koch[pp. 2-8], and their donor and advocacy roles in the
United States makes one wonder what the consequences of fossil fuel related
campaign contributions to the US congress could mean for US environmental
policies.

These questions will be analysed in this paper. The influence of fossil fuel and
environmentally related contributions on the voting behavior of US House members
on methane pollution bills will be analysed. The analysis is based on the paper
of #cite(<stratmann-2002>, form: "prose"), who exploits the time series nature
of campaign contributions and roll-call votes to approach a causal
identification strategy to measure the effect of financial contributions on
roll-call votes. Regarding campaign contribution, however, #cite(<stratmann-2002>, form: "prose") uses
the aggregate contributions for each election cycle, whereas in his 1995 paper,
only the contributions leading up to the vote are included, regardless of
election cylce @stratmann-1995. Although both contribution types are explored,
this paper will focus on the latter contribution strategy.// if i use 1995 stratmann's "data", then shouldn't I also include his models ?

@moneyinpolitics will give a short literature review on the economics and
political science perspectives on money in politics, with a focus on the causal
relationship between campaign contributions and the representatives' voting
decisions. @research-design presents the research design, details the reasoning
behind analysing environmental legislation and the methane pollution roll-call
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
money in politics, namely self-enrichment, campaign contribution and golden
parachute jobs. The first type happens when politicians are in office, and
receive resources from special interest groups. The second is when politicians
receive campaign contributions during elections to fund their campaigns.
According to Weschle, the last type of money in politics is the golden parachute
jobs, which are financially lucrative positions offered to ex-politicians.

== Campaign Contributions
// why focus on campaign contributions - largest increase?
Although each type of political funding has significant and distinct
repercussions for democracy and the voting behavior of politicians
@Weschle_2022c, campaign contributions in U.S. politics are of particular
importance for the analysis presented in this paper. One reason for this, is
that there has been a stark increase in contributions to political campaigns
over time @stratmann-2017[p.1] @stratmann-2005[p.141] and understanding the
reasons behind contributors donating this money to fund campaigns could help
policy makers deal with this issue. The average contributions to members of
congress have increased as well within the last 40 years.

#figure(
  image("figures/avg_contrib_house.jpg", width: 100%),
  caption: [
    Average Contributions to House Members#footnote(
      " Since the 2024 election cylce is due in November 2024, the contributions
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            there are not comparable to 2022 yet",
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
legislation. In 2010, the U.S. Supreme Court ruled on the landmark case Citizens
United v. Federal Election Commission (FEC). This decision addressed whether
Congress could limit independent expenditures by corporations. Traditionally,
campaign contributions are structured as individual and Political Action
Committee (PAC) contributions, as shown in #cite(<opensecretskoch>, form: "prose") data.
Individual contributions are those over 200 USD made by natural persons or their
family members who are employed in the industry @griers. PACs represent
corporate or labor interests @Weschle_2022a. The Citizens United v. FEC ruling
affirmed that both natural and legal persons—individuals and
corporations—possess equivalent rights to spend on U.S. congressional campaigns
@foreman[p.194]. This decision ultimately allowed for unlimited independent
expenditures related to elections#footnote(
  "United States Citizens United v. Federal Election Commission, January 21, 2010",
).

// why do candidates need contributions?  -  improve election values
Even if campaign contributions have risen over time, the reason as to why
politicians receive them should be clarified. US Citizens who would like to
become members of the United States Congress, such as the House of
Representatives, which is the chamber of congress which this analysis focuses
on, need to become elected through a bi-yearly congressional election. To
improve chances of election, these candidates get financial contributions, which
they spend on advertisements, rallies and flyers to attract more votes
@Weschle_2022c[p.~24].

// Reason for Contribution
Yet, why would corporations give money to candidates via PACs or individual
contributions, which these will not return? Stratmann makes the assumption that
since corporations are inherently for-profit, they do not donate to
organisations without wanting to profit from doing so. Economists and political
scientists hypothesise, that companies' campaign spending is strategic
@stratmann-2017 @Denzau-Munger-1986 @Weschle_2022c[p.~25]. What exactly these
companies receive in return for their contribution, however, is unclear
@stratmann-2017. Stratmann defines three motives for contributions: the first is
access to the candidate, the second is to influence election and the third is to
contribute to the candidate most likely to win @stratmann-2005[p.~146]
@stratmann-2017[p.~13]. #cite(<Weschle_2022c>, form: "prose") determines that
what campaign donors receive in return to contributing to candidates is either
influence, meaning they change the opinion of the candidate by contributing to
their campaign, or the support of a candidate that has your interest at heart,
with specifically small scale contributors following both methods.

// Überleitung, reason for contribution to correlation between 2 vars
Besides dicussing the reasons for campaign contributions, the question is also
whether there is a positive correlation between candidates receiving
contributions and receiving increased vote shares. If this were the case, then
campaign spending would be more straightforward, since this would mean that
successful election can be assumed.

== Contributions and Candidates' election sucesses <contributions-success>

One would assume that receiving more campaign contributions would relate to a
higher chance of getting elected, yet there is no clear correlation between
campaign contributions and the vote shares which candidates receive
@stratmann-2005 @Weschle_2022c[p.~24]. In fact, there are a host of factors that
influence the amount of campaign contributions politicians receive, which are
often endogenous to a candidate's vote shares @Weschle_2022c[p.~24].

// factors to include to explain correlation between contribs & votes
Geographical factors play a role in contribution, for example. A contribution
amount is worth more in some congressional districts than in others, since costs
like rallying and advertising are priced differently @stratmann-2009. Similarly,
contribution limits imposed on certain US states cap the contribution amount
candidates may receive @Weschle_2022c[p.~25], and candidates from states with
larger governments receive more contributions on average @stratmann-2005[p.148]
@bronars-lott-1997. Factors which depend on the nature of the election also
influence the level of contributions, since expected competitiveness of the
election outcome also changes the average contribution amounts, i.e. incumbents#footnote("A current office holder seeking re-election.") who
expect their position to be threatened will be incentivised to gather more
donations#footnote("Donations and contributions are used synonymously in this paper.") @Weschle_2022c[p.~8],
@stratmann-2017[p.~25]. The partisan lean of a state also determines which
candidates are up for race @stratmann-2017[p.~9]. PAC contributions in
particular depend on the incumbency status of the candidate, since incumbents
receive more contribution on average @Selling2023 @fouirnaies2014financial. When
academic papers like that of #cite(<Weschle_2022a>, form: "prose") examine
factors such as those mentioned above, they find that increased campaign
spending is associated with higher vote shares for representatives.

== Campaign Contributions and Representatives' Voting Decisions.

When it comes to the relationship between campaign contributions from special
interests and representative's voting decisions in that interest's favor, many
researchers see a correlation. Yet, the deduction of what that means for the
relationship between campaign contributions and votes is difficult to make. Do
incumbents cater to wishes of special interest groups, because of their
contribution or do they get contribution because their views coincide with the
special interests groups @stratmann-2005[p.~143] @KauKeenanRubin[p.~275]?
Similarly, it is difficult to distinguish between two possible explanations for
donations to politicians: either donors merely sympathise with and support
politicians who share their views, or donations actually influence the
politicians' decisions (i.e., donations actually buy votes) @bronars-lott-1997
@chappell[p.83].//  Moreover, even if interest groups fund lawmakers who support them regardless, a significant relationship between money and votes does not prove that money influences politics. Situations like these leave room for simultaneous equation bias @stratmann-2002 @burris2001two @chappell.

To overcome these challenges, causality must be established. Yet determining
causality when there is a positive association between donations and roll-call
votes is one of the most challenging issues in the literature on campaign
finance. The idea that money may be exchanged for votes is contested by two
competing causal theories. Firstly, donors often provide to organisations and
individuals that are inclined to support their policy ideas @burris2001two.
Secondly, it is possible that donations function more as rewards or punishments
for previous roll-call votes than as catalysts for more voting @stratmann-1991.
In the first case, the ideology of the lawmaker acts as a confusing factor,
making the link between money and votes fictitious. The second situation
involves the concept of reverse causality @Selling2023 @stratmann-2017.

Given the importance of determining causal relationships for money in politics,
several researchers have tried to identify such a relationship between voting
and contributions and have not found effects, such as #cite(<bronars-lott-1997>, form: "prose"),
who analysed how the voting behavior of politicians changed when they did not
stand for re-election. Ideally, politicians should represent their ideology,
even without facing threat of re-election, yet if their vote is 'bought' then
their contributions and voting behaviour changes, since the cost of shirking
decreases @bronars-lott-1997[p.319]. Ansolabehere et al. analysed 40 empirical
papers and concluded in a seminal paper that there is limited evidence
indicating interest group contributions have an impact on roll-call votes
@Ansolabehere @griers.

Others, however, have found that contributions do change voting behaviour:
Stratmann analysed the timing of contributions, and instead of analysing how the
contributions of the previous cycle relates to the voting behaviour of
politicians, Stratmann took the contributions from current election cylces,
since short term contributions are more relevant for voting behavior, according
to him @stratmann-1995. Betrand finds indirect evidence of lobbying companies
providing special interest groups access to politicians when these groups
contribute (as opposed to giving only issue specific information to congress
members)@Bertrand @matter. #cite(<baldwinmagee>, form: "prose") also find
linkages of roll-call votes on specific trade agreement related bills and the
contributions from businesses and labor groups. #cite(<McAlexander2020>, form: "prose"),
in their paper on the electoral gap in evironmental voting determines that since
the public's inclination for environmental protection is greater than the oil
and gas sector's, candidates who get large campaign contributions from
businesses tend to vote more in favour of the environment when elections come
around.// Also Mian et al. find that campaign contributions alter roll-call votes @mian.

Given that some results find causal relationships between contributions and
others find no effect, most researchers can conclude that there is no academic
consensus on this matter @stratmann-2017[p.13]. Part of the reason there is no
academic consensus on causal relationships is because of the nature of the
studies, which are cross-sectional in design, where correlation between
contributions and votes is given due to the support of similar interests, so we
have simultaneous equation bias @stratmann-2002[p.1] @burris2001two @chappell.

The studies which found causal links between campaign contributions and voting
behaviour have a common denominator: research in particular fields or
legislation. #cite(<baldwinmagee>, form: "prose"), for example analysed trade
agreement related bills, #cite(<stratmann-2002>, form: "prose") analysed
financial bills @stratmann-1995 @kang2015 @stratmann-1995 and the timing of
financial contributions, and found significant effects. Hence, one needs to
analyse distinct roll-call votes and a rather restricted policy setting
@kang2015 @stratmann-1991[p.607] @chappell.

Moreover, Stratmann critisises that most studies done in the field lack a
convincing identification strategy to determine the causal relationship between
legislative voting behavior and campaign contributions. One significant problem
is from the possibility of reverse causation, "meaning that while contributions
have an impact on roll call votes, it is also possible that legislators who cast
roll call votes which are favorable to interest groups receive contributions
from these groups" @stratmann-2017[p.14].Common criticism in the field is
attributed not only to studies whose analysis does not focus on a specific
legistlation or account for reverse causality, but also those who do not control
for individual counties and geographical areas @stratmann-2005[p.142] @griers.
Moreover, only by looking at repeated votes and thus changes in voting
behaviour, a link can be determined between contribution and voting
@stratmann-2005[pp.143-144] @stratmann-2002. Considering a closer time-frame for
contribution has also proven to increase plausibility @stratmann-1995.

Given the extensive research done on money in politics, and the (causal)
relationship between campaign contributions and roll-call voting behaviour, this
paper will aim to take the above stated specifications to analyse a causal
relationship between campaign contributions and roll-call votes in the
environmental context.

#pagebreak()

= Research Design <research-design>
This section will deal with the reasoning behind the chosen roll-call votes and
campaign contributions, and the hypothesis which are set up for the analysis.

== Stratmann's Specifications <vote_spec>
// Conditions met: Vote repition, winners & losers defined,
#cite(<stratmann-2002>, form: "prose") follows a similar methodology to
determine the causal relationship between campaign contributions and the
representative's vote shares, defines the following roll-call votes
preconditions for his research: the votes are not only repeated but also exhibit
changes in voting behaviour @KauKeenanRubin[p.276] @stratmann-2002. Moreover,
the winners and losers of the votes need to be defined, the precise subject
voted on should not be repeated again. This way patterns in contribution and
voting behaviour can be deduced more easily. These conditions are met in this
analysis. There are six roll-call votes which are related to methane pollution
safeguards (i.e. the methane emissions of fossil fuel companies), and these are
not repeated to this date, since the vote relates to the acceptance or rejection
of an increase in environmental regulation, the winners and losers of the votes
are clearly defined.

// Conditions not met: clearly articulated positions, contribution industry size
There are conditions, however, which Stratmann sets up which are not met in this
paper. On the one hand, he stipulates that the research should treat a topic
where representatives do not typically take clear stance in their election
campaigns @stratmann-2002[p.4]. This is not met here, since environmental
positions are usually quite polarising, and most legislators have clear
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
considerably smaller @OpenSecretsInterestGroups.

//  plot about number of representatives who receive contribution
// add grid here
#grid(
  columns: 2,
  gutter: 5,
  [#figure(
      image("figures/pro_plot_contribs.svg", width: 100%),
      caption: [Histogram of pro-environmental \ contributions among representatives, Source:
        Own],
    ) <env-contribs>],
  [#figure(
      image("figures/anti_plot_contribs.svg", width: 100%),
      caption: [Histogram of anti-environmental \ contributions among representatives, Source:
        Own],
    ) <anti-env-contribs>],
)

Examining the figures above reveals distinct differences in the distribution of
pro and anti-environmental campaign contributions. Pro-environmental
contributions are generally smaller, while anti-environmental contributions tend
to be larger and more spread out. This variance is also illustrated by the
y-intercept line in the plots, which represents the average contribution to
representatives from both groups.

Thus, it is more difficult to compare the contribution sizes of these interest
groups. Lastly, Stratmann determines that there need to be a substantial amount
of changes in voting behaviours of the representatives, yet in this case, only
23 representatives out of 529 change their vote over time, see @mind-changers.// insert mind changers plot here (confirm 23/529?)

== Methane Pollution Votes <roll-call-subject>

// what are methane pollution safeguards, what are methane emissions and why are they important, why related to oil & gas industry.
// methane pollution safeguards is...

Although as shown in the section above, the roll-call bills do not fit all of
the preconditions stipulated by #cite(<stratmann-2002>, form: "prose"),
analysing environmental policy and the propensity for representatives to deviate
based on contributions is still a relevant topic and has significant
reprecussions for democracy if a causal relationship does exist.

While environmental issues are polarizing for both the public and
representatives, suggesting that representatives might have fewer incentives to
change their positions #cite(<McAlexander2020>, form: "prose") found that most
environmental policies shift the cost burden to industries. Consequently, the
general public tends to hold a more favorable view of environmental issues
compared to the average interest group. This discrepancy suggests that if
campaign contributions were to influence voting behavior, representatives might
be more inclined to adopt positions that align more closely with the interests
of their contributors, often resulting in weaker environmental stances
@McAlexander2020.

Moreover, the reason to choose these bills for the analysis can be attributed to
the fact that, as stated above, the Energy and Natural Resources interest groups
are some of the biggest contributors to congressional elections
@OpenSecretsInterestGroups and thus also have the biggest potential to be
analysed, since these contributions are not only large in volume but also in
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
    [to preserve the Department of the Interior's ability to reduce methane emissions
      from oil and gas drilling operations on public lands#footnote("https://scorecard.lcv.org/roll-call-vote/2013-601-methane-emissions").],
    [H. R. 5538],
    [434],
    [114],
    [2016],
    [include a rider to stop the Environmental Protection Agency (EPA) from enforcing
      its recently determined methane pollution regulations, which are the first-ever
      caps on methane emissions from new and altered sources in the oil and gas
      industry#footnote(
        "https://scorecard.lcv.org/roll-call-vote/2016-434-methane-pollution-safeguards",
      )],
    [H. R. 3354],
    [488],
    [115],
    [2017],
    [would hinder the EPA's efforts to control methane emissions from newly created
      and altered sources inside the oil and gas industry#footnote(
        "https://scorecard.lcv.org/roll-call-vote/2017-488-methane-pollution-safeguards",
      )],
    [H. R. 6147],
    [346],
    [115],
    [2018],
    [would hinder the EPA efforts to decrease methane emissions in the oil and gas
      industry from both new and modified sources from the oil and gas industry #footnote(
        "https://scorecard.lcv.org/roll-call-vote/2018-346-methane-pollution-safeguards-0",
      )],
    [H. R. 3055],
    [385],
    [116],
    [2019],
    [would hinder the EPA from implementing standards to reduce methane emissions
      from both new and modified sources from the oil and gas industry#footnote(
        "https://scorecard.lcv.org/roll-call-vote/2019-385-methane-pollution-safeguards",
      )],
    [S.J. Res. 14],
    [185],
    [117],
    [2021],
    [would have rolled back on the EPA 2016 methane standards for both new and
      modified sources from the oil and gas industry#footnote(
        "https://scorecard.lcv.org/roll-call-vote/2021-185-repealing-assault-methane-pollution-safeguards",
      )],
  ),
  caption: [The Six Roll-Call Votes on Methane Pollution Safeguards analysed in this paper],
) <roll-call-votes>

The six roll-call votes which will be analysed in this paper can be seen in
@roll-call-votes. The reasoning behind choosing these six bills is that they all
amend the resources allocated to the EPA and the Department of Interior. Since
the legislation enacted by Congress governs the executive wing including the EPA
@McAlexander2020[p.43], these roll-call votes are fundamental in gauging the
environmental opinions of representatives. Moreover, the bills are quite similar
in nature, since they not only all concern the same departments, but also
precisely the methane pollutions and -emissions, generated through the oil and
gas industries, and are thus industry specific.

Although in the #cite(<stratmann-2002>, form: "prose") paper the two roll-call
votes all pertained to the amendment of the same bill. This paper uses multiple,
closely related, roll-call votes, and thus ensures that there is more variation
in voting behaviour than there would be, if only two roll-call votes were
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

Out of 568 representatives who voted on more than one of the six roll-call
votes, only 23 representatives changed their voting behaviour, and of these 23
representatives, there were 31 vote changes in total, as seen in @mind-changers.
Moreover, the frequency of these successively scheduled votes—held in 2013,
2016, 2017, 2018, 2019, and 2021—increases the likelihood that representatives
participate in multiple voting sessions, unlike in the #cite(<stratmann-2002>, form: "prose") paper,
where the two roll-call votes were in 1991 and 1998, which are 3 congressional
sessions apart. Thus, the chance of a representative partaking in multiple votes
decreased substantially.

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
representatives experience a greater marginal effect from contributions, whereas
their senior counterparts maintain more steadfast positions. Similarly, the
thrid hypothesis states that legislators in their early congressional terms are
more susceptible to altering their environmental voting behaviors.

Lastly, since partisan affiliation and ideology is rather polarised in the
United States @polarisation, and that usually, Republicans receive higher
campaign contributions on average, see @avg-contributions, the fourth hypothesis
states that contributions on voting behaviour will be more effective for
Republican representatives than for Democratic representatives.

// Lastly, since @stratmann-1995 stipulated that contributions which are given
// shortly before the vote have higher impacts on congressional voting behavior
// than contributions from the past election cylce. Taking this into consideration,
// the fourth hypothesis is that votes in a time frame of six months prior to the
// vote will have more significant effects on voting behaviour than contributions
// from the congressional session before, since the amount of contributions change
// compared to the timing of votes @stratmann-1998.

#pagebreak()
= Data <data>

The empirical framework stipulated in @research-design requires the comparison
of voting behaviour of the US representatives and the campaign contributions
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
the github repository congress-legislators#footnote("https://github.com/unitedstates/congress-legislators"),
which is created and managed by a shared commons, and includes detailed
information for all historical and current US congressional members, including
various IDs they have across US legislative data providing platforms. Since the
above data is not ordered according to congressional sessions which each
representative partook in, data from the Biographical Directory of the United
States Congress#footnote("https://bioguide.congress.gov")
was used match the data on current and historical legilsators with a list of the
representatives participating in each seperate congress.

== Roll-call data <roll-call>

As Stratmann stipulated in his paper, to be able to analyse changes in voting
behaviour, the cross-sectionality of panel data needs to be exploited, and the
votes need to be categorised clearly into winners and losers @stratmann-2002.
This also means, that one needs to be able to deduce from the votes which
candidates voted pro- one special interest group, and anti- the other one.

Due to this specification, the data from the League of Conservation Votes(LCV)#footnote("https://scorecard.lcv.org")
Scorecard was used throughout this paper. The website categorizes roll-call
votes as either pro-environmental or anti-environmental. However, using this
data presented challenges, primarily because the LCV Scorecard did not include
representatives' IDs before 2021. About 60% of the representatives in the latest
roll-call vote were also present in earlier votes and could be matched using
their IDs. For the remaining 40%, matching had to rely solely on first names,
last names, party affiliations, and state representations. This approach led to
several merging errors, which will be detailed more in @merging.

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
not be joined easily to create an aggregate roll-call dataframe.

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
```, caption: [Excerpt of Code used]) <fuzzyjoin>
To overcome this, the R package `fuzzyjoin` @fuzzyjoin was used. Using the
functions clean_strings to remove special characters and `fuzzy_match` and
`fuzzy_full_join` to join, a maximum distance between two values can be
determined. In the `fuzzy_full_join` function, I defined that the names between
the two dataframes can be matched if they are at most 5 characters distance from
one another, while the variables Party and District need to be identical to
match.

== Contribution data <contrib-data>

=== Time Frame of Contributions <contribs-choice>

// decision 6mo vs. aggregate.
As discussed in @intro, Stratmann uses two different approaches to measuring the
effect of campaign contributions on voting behaviour. In his @stratmann-1995
paper, Stratmann explores whether contributions closer to the vote are more
important in determining voting behaviour than contributions of previous
congressional elections. He concludes that current election contributions, in
his case of dairy legislation, play a larger role in determining voting
behaviour than that of the previous election. In the #cite(<stratmann-2002>, form: "prose") paper,
Stratmann uses the aggregate campaign contributions allocated to representatives
in the election post and prior to the congressional session, i.e. contributions
from the 1989-1990 and 1995-96 vote to explain the 1991 and 1998 vote and the
contributions from the election happening parallel to the vote i.e. Stratmann
uses the 1991-92 and 1997-98 contributions to gauge whether there are
punishments or rewards for the representative's voting behaviors. In both cases
he finds a positive correlation between contributions from special interest
groups and a vote in their favor.

To account for the variability in campaign contribution selection, I employed
two distinct approaches. Firstly, I calculated the contribution variables using
data from the previous election cycle, following the methodology outlined in
several academic studies, including @stratmann-2002 @Selling2023 @KauKeenanRubin
@chappell @stratmann-1991. This approach evaluates whether aggregate
contributions from past election cycles may influence representatives' voting
behavior in environmental matters. Secondly, I focused exclusively on campaign
contributions from individuals and interest groups that supported either
pro-environmental or anti-environmental positions, received by representatives
within the six months leading up to the relevant vote. Unlike the first
approach, this method does not consider contributions from specific election
periods, such as those during which the legislator was elected or those
concurrent with the legislative session, but rather concentrates on
contributions directly preceding the vote.

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

A discussion of these two types of campaign contributions-aggregate
contributions from the previous election and the use of contributions from the
current election-shows that these papers @stratmann-1995 @stratmann-2002 both
give the total contributions of an industry to candidates in an election and
that only the time of relevance is different. Yet what these two papers, and
many with similar methodology, neglect to analyse is whether more timely
contributions are more effective in affecting the voting behaviour of
candidates. After all, most contributors who are profit-maximizing contribute
strategically and in close temporal proximity to roll-calls to maximize their
influence on voting behaviour @Selling2023 and thus contribute closer to the
vote, in order to assure that representatives do not back out of their promises
to support the special interst groups' causes @stratmann-1998. By including a
more restricted time frame for contribution, such as six months prior to the
vote, these trends can be captured @griers, without extending the time frame to
such an extent that the contributions of the closely paced votes (September 13,
2017 and July 18, 2018) in the 115th congressional session overlap. Which is
why, albeit analysing both strategies in this paper, for the main analysis, only
the contributions within six months prior to the votes will be included. #footnote(
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
individual contributions to candidates.

The oil&gas-, methane-, natural gas-, coal-, environmental- and alternative
energy contributions were imported for all incumbents, and then cleaned and
categorized into pro-environmental and anti-environmental contributions and
joined with a list of all representatives per session#footnote(
  [Cleaning the bulk data for the timely contributions was more complex due to the
    size of the files and the comparatively small 8 GB RAM I had available. Given
    that the PAC and individual contribution text files had over 2 million rows and
    were over 15 GB large at times made the importing let alone processing tedious,
    even when including the state-of-the-art tidyverse @tidyverse package's tools
    and functions, such as piping and lazyloading. To resolve this, I wrote several
    shell scripts which check whether a cleaned file exists, and if not, cleans the
    file anew. This saved time and RAM space in two ways: On the one hand, cleaned
    files would not be re-cleaned uselessly, and on the other hand, shell scripting
    ensures a better utilization of RAM space when working with large files, such as
    these of individual and PAC campaign contributions.],
).

After the pre-cleaning process through the scripts, only Individual and PAC
contributions were kept which were allocated to incumbents. Using the
OpenSecrets RealCodes #footnote(
  "which can be found at https://www.opensecrets.org/downloads/crp/CRP_Categories.txt",
), only the non-negative contributions contributions from pro-environmental and
anti-environmental (fossil fuel) donors were kept.

== Merging <merging>

To merge the three types of aforementioned data together, two types of merges
(or joins, synonymous in R) were done. About 60% of the data was able to be
merged together based on a set of Unique Identifiers, which was Bioguide ID for
the roll-call data. Post primary merge, the rest of the data, which was not able
to be merged was filtered out and merged based on the `fedmatch` @fedmatch
package's functions `fuzzy_match` and `fuzzy_join` functions as shown in
@fuzzyjoin in @roll-call. Finally, the two merged dataframes were concatinated.

Finally, only about 30 representatives were not able to be merged and thus
removed. The reason for this is because these anomalies either joined or left
congress halfway through the session or switched from one congressional chamber
to the next, and thus these members appeared in some dataframe, but not in the
others, i.e. incumbents are marked as representatives but were not included in
the vote and did not receive contribution, since they were not part of a regular
election.

For the final dataframe used for analysis, the 731 representatives (over
113th-117th congresses) were further decreased, to only include representatives
relevant to the analysis. This includes representatives, who voted on more than
one relevant bill. Without this specification, one couldn't analyse differences
in voting behaviour. Moreover, only Republicans and Democrats were included,
since Independent and Libertarians are too few to be able to compare.

// relevant?
// Lastly, to make the dataframe suitable for analysis, I used the pivot_longer function to pivot the dataframe to include only the Vote, Contributions (pro-environmental and anti-environmental seperately) and the

#pagebreak()

= Econometric Models <models>

// give information about why remove some variables -> LPM control -> FEs
In order to test the changes in voting behaviour due to campaign contributions,
the model setup must allow for a dichotomous dependent variable, i.e.
pro-environmental vote (1) or anti-enviornmental vote (0) and for the
non-negativity of contributions @stratmann-1991 @stratmann-2002 @chappell.

Two types of models are the linear probability model (LPM) and the logit, both
of which are widely used in the economic literature, but both of which have some
drawbacks. The LPM is an ordinary least squared multiple linear regression with
binary dependent variables. The benefits of using a LPM to analyse the effect of
campaign contributions on voting behaviour is the fact that the linear
regression can be used to estimate the effects on the observed dependent
variable, so coefficients are comparable over models and groups. One downside of
the LPM, however, is the possibility for the predicted probability to be out of
range, by being either higher than 1 or lower than 0 @mood.

In order to counter this, one can use a nonlinear regression model, such as the
logit regession or logit model, which also measures dichotomous dependent
variables but the predicted probability will always stay within range of #range(2)\. Comparing
models with various independent variables or significantly interpreting the
results is challenging when using logistic regression since the underlying
cumulative distribution function of this model is a standard logistic
districution. Thus, changes in log-odds are not as intuitive to interpret as
direct probabilities in a linear regression. Moreover, #cite(<mood>, form: "prose") explains
that logistic effect measures can capture unobserved heterogeneity even in cases
where there is no correlation between the omitted variables and the independent
variables @Selling2023.

Although the linear regression sometimes predicts probabilities outside of
range, LPMs usually fit about as well as logit models, even in cases of
nonlinearities @long1997regression @Selling2023, and their results are easier to
predict than those of logit models @mood, which is why the LPM will be used as a
main model for this paper. To encompass the major downsides of the LPM, however,
the Logit Model will be included as a robustness check.

// Why not 2SLS -> @stratmann-2002 p.1
// say that OBV in logit & LPM? @mood?

== LPM and Logit <models-precisely>

The specific versions of the LPM and logit model discussed above are shown in
@lpm and @logit.

Both the LPM and the conditional logit model will be used for the analysis. As
shown in @models above, both are required to make sound analyses of the effect
of contribution on voting behaviour. Thus, the LPM model is used as a main
model, and the Logit#footnote(
  "Throughout my analysis, I replicated Stratmann's (2002) probit model, which includes only those representatives who changed their votes over time, and takes the changes in contribution level as explanatory variables, without control variables or fixed effects (FE)s. Given my small sample, however, the contribution change coefficients could not be estimated, which is why this model is not included in either the model specification nor the results.",
) serves as a robustness check.

The model shown in @lpm is the Linear Probability model.

$ "Vote"#sub[i,t] = alpha + beta#sub[1]X#sub[1,t] + beta#sub[2]X#sub[2,t] + gamma#sub[i] + delta#sub[t] + bold(x)'zeta#sub[i,t] + epsilon#sub[i,t] $ <lpm>

The model shown in @logit is a conditional logit.

$ P("Vote"#sub[i,t] = 1|bold(X), beta#sub[1,2], gamma#sub[i]) = F(beta#sub[1,2]'bold(x)#sub[it], gamma#sub[i]) $ <logit>
Let: $X#sub[1]$ be the pro-environmental contributions, and $X#sub[2]$ be the
anti-environmental contribution, $bold(x)$ be the vector of control variables, $delta#sub[t]$ the
the time fixed effect (FEs) and $gamma#sub[i]$ are the individual fixed effects,
all of which are detailed in @model-spec.

In their most basic specification, both @lpm and @logit include the entire
sample of representatives who voted more than once on the set of the six roll
call votes, it is non-discriminatory based on voting behaviour. When moving from
most generous to the strictest models, the main difference between the two
models is that in the LPM model, both legislator and year fixed effects are
used, whereas in the conditional logit model, specified by #cite(<stratmann-2002>, form: "prose"),
only legislator fixed effects are used. As shown in @model-spec and @results,
this is only the strictest specification.

Using these models as a base, I explored different ways of measuring the
relationship between voting behaviour and contributions. One variation is to
isolate each vote and include all relevant posts from previous votes and those
from the current vote, see @lpm-per-vote in the appendix for these results. This
tests the assumptions made in @contribs-choice, and takes into account not only
the short term contributions when an environmental vote is coming up, but also
the previous contributions on similar topics, to measure whether voting depends
on contributions for previous relevant votes.

In one model specification, only representatives who maintained consistent
environmental voting behavior across the six roll-call votes were included. This
approach allows for an analysis of whether the presence or amount of
contributions influences legislators, even when no changes in voting behavior
occur—essentially, assessing whether interest groups contribute regardless of
voting changes. Conversely, all models were applied solely to representatives
who altered their voting throughout the six roll-call votes. This method
facilitates a causal identification strategy, enabling conclusions to be drawn
only when there are variations in voting behavior @stratmann-2002, see
@logit-main for these results.

== Model specification <model-spec>

Using the models shown in @models-precisely, this paper will analyse the
relationship of votes and campaign contributions ranging from using the most
generous model specifications, such as using control variables, to the strictes,
using individual fixed effects.

To control for confounding influence factors between a treatment and an outcome
and approach a consistent causal interpretation @control, the following control
variables are used: the legislator's party and whether their party had House
Majority during that term @McAlexander2020 @stratmann-2002. These control
variables are used since party is a good determinant for a legislator's
ideological leaning, and whether their party has the majority in the house
determines the power which the group has over the house of representatives.

To control for the junior/senior legislators stipulated in @hypothesis, I
decided to add both the `birthyear` and `seniority`, which is number of terms in
house the representative served, to control for the difference in age and
experience which might distort the voting behaviour @stratmann-2002
@Selling2023. By controlling for differences in geographical residence of the
representatives, using `district` #footnote(
  [As to be seen in @desc-stats, about 300 rows lack the variable district, since
    this information was only available selectively in the abovementioned data
    sources. After careful consideration, I decided to include the variable
    regardless, since it is significant and improves the model, albeit observations
    with NA-values for district not being included for three of the models shown in
    @main_models.],
), `state` and `geographical` #footnote(
  "the variable Geographical has the 50 US states grouped into four categories: Northwest (NW), South (SO), West (WE), Midwest (MW), according to the United States Census Bureau under https://www2.census.gov/geo/pdfs/reference/GARM/Ch6GARM.pdf",
) and the district level I remove possible differences in voting behaviour
attributed to the location of representatives.

Based on roll-call records, the Dynamic Weighted (DW)-Nominates are a widely
used indicator of a representative's policy opinion in a multidimensional policy
space, which serve as a strong predictor of the voting decisions of
representatives @rosenthalpoole @matter. By including the absolute value of the
first and second dimension of the DW-Nominate#footnote("accessible at https://voteview.com") as
control variables, I control for differences in ideology that might explain
voting behaviour. It is easier to prove causality when a variable for legislator
ideology is included, as this eliminates the variation in roll-call voting that
might be attributed to the lawmaker's ideological inclination @Selling2023.
Furthermore, according to #cite(<roscoe>, form: "prose"), adding an ideology
variable to the equation is the only practical approach to account for the
influence of friendly donating.

I also control for the `gender` of the legislator, as the gender pay gap tends
to apply not only to income but also to campaign contributions. Furthermore, to
account for voting consistency, I introduce another dummy variable indicating
whether the legislator changed their vote on six specific votes. This helps to
determine whether vote-changing behaviour affects the volume of campaign
contributions they receive. Finally, I define dummy variables which indicate
whether representatives received pro- or anti-environmental contributions in the
time-period before the votes. This allows me to measure the extensive margin of
contribution, i.e. how the fact that a representative received a contribution
relates to their voting behaviour. By including these dummy variables and the
amount of the donation, I also measure the intensive margin. In this way, I can
analyse whether the actual amount of the contribution changes the voting
behaviour of a representative who has received a contribution (dummy = 1).

Regarding roll-call votes, the six roll-call votes included do not amend the
same bills, but I assume that they are all the same bill as they all relate to
the same subject and institutions, see @roll-call, and therefore I will not
control for differences in bills @griers.

By including the aforementioned control variables, I am able to fix certain
factors that I can measure and assume have confounding effects on the predicted
probability. Were I to leave the regressions as is, then there could still be
potential omitted variable bias in my analysis. Yet, I am bound to miss either
variables that I did not know affect my results, or variables that I cannot
measure. Unobservables, or the inability to include in a model every variable
that influences a result, are the root cause of the issues. The variance in the
dependent variable resulting from unobserved or omitted variables is known as
unobserved heterogeneity @mood.

Using two-way fixed effects @Imai-Kim-2019, one can account for unobservable
elements that remain constant across time and another unit (such as party or
state), and thus remove unit and time invariant confounding @griers. In this
paper, four types of two way FEs are used: In the more generous version, I fix
for the variables geographical region and year, since this measures only the
change in contributions within a year and same geographical location. By fixing
for the geographical region of a state and not the actual state, I am
controlling for some differences within the US, such as culture and migration,
but not making the model so strict as to account for all differences in states.
By controlling for years, on the other hand, time-variant differences such as
environmental perception or enviornmental disasters are not taken out of context
and compared with years with little environmental happenings.

In a stricter version, I fix for year and state. This provides more accurate
results on the geographical level. As mentioned above in @contributions-success,
differences in states and their election such as the size of government or the
competitiveness of the election influence the amount of contributions which
incumbents receive. By controlling for states, not only the differences in
elections and contributions are fixed, but differences in economic conditions,
population sizes and possible differences in state ties to the fossil fuel
industries and severely environmentally affected states are not compared to one
another, since these differences are important enough to influence both
contributions and voting behaviour.

The third type of fixed effects employed are the party and year FEs. This way, I
can adjust for the the influence that political party orientation might have on
the results, along with the same temporal factors as before. This may capture
differences in policies, ideologies, or priorities that vary systematically
between parties @Selling2023.

Lastly, in the strictest model, I fix for both legislators and years. The reason
behind fixing for something as small as a single representative, is because it
gives the ability to control for omitted variables which are constant over time
for each legislator such as the representative's background, which is complex
and high dimensional and bound to affect the individuals voting behaviour
@Huntington @stratmann-2002. Not only am I thus able to address the omitted
variable bias which I was not able to address through my previous two-way fixed
effects, such as the representative's eloquence and negotiation skills,
proximity to the fossil fuel industry and/or environmental industry, etc. but I
am able to remove previous FEs, such as the state or geographical fixed effects,
since these usually do not change for a representative over time. Therefore, to
determine the impact of donations on voting changes, I only use the change in
donations within a year and specific member, which allows me to predict the
impact of donations most accurately @griers.

#pagebreak()
= Results <results>

== Effectiveness of Contributions
One of the hypothesis stated in @hypothesis is that the effect of pro and
anti-environmentalcampaign contributions,if statistically significant, would be
minimal. As visible from the regression outputs in the appendix, this was not
the case. From using control variables to state and year fixed effects in the
LPM with all representatives, the campaign contributions from environmental
sources and non environmental sources were highly significant.

// LPM all representatives with control variables & log transformed
For the most generous LPM shown in @lpm including control variables showed that
when increasing the pro-environmental contribution to representatives by 1000
USD, the probability of the representative voting pro-environmentally increases
by 0.007214 percent on average, ceteris paribus. In return, when increasing
anti-environmental contribution by 1000 USD, the probability of a representative
voting pro-environmentally decreases by an average of 0.0006 percent, holding
all else constant. Both of these coefficients are significant on a 0 level.
Given that the contributions from both anti and pro-environment are highly
skewed, I applied a logistical transformation on the contribution variables, and
found that although the adjusted $R^2$ increases from 0.91 to 0.92 and the
effect of the anti-environmental contribution variable increases to -0.0121
ceteris paribus and with the same significance level, the sigifnicance of the
pro-environmental contribution variaable is est. to be an average of 0.011,
ceteris paribus, but the significance level of the estimator decreases.

// contribution dummy
When including the dummy variables of pro- or anti- environmental contributions
leading up the each vote, the results show no significance in the most general
linear regression with control variables. Only when including party and state
and year fixed effects does the anti-environmental dummy show statistical
significance on a 0.05 level. For the state and year fixed effects model, the
interpretation is as follows: A representative receiving anti-environmental
contributions decreases their probability of voting pro-environmentally by 2.6
percent, and for each additional 1000 USD, the proabability of a
pro-environmental vote decreases further by 0.05 percent, ceteris paribus.

// fixed effects
When fixing the LPM model by US state and year, the adjusted $R^2$ stays at 0.91
and the contribution coefficients remain highly significant with a 1000 USD
increase in pro-environmental contribution increasing the probability of a
pro-environmental vote by 0.00698 percent and a 1000 USD increase in
anti-environmental contribution decreasing the probability of a
pro-environmental vote by 0.00048 percent. Only when applying legislator and
year fixed effects does the significance of the pro-environmental contributions
decrease to a 0.01 level, with a 1000 USD increase in pro-environmental
contribution increasing the probability of a pro-environmental vote by 0.00361
percent on average, ceteris paribus. The anti-environmental contribution
coefficient, however is not significant at all, yet the predictors are very good
in explaining variations in the dependent variable, with an adjusted $R^2$ of
0.953.

#figure(
  image("figures/lpm_main.png", width: 100%),
  caption: [Main Linear Probability Models summarised #footnote(
    [Although the Individual Fixed Effects model shows an adjusted R-squared of
    -0.311, estimated with the `plm` function,the linear probability model estimated
    with the `lm` function with the exact same specifications,coefficients, standard
    errors and p-values has a much higher adjusted R-squared of 0.95. The reason as
    to why I still included this model and not the other, is that the fixed effects
    coefficients for the lm would show up in the model summary, and thus the model
    would be too long to be included in the stargazer output.],
  )],
) <main_models>

As shown in @vote_spec, the average pro-environmental contributions for the
representatives within six months prior to the enviornmental vote was
approximately 1,000 USD whereas the anti-environmental contributions averaged
out to 19,800 USD. Putting this into the context of the results shown in
@main_models, where a 1000 USD pro-environmental contributions increases
environmental voting by 0.7 percent and anti-environmental contributions
decreasing it by 0.06 percent, the impact of anti-environmental contributions is
likely more effective due to their higher average amount—approximately 19,800
USD compared to 1,000 USD for pro-environmental contributions. Therefore,
anti-environmental contributions appear to have a stronger effect on
environmental voting, reflecting the disparity in average contribution amounts.

// Interpretation of these validity of the results
Although these adjusted $R^2$ values are very high and might raise suspicion of
multicoloinearity within the predictor variables, the Variance Inflation Factor
(VIF) values of all variables are below 5, with most of them being between 1 and
1.25, and a correlation plot shows similar results, that no variables are
suspiciously highly correlated with one another. This means that the high
adjusted $R^2$ values are not due to multicolinearity, but rather due to the
high explanatory power of the model, which can be attributed to the fact that
most of the control variables are highly significant and have a high explanatory
power on their own, such as the representative's party and DW-Nominate
dimensions which are already very good predictors of the representatives voting
decisions on their own. Hence, the first hypothesis from this paper can be
rejected, since the effect of pro and anti-environmental contributions on voting
behaviour is not minimal, considering each effect is measured on a per 1000 USD
scale and is also rather highly significant.

#figure(
  image("figures/logit_main.png", width: 80%),
  caption: [Main Conditional Logit Models summarised],
) <main_logit>

// add logit/probit results
The results from the conditional logit, see @logit-main, used as a robustness
check show similar trends as the linear probability models above. When
regressing Vote against the contribution and control variables, we see that the
coefficient for contributions are log-odds. In other words, for a 1000 USD
increase in the anti (pro) environmental, the expected change in log odds is
-2.135e-05 (9.944e-05), ceteris paribus. These results are a bit less
significant than these of the LPM, since anti-environmental contributions are
significant on a 0.05 and pro-environmental on a 0.01 level, when only including
control variables. When fixing for state and years, the estimate coefficients
for pro environemtnal contributions are 0.502 and -0.47 for the anti
enviornmental contributions, ceteris paribus, where both coefficients are
significant on a 0.1 level. When fixing legislator and year, however, neither
contribution variable is significant.

== Contribution and Vote Changes

In the second hypothesis, changes from pro to anti-environmental votes are
predicted to be more positively correlated with anti-environmental contribuions,
and pro-environmental contributions less effective. Considering, however, that
only 23 representatives changed their votes over the course of the six roll-call
votes, with only 31 vote changes in total, no conclusions can be drawn from this
LPM model, and in return, no conclusions can be drawn about the propensity of
contributions, whether pro or anti-environmental in nature, to change the voting
behaviour of representatives. Not only are the estimated models, see Appendix,
estimating insignificant coefficients, but the adjusted $R^2$ is very low with
0.23, especially given the value of this metric in the previous models.

The only conclusion which can be drawn in respect to this hypothesis, is the
fact that the effect of contributions was indeed not the same, when comparing
pro-environmental and anti-environmental sources. The differences in
pro-environmental and anti-environmental contributions is very large, see
@contrib-data, in the first place. Moreover, the environmental contributions
prove to be targeted torwards Democratic representatives, possibly due to the
fact that the pro-environmental funds are limited in the first place, and thus
the contributions should be more effective, rather than the anti-environmental
contributions, which are more widely distributed, less differentiated and
greater on average. This is also to be seen in the results of the LPM, which
shows that if, not both contribution coefficients are highly significant, then
usually only the pro-environmental contributions are significant, see the
results from the LPM with legislator and year fixed effects, for example.

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

// no multicolinearity
The third hypothesis stated in @hypothesis is that junior representatives are
more likely to change their voting behaviour due to campaign contributions than
senior representatives, given that they are not experienced enough to have
stable opinions on the matter, as shown by #cite(<stratmann-2002>, form: "prose").
To address this, I incorporated the previously mentioned seniority and birth
year control variables into the regression models, as outlined in @model-spec.
Since seniority details the number of terms the representative has partaken in
and the birthyear represents the age of the legislator, I also checked that the
correlation between the two variables would not be high enough to cause
multicolinearity, which it was not, with a correlation of -0.57, and a VIF of
1.27 and 1.28 respectively.

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
significance for the birthyear variable emerge when fixing the legislator,
whereas the seniority variable is not significant at all.

// Interpretation
Since only birthyear is mostly significant and seniority is not, one can
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
neither birthyear nor seniority are significant, and thus no conclusions can be
drawn in respect to the third hypothesis.

== Partisan Contributions

In the fourth hypothesis, the effect of contributions on voting behaviour is
stated to be more significant for Republican representatives than for Democratic
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

// Important: here most significant results: when fixing party and year for vote changing representatives  minus -> -0.0005141 plus -> 0.0069335  -> both highly significant -> add table?

//  add recency -> vote 4,5,6 with all prior contributions, to see whether more recent contributions have higher effect than less recent ones.. (6mo prior vs. aggregate?)

//  final result: relation between contributions and votes can be confirmed, but not the whether contributions are the actual reason for vote changes.. so no causal conclusion to be drawn from these results.

#pagebreak()
= Discussion and Conclusion <disc>

The main goals for the thesis was to explore the relationship of
pro-environmental and anti-environmental, specifically fossil-fuel, campaign
contributions have on the voting behaviour of US Representatives on the topic of
methane pollution safeguard related roll-call votes. Moreover, this paper
contributes to the extensive academic literature on this topic, by analysing the
effect of environemtally related campaign contributions on the representative's
voting on methane pollution safeguards, a topic on which there are few studies.
By using not only Stratmann's logit and probit models and aggregate election but
also a linear probability model with time-related contribution, I am further
extending this area of research. This paper finds that campaign contributions
shape how the representatives votes on this particular matter. Elected officials
are more likely to vote in agreement with the individual and PAC's
contributions, if these interest groups contribute within six months of the
vote.

Albeit including variables which track a representative's political ideology
through roll-call votes (namely the DW-Nominate dimensions), and including
legislator fixed effects to avoid omitted variable bias and thus including
important metrics to measure causal relationships @stratmann-2002 @Selling2023,
no causal relationship between environmentally related campaign contributions
and changes in environmental voting behaviour could be significantly estimated.

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
behaviour of representatives and that dependent on the positions which
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
the pro enviornmental vote of representatives with the campaign contributions
not only six months prior, but also the six months prior to vote contributions
of all similar votes before might show that representatives take contributions
of previous similar votes as a baseline to determine their current votes.

As shown in @results, methane related voting behaviour can be explained very
well given the representative's party and DW-Nominate, meaning that the party
line and ideology is a strong influencer for a legislators vote, and that most
representatives tend to keep within those party lines. Thus, it would be
interesting to analyse the campaign contributions not to individuals but parties
themselves, and how this affects the party's votes on certain issues
@Selling2023

Another interesting topic for research would be to analyse changes in voting
behaviour given by the nature of roll-call votes. Since these happen
alphabetically, representatives whose names are further along the alphabet might
be incentivised to deviate from party lines given a vote is already won/lost.

Using different sources of campaign contributions would also be an interesting
approach. These include not individual and PAC contributions, but Super PAC
contributions, which can be unlimited in size and cannot be directly allocated
to a political candidate @griers. Finally, another interesting approach would be
to use more of the countless open source resources available to import campaign
and representative data by using Application Platform Interfaces (API), which
significantly ease the data collection process. Resources such as the congress
API #footnote(
  "to be found at: https://github.com/LibraryOfCongress/api.congress.gov/",
) or the tidycensus R package #footnote(
  "documentation for which can be found at: https://walker-data.com/tidycensus/",
).

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
