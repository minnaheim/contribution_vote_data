
#import "@preview/cetz:0.2.2"
#cetz.canvas({
  import cetz.draw: *
  import cetz.chart
  let data = (
    ("1998", 2934),
    ("2000", 2860),
    ("2002", 3575),
    ("2004", 3496),
    ("2006", 4143),
    ("2008", 6724),
    ("2010", 4926),
    ("2012", 4710),
    ("2014", 4788),
    ("2016", 5071),
    ("2018", 6724),
    ("2020", 9916),
    ("2022", 8937),
  )
  group(name: "a", {
    chart.columnchart(size: (16, 5), data)
  })
})
// in millions

= Bachelor Thesis Notes
#set heading(numbering: "1.")
#outline(indent: auto)
= Introduction
- Koch Industries example (2016 elections)
  - use opensecrets data
- sections in thesis
- literature & methods used

= Literature Review / Institutional Settings
== Money in politics literature (economics and political science)
- Stratmann, 2005 - Money in Politics

== Causal effect of campaign money on representatives’ voting decisions.
= Methodology
== Strattman paper vs. mine
== Data
=== types of data
+ sources
+ (cleaning?)
== Models
+ Robustness Checks
= Results
== discuss differences with Strattman due to difference in legislation
+ Discussion
+ Conclusion

#pagebreak()
#strong("Tables to replicate") \
Replicate Strattmann table with the following data out of 725, 557 are vote
repeaters, 6 votes 23 mind changers, out of 557 96 people voted + on all bills,
out of 557 71 voted ­ on all bills, out of 557 find how many voted + and then
from vote changers (then mark which bill) 5 + 2 person voted + and then ­ on 6
bills find how many voted ­ and then + from vote changers (then mark which bill)
5 + 16 persons voted and then + on the bills

#strong("data cleaning problems")
- merging names of diff sources (rollcall, financial, not uniform names)
- added ID column (and used fuzzyjoin & stringdist)
- stringsim/ fuzzy matching(choose the best option)
- clean_strings for removing accents, special symbols in names

#strong("Model")
- 3 OLS models
- time and state fixed effects (state,i.e. oil & political leaning)
- DW Sentiment index?

#strong("Questions for Professors when reviewing methodology")
- is there a bias i am creating because i am using the general sample and then
  just the subsample that will distort my results (never select based on outcome)
- control for party