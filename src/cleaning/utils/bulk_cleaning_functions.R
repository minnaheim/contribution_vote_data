library(glue)
library(tidyverse)
source("src/cleaning/utils/combine_columns.R")
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
        select(c(Cycle, RecipID, RealCode, Date, Amount, Type)) |>
        filter(str_detect(RealCode, "^E"))
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
        select(c(Cycle, CID, RealCode, Date, Amount, Type)) |>
        filter(str_detect(RealCode, "^E"))
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
    cutoff_date <- mdy(cutoff_date)
    vote_date <- cutoff_date %m+% months(6) %m+% days(1) # 6 mo. after the cutoff date
    print(vote_date)
    contributions <- contributions %>%
        filter(Date > cutoff_date) %>%
        filter(Date < vote_date) %>% # only contributions 6 mo. before the vote
        filter(Type != "22Y")
    #  %>%
    # filter(str_detect(RealCode, "^E"))
    return(contributions)
}
# keep only representatives...
clean_ind_contributions <- function(contributions, cutoff_date) {
    contributions$Date <- mdy(contributions$Date)
    cutoff_date <- mdy(cutoff_date)
    contributions <- contributions %>%
        filter(Date > cutoff_date) %>%
        filter(Type != "22Y") %>%
        filter(str_detect(RealCode, "^E")) %>%
        filter(str_detect(RecipID, "^N"))
    return(contributions)
}


# concatinate all individual and pac contributions and combine the diff ID columns, and merge with the representatives from that session
combine_contributions <- function(indivs, pacs, reps) {
    contribs <- bind_rows(indivs, pacs)
    contribs <- combine_diff_columns(contribs, "CID", "RecipID")
    # view(contribs)
    contribs_reps <- inner_join(reps, contribs, by = c("opensecrets_id" = "CID"))
    # view(contribs_reps)
    return(contribs_reps)
}


# combine all contributions
combine_all_contributions <- function(contributions, reps) {
    contribs <- bind_rows(contributions)
    contribs <- combine_diff_columns(contribs, "CID", "RecipID")
    # view(contribs)
    contribs_reps <- inner_join(reps, contribs, by = c("opensecrets_id" = "CID"))
    # view(contribs_reps)
    return(contribs_reps)
}


clean_contribs_for_vote <- function(rep, cutoff_date) {
    indivs22 <- read_csv("data/cleaned/semi_clean/indivs22_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    indivs20 <- read_csv("data/cleaned/semi_clean/indivs20_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    indivs18 <- read_csv("data/cleaned/semi_clean/indivs18_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    indivs16 <- read_csv("data/cleaned/semi_clean/indivs16_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    indivs14 <- read_csv("data/cleaned/semi_clean/indivs14_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    indivs12 <- read_csv("data/cleaned/semi_clean/indivs12_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    pac22 <- read_csv("data/cleaned/semi_clean/pac22_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    pac20 <- read_csv("data/cleaned/semi_clean/pac20_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    pac18 <- read_csv("data/cleaned/semi_clean/pac18_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    pac16 <- read_csv("data/cleaned/semi_clean/pac16_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    pac14 <- read_csv("data/cleaned/semi_clean/pac14_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    pac12 <- read_csv("data/cleaned/semi_clean/pac12_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
    print("read in")
    contributions <- list(
        indivs12, indivs14,
        indivs16, indivs18, indivs20,
        indivs22, pac12, pac14, pac16,
        pac18, pac20, pac22
    )
    print("contributions vector")
    for (i in 1:length(contributions)) {
        contributions[[i]] <- clean_contributions(contributions[[i]], cutoff_date)
    }
    print("concatinated")
    contribution <- combine_all_contributions(contributions, rep)
    return(contribution)
}
