# SET UP
library(tidyverse)
library(fuzzyjoin)

# import data cleaning pipeline:
source("src/cleaning/utils/fin_cleaning_functions.R")
source("src/cleaning/utils/roll_call_cleaning_functions.R")
# source("src/cleaning/utils/rep_cleaning_functions.R")


contributions <- read_from_folder("data/cleaned/contributions")
representatives <- read_from_folder("data/cleaned/representatives")

# import data
rep_113 <- suppressMessages(read_csv("data/cleaned/cleaned_representatives_113.csv", show_col_types = FALSE))
rep_114 <- suppressMessages(read_csv("data/cleaned/cleaned_representatives_114_manual.csv", show_col_types = FALSE))
rep_115 <- suppressMessages(read_csv("data/cleaned/cleaned_representatives_115_manual.csv", show_col_types = FALSE))
rep_116 <- suppressMessages(read_csv("data/cleaned/cleaned_representatives_116_manual.csv", show_col_types = FALSE))
rep_117 <- suppressMessages(read_csv("data/cleaned/cleaned_representatives_117_manual.csv", show_col_types = FALSE))

master_df_113 <- read_csv("data/cleaned/contributions_113.csv", show_col_types = FALSE)
master_df_114 <- read_csv("data/cleaned/contributions_114.csv", show_col_types = FALSE)
master_df_115 <- read_csv("data/cleaned/contributions_115.csv", show_col_types = FALSE)
master_df_116 <- read_csv("data/cleaned/contributions_116.csv", show_col_types = FALSE)
master_df_117 <- read_csv("data/cleaned/contributions_117.csv", show_col_types = FALSE)

# apply remove_index_state_abbrev function
rep_113 <- remove_index(rep_113)
rep_114 <- remove_index(rep_114)
rep_115 <- remove_index(rep_115)
rep_116 <- remove_index(rep_116)
rep_117 <- remove_index(rep_117)

# apply state abbreviations to state
rep_113 <- add_state_abbrev(rep_113)
rep_114 <- add_state_abbrev(rep_114)
rep_115 <- add_state_abbrev(rep_115)
rep_116 <- add_state_abbrev(rep_116)
rep_117 <- add_state_abbrev(rep_117)

# apply party abbreviation function
rep_113 <- party_abbreviation(rep_113)
rep_114 <- party_abbreviation(rep_114)
rep_115 <- party_abbreviation(rep_115)
rep_116 <- party_abbreviation(rep_116)
rep_117 <- party_abbreviation(rep_117)

# view(rep_113)
# view(rep_114)
# view(rep_117)
# view(rep_115)
# view(rep_116)

# 113
# PROBLEM WITH DATA FROM 113 AND 117 IS THAT MERGE ISNT AS SMOOOTH AS WITH 114,115,116 -> FUZZY MERGE W/ ID BEFORE
all_reps_113 <- left_join(rep_113[, c("LastName", "FirstName", "State", "Party")],
    master_df_113,
    by = c("LastName", "FirstName", c("State" = "StateAbbreviation"), c("Party"))
)
# view(rep_113)
# view(all_reps_113)
# NA to 0 for all amount cols, aka those who did not receive any contributions from the energy & env. sectors
amount_cols <- grep("^Amount", names(all_reps_113), value = TRUE)
all_reps_113[amount_cols][is.na(all_reps_113[amount_cols])] <- 0

# remove non-voting members
all_reps_113 <- remove_non_voting(all_reps_113)
# find the representatives who did not receive any contributions
all_reps_113_0 <- all_reps_113 %>% dplyr::filter(Amount.oil.113 == 0 & Amount.coal.113 == 0 & Amount.mining.113 == 0 &
    Amount.gas.113 == 0 & Amount.env.113 == 0 & Amount.alt_en.113 == 0)
# view(all_reps_113_0)
# 134 rows



# 114
all_reps_114 <- left_join(rep_114[, c("LastName", "FirstName", "State", "Party")],
    master_df_114,
    by = c("LastName", "FirstName", c("State" = "StateAbbreviation"), c("Party"))
)
# NA to 0 for all amount cols, aka those who did not receive any contributions from the energy & env. sectors
amount_cols <- grep("^Amount", names(all_reps_114), value = TRUE)
all_reps_114[amount_cols][is.na(all_reps_114[amount_cols])] <- 0

# remove non-voting members
all_reps_114 <- remove_non_voting(all_reps_114)

# view(all_reps_114)

# find the representatives who did not receive any contributions
all_reps_114_0 <- all_reps_114 %>% dplyr::filter(Amount.oil.114 == 0 & Amount.coal.114 == 0 & Amount.mining.114 == 0 &
    Amount.gas.114 == 0 & Amount.env.114 == 0 & Amount.alt_en.114 == 0)

# view(all_reps_114_0)
# 13 rows


# 115
all_reps_115 <- left_join(rep_115[, c("LastName", "FirstName", "State", "Party")],
    master_df_115,
    by = c("LastName", "FirstName", c("State" = "StateAbbreviation"), c("Party"))
)
# NA to 0 for all amount cols, aka those who did not receive any contributions from the energy & env. sectors
amount_cols <- grep("^Amount", names(all_reps_115), value = TRUE)
all_reps_115[amount_cols][is.na(all_reps_115[amount_cols])] <- 0
# remove non-voting members
all_reps_115 <- remove_non_voting(all_reps_115)

# find the representatives who did not receive any contributions
all_reps_115_0 <- all_reps_115 %>% dplyr::filter(Amount.oil.115 == 0 & Amount.coal.115 == 0 & Amount.mining.115 == 0 &
    Amount.gas.115 == 0 & Amount.env.115 == 0 & Amount.alt_en.115 == 0)

# view(all_reps_115_0)
# 25 rows


# view(all_reps_115)
# 116
all_reps_116 <- left_join(rep_116[, c("LastName", "FirstName", "State", "Party")],
    master_df_116,
    by = c("LastName", "FirstName", c("State" = "StateAbbreviation"), c("Party"))
)
# NA to 0 for all amount cols, aka those who did not receive any contributions from the energy & env. sectors
amount_cols <- grep("^Amount", names(all_reps_116), value = TRUE)
all_reps_116[amount_cols][is.na(all_reps_116[amount_cols])] <- 0
# remove non-voting members
all_reps_116 <- remove_non_voting(all_reps_116)
# view(all_reps_116)

# find the representatives who did not receive any contributions
all_reps_116_0 <- all_reps_116 %>% dplyr::filter(Amount.oil.116 == 0 & Amount.coal.116 == 0 & Amount.mining.116 == 0 &
    Amount.gas.116 == 0 & Amount.env.116 == 0 & Amount.alt_en.116 == 0)

# view(all_reps_116_0)
# 18 rows

# 117
# merge with ID first
rep_117 <- fuzzy_join_id(rep_117, id_reps)
rep_117 <- remove_duplicated(rep_117)
rep_117 <- remove_y_cols(rep_117)
# view(rep_117) # -> all good.

# view(master_df_117)
# view(id_reps)
# master_df_117 <- master_df_117 %>% rename("State" = "StateAbbreviation")
# master_df_117 <- fuzzy_join_id(master_df_117, id_reps)

all_reps_117 <- fuzzy_left_join(rep_117, master_df_117,
    by = c("LastName", "FirstName", c("State" = "StateAbbreviation"), "Party"),
    match_fun = list(fuzzy_match_last, fuzzy_match_first, `==`, `==`)
)
view(all_reps_117)
# NA to 0 for all amount cols, aka those who did not receive any contributions from the energy & env. sectors
amount_cols <- grep("^Amount", names(all_reps_117), value = TRUE)
all_reps_117[amount_cols][is.na(all_reps_117[amount_cols])] <- 0
# remove non-voting members
all_reps_117 <- remove_non_voting(all_reps_117)
# view(all_reps_117)

# find the representatives who did not receive any contributions
all_reps_117_0 <- all_reps_117 %>% dplyr::filter(Amount.oil.117 == 0 & Amount.coal.117 == 0 & Amount.mining.117 == 0 &
    Amount.gas.117 == 0 & Amount.env.117 == 0 & Amount.alt_en.117 == 0)

# view(all_reps_117_0)
# 222 before, now 213 rows -> something's wrong


# now add the unique ID reps:
# merge financial contributions with unique id
id_reps <- suppressMessages(read_csv("data/cleaned/cleaned_unique_id_reps_copy_2.csv", show_col_types = FALSE))

# apply cleaning function to id_reps
id_reps <- clean_id_reps(id_reps)
# view(id_reps)


# merge id with fuzzy join

all_reps_114 <- fuzzy_join_id(all_reps_114, id_reps)
all_reps_115 <- fuzzy_join_id(all_reps_115, id_reps)
all_reps_116 <- fuzzy_join_id(all_reps_116, id_reps)

all_reps_114 <- remove_duplicated(all_reps_114)
all_reps_115 <- remove_duplicated(all_reps_115)
all_reps_116 <- remove_duplicated(all_reps_116)

all_reps_114 <- remove_y_cols(all_reps_114)
all_reps_115 <- remove_y_cols(all_reps_115)
all_reps_116 <- remove_y_cols(all_reps_116)

# view(all_reps_114) -> no more ID NAs
# view(all_reps_115) -> no more ID NAs
# view(all_reps_116) -> no more ID NAs
# looks like no mismatches?

# merge based on id, party, state and names
all_reps <- term_merge_id(list(all_reps_114, all_reps_115, all_reps_116))
# view(all_reps)


# 597 elements -> ac count for changes in house of representatives...(approx. 20 changes per session)
write.csv(all_reps_114, "data/cleaned/cleaned_all_reps_contribution_114.csv")
write.csv(all_reps_115, "data/cleaned/cleaned_all_reps_contribution_115.csv")
write.csv(all_reps_116, "data/cleaned/cleaned_all_reps_contribution_116.csv")
write.csv(all_reps, "data/cleaned/cleaned_financial_data.csv")
