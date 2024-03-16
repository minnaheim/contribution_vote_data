# Bachelor thesis:

## project file layout
```
├── README.md
├── src
│   ├── analysis
│   ├── cleaning
│   │   ├── utils  
├── data
│   ├── cleaned
│   ├── original (raw data)
├── thesis
│   ├── notes
│   ├── first draft (incl. bib, figures, tables, etc.)

```
## type of data
- representatives
- votes
    - 
- financial contributions 
    - `contributions_*.csv` = contributions of energy and env. sectors for all house candidates in that congress election
    - all_reps_*.csv = contributions of energy and env. sectors for all house members in that session
    - all_reps.csv = contributions of energy and env. sectors for all house members in all sessions (113th until 117th congress)

## cleaned data:
- `reps_contributions.csv` -> merged rep data and financial data of all sessions

## data sources:
- [OpenSecrets](https://www.opensecrets.org/)
    - all contribution data (of all house candidates)
- [LCVScorecard](https://scorecard.lcv.org)
    - all roll_call data
- [Clerk of the House](https://clerk.house.gov/)
    - house members of congresses 113 and 117.
- [?]
    - house members of congresses 114, 115, 116.
- [List of all congress members and their IDs](https://www.congress.gov/help/field-values/member-bioguide-ids)
    