## Effect of fossil fuel & environmental related campaign contributions on the voting behavior of US House members on methane related bills


### project file layout
```
├── README.md
├── src
│   ├── analysis
│   │   ├── plots
│   │   ├── model
│   ├── cleaning
│   │   ├── utils  
├── data
│   ├── cleaned
│   ├── original (raw data)
├── thesis
│   ├── notes
│   ├── first draft (incl. bib, figures, tables, etc.)

```
### type of data
- unique_id_reps (member_id of every house member)
- roll call data (votes on 6 methane (pollution safeguard) related bills)
- financial contributions 
    - `contributions_*.csv` = contributions of energy and env. sectors for all house candidates in that congress election
    - all_reps_*.csv = contributions of energy and env. sectors for all house members in that session
    - all_reps.csv = contributions of energy and env. sectors for all house members in all sessions (113th until 117th congress)

### cleaned data:
- `roll_call.csv` -> roll_call data of 6 methane bills (between 113 - 117th session)
- `representatives.csv` -> cleaned representative data of all sessions (113 - 117th session)
- `contributions.csv` -> contributions of oil, gas, mining, coal, environmental and alternative energy industries to representatives (113 - 117th session)
- `unique_id_reps.csv` -> unique id of all house members
- `final_df.csv` -> roll_call and contributions dfs merged on unique_id_reps' member_id.

### data sources:
- [OpenSecrets](https://www.opensecrets.org/)
    - all contribution data (of all house candidates)
- [LCVScorecard](https://scorecard.lcv.org)
    - all roll_call data
- [Clerk of the House](https://clerk.house.gov/)
    - house members of congresses 113 and 117,114, 115, 116.
- [List of all congress members and their IDs](https://www.congress.gov/help/field-values/member-bioguide-ids)
    