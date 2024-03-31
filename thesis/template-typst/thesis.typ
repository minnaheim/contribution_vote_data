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
- Literature & Methods used
  - based on strattman, empirical and theoretical part, (causal identification
    strategy) use of campaign contribution and roll call data, OLS/probit
- Outline
  - first, theoretical review of campaign contribution literature, then model to
    estimate contribution effect

#pagebreak()

= Literature Review
== Money in Politic
== Institutional Settings
- legal background dictating campaign contributions
- US political landscape?
== Causal effect of campaign money on representatives’ voting decisions.

#pagebreak()
= Methodology
== Strattman paper vs. mine
== Data
=== Types of data
+ sources
+ (cleaning?)
== Models
+ Robustness Checks

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