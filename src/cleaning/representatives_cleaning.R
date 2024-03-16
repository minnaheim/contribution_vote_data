# this dataset serves to clean the list of all representatives in the house sessions 114,
# 115 and 116, so that we have a complete list of financial contributions (also with members who did not receive fin. contributions)
# setup
source("src/cleaning/utils/rep_cleaning_functions.R")
source("src/cleaning/utils/fin_cleaning_functions.R")
source("src/cleaning/utils/roll_call_cleaning_functions.R")

library(tidyverse)
library(dplyr)

# import data
rep_113 <- read_csv("data/original/representatives/term-113.csv", show_col_types = FALSE)
rep_114 <- read_csv("data/original/representatives/representatives_114_manual.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/original/representatives/representatives_115.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/original/representatives/representatives_116.csv", show_col_types = FALSE)
rep_117 <- read_csv("data/original/representatives/term-117.csv", show_col_types = FALSE)

rep_114 <- rep_cleaning(rep_114)
rep_115 <- rep_cleaning(rep_115)
rep_116 <- rep_cleaning(rep_116)


# cleaning of rep_117
rep_117 <- party_abbreviation(rep_117, "Party")
rep_117 <- subset(rep_117, select = -c(State)) # remove state column
rep_117 <- rename(rep_117,
    last_name = "LastName",
    first_name = "FirstName",
    party = "Party",
    state = "StateAbbreviation"
) # rename columns

# view(rep_117)

# cleaning rep_113
rep_113 <- rep_113 %>% select(sort_name, group, area_id)
rep_113 <- separate(rep_113, "sort_name", into = c("last_name", "first_name"), sep = ", ")
rep_113 <- separate(rep_113, "area_id", into = c("state", "district"), sep = "-")
rep_113 <- rename(rep_113, party = "group")
rep_113 <- party_abbreviation(rep_113)
# view(rep_113)

rep_114 <- party_abbreviation(rep_114)
rep_115 <- party_abbreviation(rep_115)
rep_116 <- party_abbreviation(rep_116)

rep_114 <- add_state_abbrev(rep_114)
rep_115 <- add_state_abbrev(rep_115)
rep_116 <- add_state_abbrev(rep_116)
# works till here

dfs <- list(rep_113, rep_114, rep_115, rep_116, rep_117)


# fuzzyjoin each df with unique id reps
for (i in 1:length(dfs)) {
    dfs[[i]] <- fuzzy_join_representative_id(
        dfs[[i]],
        c("last_name", "first_name", "party", "state")
    )
    view(dfs[[i]])
    break
}


# write csv
# write.csv(rep_113, "data/cleaned/representatives/113.csv", row.names = FALSE)
# write.csv(rep_114, "data/cleaned/representatives/114.csv", row.names = FALSE)
# write.csv(rep_115, "data/cleaned/representatives/115.csv", row.names = FALSE)
# write.csv(rep_116, "data/cleaned/representatives/116.csv", row.names = FALSE)
# write.csv(rep_117, "data/cleaned/representatives/117.csv", row.names = FALSE)
