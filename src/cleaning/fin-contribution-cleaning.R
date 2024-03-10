# SET UP
library(tidyverse)

# import data cleaning pipeline:
source("src/cleaning/utils/fin_cleaning_functions.R")
source("src/cleaning/utils/roll_call_cleaning_functions.R")

# IMPORT DATASETS
# fossil fuel oriented
# oil & gas contributions
oil_114 <- read_csv("data/original/oil_gas_contribution-2013-2014.csv",
    show_col_types = FALSE
)
oil_115 <- read_csv("data/original/oil_gas_contribution-2015-2016.csv",
    show_col_types = FALSE
)
oil_116 <- read_csv("data/original/oil_gas_contribution-2017-2018.csv",
    show_col_types = FALSE
)
# coal mining contributions
coal_114 <- read_csv("data/original/Coal_2013-2014.csv",
    show_col_types = FALSE
)
coal_115 <- read_csv("data/original/Coal_2015-2016.csv",
    show_col_types = FALSE
)
coal_116 <- read_csv("data/original/Coal_2017-2018.csv",
    show_col_types = FALSE
)
# mining
mining_114 <- read_csv("data/original/Mining_2013-2014.csv",
    show_col_types = FALSE
)
mining_115 <- read_csv("data/original/Mining_2015-2016.csv",
    show_col_types = FALSE
)
mining_116 <- read_csv("data/original/Mining_2017-2018.csv",
    show_col_types = FALSE
)
# gas pipelines
gas_114 <- read_csv("data/original/Gas_2013-2014.csv",
    show_col_types = FALSE
)
gas_115 <- read_csv("data/original/Gas_2015-2016.csv",
    show_col_types = FALSE
)
gas_116 <- read_csv("data/original/Gas_2017-2018.csv",
    show_col_types = FALSE
)

# environmentally friendly financial contributions
# alternative energy production
alternative_en_114 <- read_csv("data/original/Alternative_Energy_Production_2013-2014.csv",
    show_col_types = FALSE
)
alternative_en_115 <- read_csv("data/original/Alternative_Energy_Production_2015-2016.csv",
    show_col_types = FALSE
)
alternative_en_116 <- read_csv("data/original/Alternative_Energy_Production_2017-2018.csv",
    show_col_types = FALSE
)
# environmental contributions
env_114 <- read_csv("data/original/Environment_2013-2014.csv",
    show_col_types = FALSE
)
env_115 <- read_csv("data/original/Environment_2015-2016.csv",
    show_col_types = FALSE
)
env_116 <- read_csv("data/original/Environment_2017-2018.csv",
    show_col_types = FALSE
)
# data with all politicians of this term (not only those who received contribution)
rep_114 <- read_csv("data/original/term-114.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/original/term-115.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/original/term-116.csv", show_col_types = FALSE)

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

# view(alternative_en_114)
# view(env_114)
# view(gas_114)
# view(mining_114)
# view(coal_114)
# view(oil_114)


# use rep_name_split_keep_imp_cols function
rep_114 <- rep_name_split_keep_imp_cols(rep_114)
rep_115 <- rep_name_split_keep_imp_cols(rep_115)
rep_116 <- rep_name_split_keep_imp_cols(rep_116)

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

# write.csv(master_df_114, "data/cleaned/master_df_114.csv")
# write.csv(master_df_115, "data/cleaned/master_df_115.csv")
# write.csv(master_df_115, "data/cleaned/master_df_116.csv")

# merge datasets
master_df <- term_merge(
    list(
        master_df_114,
        master_df_115,
        master_df_116
    )
)
# view(master_df)
# finish id_reps & count contributions part

# in total, the master dataset has 552 rows. aka 435 per Session = 1305 persons
# (since we only have 552 though, this means that most overlap)

# create a column called count_contribution



# merge financial contributions with unique id
id_reps <- suppressMessages(read_csv("data/cleaned_unique_id_reps_copy.csv", show_col_types = FALSE))


# remove index column, rename Member ID to member_id
id_reps <- subset(id_reps, select = -...1)
id_reps <- id_reps %>%
    rename(member_id = `Member ID`)

view(id_reps)


# to merge with fuzzy join, we also include the party and states, for that we need to include the abbreviations of the states
state_abbreviations <- suppressMessages(read_csv("data/state_abbreviations.csv", show_col_types = FALSE))
view(state_abbreviations)

# change State column to include only abbreviations of respective states
for (i in 1:nrow(id_reps)) {
    if (!is.na(id_reps$State[i]) && nchar(id_reps$State[i]) > 2) {
        state <- id_reps$State[i]
        matching_postal <- state_abbreviations$Postal[state_abbreviations$State == state]
        if (length(matching_postal) > 0) {
            id_reps$State[i] <- matching_postal[1]
        }
    }
}
view(id_reps)
