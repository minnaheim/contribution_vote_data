library(glue)
library(tidyverse)

# basic cleaning function for individual contributions

indiv_basic_cleaning <- function(cycle) {
    cylce <- as.character(cycle)
    read_delim(glue("data/original/contributions/CampaignFin{cylce}/indivs{cylce}.txt"),
        delim = ",",
        col_names = c(
            "Cycle", "FECTransID", "ContribID", "Contrib", "RecipID", "Orgname",
            "UltOrg", "RealCode", "Date", "Amount", "Street", "City", "State", "Zip",
            "RecipCode", "Type", "CmteID", "OtherID", "Gender", "Microfilm", "Occupation",
            "Employer", "Source"
        ),
        quote = "|",
        show_col_types = FALSE,
        lazy = TRUE
    ) |>
        select(c(Cycle, RecipID, RealCode, Date, Amount, Type))
}

# basic cleaning function for pac to candidate contributions
pac_basic_cleaning <- function(cycle) {
    cylce <- as.character(cycle)
    read_delim(glue("data/original/contributions/CampaignFin{cylce}/pacs{cylce}.txt"),
        delim = ",",
        col_names = c(
            "Cycle", "FECRecNo", "PACID", "CID", "Amount", "Date", "RealCode", "Type", "DI", "FECCandID"
        ),
        quote = "|",
        show_col_types = FALSE,
        lazy = TRUE
    ) |>
        select(c(Cycle, CID, RealCode, Date, Amount, Type))
}

# cands20 <- read_delim("data/original/contributions/CampaignFin20/cands20.txt",
#     delim = ",",
#     col_names = c(
#         "Cycle", "FECCandID", "CID", "FirstLastP", "Party", "DistIDRunFor",
#         "DistIDCurr", "CurrCand", "CycleCand", "CRPICO", "RecipCode", "NoPacs"
#     ),
#     quote = "|",
#     show_col_types = FALSE,
#     lazy = TRUE
# )
# head(cands20)
# view(cands20)


# create contribution cleaning function that only keeps industries, contribution types and contributions after a certain date
clean_contributions <- function(contributions, cutoff_date) {
    contributions$Date <- mdy(contributions$Date)
    contributions %>%
        filter(Date > cutoff_date) %>%
        filter(Type != "22Y") %>%
        filter(str_detect(RealCode, "^E"))
    return(contributions)
}
