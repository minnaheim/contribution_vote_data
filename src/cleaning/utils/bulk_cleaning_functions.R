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


# create contribution cleaning function that only keeps industries, contribution types and contributions after a certain date
clean_contributions <- function(contributions, cutoff_date) {
    contributions$Date <- mdy(contributions$Date)
    cutoff_date <- mdy(cutoff_date)
    vote_date <- cutoff_date %m+% months(6) %m+% days(1) # 6 mo. after the cutoff date
    contributions <- contributions %>%
        filter(Date > cutoff_date) %>%
        filter(Date < vote_date) %>% # only contributions 6 mo. before the vote
        filter(Type != "22Y")
    #  %>%
    # filter(str_detect(RealCode, "^E"))
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
    indivs22 <- read_csv("data/cleaned/semi_clean/indivs22.csv", show_col_types = FALSE, lazy = TRUE)
    indivs20 <- read_csv("data/cleaned/semi_clean/indivs20.csv", show_col_types = FALSE, lazy = TRUE)
    indivs18 <- read_csv("data/cleaned/semi_clean/indivs18.csv", show_col_types = FALSE, lazy = TRUE)
    indivs16 <- read_csv("data/cleaned/semi_clean/indivs16.csv", show_col_types = FALSE, lazy = TRUE)
    indivs14 <- read_csv("data/cleaned/semi_clean/indivs14.csv", show_col_types = FALSE, lazy = TRUE)
    indivs12 <- read_csv("data/cleaned/semi_clean/indivs12.csv", show_col_types = FALSE, lazy = TRUE)
    pac22 <- read_csv("data/cleaned/semi_clean/pacs22.csv", show_col_types = FALSE, lazy = TRUE)
    pac20 <- read_csv("data/cleaned/semi_clean/pacs20.csv", show_col_types = FALSE, lazy = TRUE)
    pac18 <- read_csv("data/cleaned/semi_clean/pacs18.csv", show_col_types = FALSE, lazy = TRUE)
    pac16 <- read_csv("data/cleaned/semi_clean/pacs16.csv", show_col_types = FALSE, lazy = TRUE)
    pac14 <- read_csv("data/cleaned/semi_clean/pacs14.csv", show_col_types = FALSE, lazy = TRUE)
    pac12 <- read_csv("data/cleaned/semi_clean/pacs12.csv", show_col_types = FALSE, lazy = TRUE)
    contributions <- list(
        indivs12, indivs14,
        indivs16, indivs18, indivs20,
        indivs22, pac12, pac14, pac16,
        pac18, pac20, pac22
    )
    for (i in 1:length(contributions)) {
        contributions[[i]] <- clean_contributions(contributions[[i]], cutoff_date)
    }
    contribution <- combine_all_contributions(contributions, rep)
    return(contribution)
}
