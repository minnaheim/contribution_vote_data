library(tidyverse)

# read in the cleaned rep id data
id_full_reps <- read_csv("data/cleaned/bioguide_full_reps.csv", show_col_types = FALSE)

cands20 <- read_delim("data/original/contributions/CampaignFin20/cands20.txt",
    delim = ",",
    col_names = c(
        "Cycle", "FECCandID", "CID", "FirstLastP", "Party", "DistIDRunFor",
        "DistIDCurr", "CurrCand", "CycleCand", "CRPICO", "RecipCode", "NoPacs"
    ),
    quote = "|",
    show_col_types = FALSE
)
# view(cands20)


# use only sample df, not the whole df, too large...
# indivs20 <- read_delim("data/original/contributions/CampaignFin20/indivs20_sample.txt",
#     delim = ",",
#     col_names = c(
#         "Cycle", "FECTransID", "ContribID", "Contrib", "RecipID", "Orgname",
#         "UltOrg", "RealCode", "Date", "Amount", "Street", "City", "State", "Zip",
#         "RecipCode", "Type", "CmteID", "OtherID", "Gender", "Microfilm", "Occupation",
#         "Employer", "Source"
#     ),
#     quote = "|",
#     show_col_types = FALSE
# )
# # view(indivs20)

# read in pac to candidate contribution data
# pac20 <- read_delim("data/original/contributions/CampaignFin20/pacs20.txt",
#     delim = ",",
#     col_names = c(
#         "Cycle", "FECRecNo", "PACID", "CID", "Amount", "Date", "RealCode", "Type", "DI", "FECCandID"
#     ),
#     quote = "|",
#     show_col_types = FALSE
# )
# view(pac20)
# didnt work, git timed out...

# # try importing first half
indivs20_s <- read_delim("data/original/contributions/CampaignFin20/indivs20.txt",
    delim = ",", n_max = 100, show_col_types = FALSE
)
view(indivs20_s)

# indivs20_s <- read.table("data/original/contributions/CampaignFin20/indivs20.txt",
#     delim = ",", nrows = 100, show_col_types = FALSE
# )
# view(indivs20_s)
