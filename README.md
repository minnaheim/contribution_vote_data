## Effect of fossil fuel & environmental related campaign contributions on the voting behavior of US House members on methane related bills

You can find the actual thesis [here](https://github.com/minnaheim/contribution_vote_data/blob/main/thesis/template-typst/thesis.pdf)

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
├── presentation
├── thesis/template-typst
│   ├── common
│   ├── figures
│   ├── thesis_typ
```
### type of cleaned data
- `df.csv` -> dataframe of all representatives, their IDs, votes, contributions and control variables (DW-nominate, seniority, party affiliations, gender, etc.)
- `roll_call.csv` -> dataframe of all representatives who partook in at least one of the congressional sessions 113-117, incl. their IDs, full names, party affiliation, etc.
- `contribs_long.csv` -> dataframe of the individual and PAC contributions which each representative received within six months of the vote, from only relevant (energy - fossil fuel and enviornmentally related source), pivoted by the vote

### cleaned data used for the analysis :
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
- [Bioguide](https://bioguide.org)
- [Github Congress Repository](https://github.io)


### further details 
The main branch only includes the data and analysis from the main results, i.e. those with the contributions within 6 months of the vote, not the contributions of the entire previous congressional election. The results from the aggregate contributions can be found on the `emergency-backup` branch.
