# SET UP
library(tidyverse)
library(fuzzyjoin)

# import data cleaning pipeline:
source("src/cleaning/utils/fin_cleaning_functions.R")
source("src/cleaning/utils/roll_call_cleaning_functions.R")
# source("src/cleaning/utils/rep_cleaning_functions.R")

# IMPORT DATASETS
# fossil fuel oriented
# oil & gas contributions
oil_114 <- read_csv("data/original/oil_gas_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
oil_115 <- read_csv("data/original/oil_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
oil_116 <- read_csv("data/original/oil_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
# coal mining contributions
coal_114 <- read_csv("data/original/coal_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
coal_115 <- read_csv("data/original/coal_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
coal_116 <- read_csv("data/original/coal_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
# mining
mining_114 <- read_csv("data/original/mining_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
mining_115 <- read_csv("data/original/mining_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
mining_116 <- read_csv("data/original/mining_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
# gas pipelines
gas_114 <- read_csv("data/original/gas_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
gas_115 <- read_csv("data/original/gas_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
gas_116 <- read_csv("data/original/gas_house_candidates_2018_el.csv",
    show_col_types = FALSE
)

# environmentally friendly financial contributions
# alternative energy production
alternative_en_114 <- read_csv("data/original/alt_en_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
alternative_en_115 <- read_csv("data/original/alt_en_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
alternative_en_116 <- read_csv("data/original/alt_en_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
# environmental contributions
env_114 <- read_csv("data/original/env_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
env_115 <- read_csv("data/original/env_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
env_116 <- read_csv("data/original/env_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
# cleaned data with all politicians of this term (not only those who received contribution)
rep_114 <- read_csv("data/cleaned/cleaned_representatives_114_manual.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/cleaned/cleaned_representatives_115_manual.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/cleaned/cleaned_representatives_116_manual.csv", show_col_types = FALSE)

# CLEAN DATA
# 114th Congress
# DIRTY
# oil & gas contributions
# view(oil_114)
oil_114 <- contribution_clean(oil_114)
oil_115 <- contribution_clean(oil_115)
oil_116 <- contribution_clean(oil_116)

# coal mining contributions
coal_114 <- contribution_clean(coal_114)
coal_115 <- contribution_clean(coal_115)
coal_116 <- contribution_clean(coal_116)

# mining
mining_114 <- contribution_clean(mining_114)
mining_115 <- contribution_clean(mining_115)
mining_116 <- contribution_clean(mining_116)

# gas pipelines
gas_114 <- contribution_clean(gas_114)
gas_115 <- contribution_clean(gas_115)
gas_116 <- contribution_clean(gas_116)

# CLEAN
# environmental contributions
env_114 <- contribution_clean(env_114)
env_115 <- contribution_clean(env_115)
env_116 <- contribution_clean(env_116)
# alternative energy sources
alternative_en_114 <- contribution_clean(alternative_en_114)
alternative_en_115 <- contribution_clean(alternative_en_115)
alternative_en_116 <- contribution_clean(alternative_en_116)

# since this rep data is pre-cleaned, we don't need to apply the rep_name_split_keep_imp_cols function,
# just the remove_index_state_abbrev function

# apply remove_index_state_abbrev function
rep_114 <- remove_index(rep_114)
rep_115 <- remove_index(rep_115)
rep_116 <- remove_index(rep_116)

# apply state abbreviations to state
rep_114 <- add_state_abbrev(rep_114)
rep_115 <- add_state_abbrev(rep_115)
rep_116 <- add_state_abbrev(rep_116)

# apply party abbreviation function
rep_114 <- party_abbreviation(rep_114)
rep_115 <- party_abbreviation(rep_115)
rep_116 <- party_abbreviation(rep_116)

# view(rep_114)
# view(rep_115)
# view(rep_116)

# add suffix to columns "Amount", "Party", "StateAbbreviation" based on the dataset
columns_to_suffix <- c("Amount", "Party", "StateAbbreviation")
oil_114 <- add_suffix(oil_114, ".oil.114", columns_to_suffix)
oil_115 <- add_suffix(oil_115, ".oil.115", columns_to_suffix)
oil_116 <- add_suffix(oil_116, ".oil.116", columns_to_suffix)

coal_114 <- add_suffix(coal_114, ".coal.114", columns_to_suffix)
coal_115 <- add_suffix(coal_115, ".coal.115", columns_to_suffix)
coal_116 <- add_suffix(coal_116, ".coal.116", columns_to_suffix)

mining_114 <- add_suffix(mining_114, ".mining.114", columns_to_suffix)
mining_115 <- add_suffix(mining_115, ".mining.115", columns_to_suffix)
mining_116 <- add_suffix(mining_116, ".mining.116", columns_to_suffix)

gas_114 <- add_suffix(gas_114, ".gas.114", columns_to_suffix)
gas_115 <- add_suffix(gas_115, ".gas.115", columns_to_suffix)
gas_116 <- add_suffix(gas_116, ".gas.116", columns_to_suffix)

env_114 <- add_suffix(env_114, ".env.114", columns_to_suffix)
env_115 <- add_suffix(env_115, ".env.115", columns_to_suffix)
env_116 <- add_suffix(env_116, ".env.116", columns_to_suffix)

alternative_en_114 <- add_suffix(alternative_en_114, ".alt_en.114", columns_to_suffix)
alternative_en_115 <- add_suffix(alternative_en_115, ".alt_en.115", columns_to_suffix)
alternative_en_116 <- add_suffix(alternative_en_116, ".alt_en.116", columns_to_suffix)

# Process datasets for each congressional term
master_df_114 <- process_financial_data(
    list(
        oil_114,
        coal_114,
        mining_114,
        gas_114,
        env_114,
        alternative_en_114
    )
)
master_df_115 <- process_financial_data(
    list(
        oil_115,
        coal_115,
        mining_115,
        gas_115,
        env_115,
        alternative_en_115
    )
)
master_df_116 <- process_financial_data(
    list(
        oil_116,
        coal_116,
        mining_116,
        gas_116,
        env_116,
        alternative_en_116
    )
)

# view(master_df_114)
write.csv(master_df_114, "data/cleaned/master_df_114.csv")
write.csv(master_df_115, "data/cleaned/master_df_115.csv")
write.csv(master_df_115, "data/cleaned/master_df_116.csv")


# merge master dfs from each term with the list of all representatives
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

# repeat for 115 and 116
all_reps_115 <- left_join(rep_115[, c("LastName", "FirstName", "State", "Party")],
    master_df_115,
    by = c("LastName", "FirstName", c("State" = "StateAbbreviation"), c("Party"))
)
# NA to 0 for all amount cols, aka those who did not receive any contributions from the energy & env. sectors
amount_cols <- grep("^Amount", names(all_reps_115), value = TRUE)
all_reps_115[amount_cols][is.na(all_reps_115[amount_cols])] <- 0
# remove non-voting members
all_reps_115 <- remove_non_voting(all_reps_115)

# view(all_reps_115)

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


# merge datasets
# merge datasets
master_df <- term_merge_2(
    list(
        all_reps_114,
        all_reps_115,
        all_reps_116
    )
)
# view(master_df)
# 597 elements -> account for changes in house of representatives...(approx. 20 changes per session)

# write.csv(cleaned_financial_data, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_financial_data.csv")
