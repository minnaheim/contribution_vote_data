#strong("Bachelors Thesis Notes")

#strong("Structure of Thesis")

#list("")
Structure of Thesis
1. Introduction
• Koch Industries example (2016 elections) ­> campaign
2. Literature Review
• (institutional setting)
• Money in politics literature (economics and political science)
• Causal effect of campaign money on representatives’ voting decisions.
3. Methodology
• Data
• types of data
• sources
• (cleaning?)
• Models
• Robustness Checks
4. Results
5. Discussion
6. Conclusion
Replicate Strattmann table with the following data out of 725, 557 are vote repeaters ­> 6 votes 23
mind changers, out of 557 96 people voted + on all bills, out of 557 71 voted ­ on all bills, out of 557
find how many voted + and then ­ from vote changers (then mark which bill) 5 + 2 person voted + and
then ­ on 6 bills find how many voted ­ and then + from vote changers (then mark which bill) 5 + 16
persons voted ­ and then + on the bills


#strong(data cleaning problems)
- merging names of diff sources (rollcall, financial, not uniform names)
- added ID column (and used fuzzyjoin & stringdist)
- stringsim/ fuzzy matching(choose the best option)
-  clean_strings for removing accents, special symbols in names

#strong(Model)
- 3 OLS models
- time and state fixed effects (state,i.e. oil & political leaning)
- DW Sentiment index?


