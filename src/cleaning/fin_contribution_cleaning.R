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
oil_113 <- read_csv("data/original/oil_house_candidates_2012_el.csv",
    show_col_types = FALSE
)
oil_114 <- read_csv("data/original/oil_gas_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
oil_115 <- read_csv("data/original/oil_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
oil_116 <- read_csv("data/original/oil_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
oil_117 <- read_csv("data/original/oil_house_candidates_2020_el.csv",
    show_col_types = FALSE
)
# coal mining contributions
coal_113 <- read_csv("data/original/coal_house_candidates_2012_el.csv",
    show_col_types = FALSE
)
coal_114 <- read_csv("data/original/coal_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
coal_115 <- read_csv("data/original/coal_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
coal_116 <- read_csv("data/original/coal_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
coal_117 <- read_csv("data/original/coal_house_candidates_2020_el.csv",
    show_col_types = FALSE
)
# mining
mining_113 <- read_csv("data/original/mining_house_candidates_2012_el.csv",
    show_col_types = FALSE
)
mining_114 <- read_csv("data/original/mining_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
mining_115 <- read_csv("data/original/mining_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
mining_116 <- read_csv("data/original/mining_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
mining_117 <- read_csv("data/original/mining_house_candidates_2020_el.csv",
    show_col_types = FALSE
)
# gas pipelines
gas_113 <- read_csv("data/original/gas_house_candidates_2012_el.csv",
    show_col_types = FALSE
)
gas_114 <- read_csv("data/original/gas_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
gas_115 <- read_csv("data/original/gas_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
gas_116 <- read_csv("data/original/gas_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
gas_117 <- read_csv("data/original/gas_house_candidates_2020_el.csv",
    show_col_types = FALSE
)
# environmentally friendly financial contributions
# alternative energy production
alternative_en_113 <- read_csv("data/original/alt_en_house_candidates_2012_el.csv",
    show_col_types = FALSE
)
alternative_en_114 <- read_csv("data/original/alt_en_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
alternative_en_115 <- read_csv("data/original/alt_en_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
alternative_en_116 <- read_csv("data/original/alt_en_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
alternative_en_117 <- read_csv("data/original/alt_en_house_candidates_2020_el.csv",
    show_col_types = FALSE
)
# environmental contributions
env_113 <- read_csv("data/original/env_house_candidates_2012_el.csv",
    show_col_types = FALSE
)
env_114 <- read_csv("data/original/env_house_candidates_2014_el.csv",
    show_col_types = FALSE
)
env_115 <- read_csv("data/original/env_house_candidates_2016_el.csv",
    show_col_types = FALSE
)
env_116 <- read_csv("data/original/env_house_candidates_2018_el.csv",
    show_col_types = FALSE
)
env_117 <- read_csv("data/original/env_house_candidates_2020_el.csv",
    show_col_types = FALSE
)

# CLEAN DATA
# 114th Congress
# DIRTY
# oil & gas contributions
# view(oil_114)
oil_113 <- contribution_clean(oil_113)
oil_114 <- contribution_clean(oil_114)
oil_115 <- contribution_clean(oil_115)
oil_116 <- contribution_clean(oil_116)
oil_117 <- contribution_clean(oil_117)
# coal mining contributions
coal_113 <- contribution_clean(coal_113)
coal_114 <- contribution_clean(coal_114)
coal_115 <- contribution_clean(coal_115)
coal_116 <- contribution_clean(coal_116)
coal_117 <- contribution_clean(coal_117)

# mining
mining_113 <- contribution_clean(mining_113)
mining_114 <- contribution_clean(mining_114)
mining_115 <- contribution_clean(mining_115)
mining_116 <- contribution_clean(mining_116)
mining_117 <- contribution_clean(mining_117)

# gas pipelines
gas_113 <- contribution_clean(gas_113)
gas_114 <- contribution_clean(gas_114)
gas_115 <- contribution_clean(gas_115)
gas_116 <- contribution_clean(gas_116)
gas_117 <- contribution_clean(gas_117)

# CLEAN
# environmental contributions
env_113 <- contribution_clean(env_113)
env_114 <- contribution_clean(env_114)
env_115 <- contribution_clean(env_115)
env_116 <- contribution_clean(env_116)
env_117 <- contribution_clean(env_117)
# alternative energy sources
alternative_en_113 <- contribution_clean(alternative_en_113)
alternative_en_114 <- contribution_clean(alternative_en_114)
alternative_en_115 <- contribution_clean(alternative_en_115)
alternative_en_116 <- contribution_clean(alternative_en_116)
alternative_en_117 <- contribution_clean(alternative_en_117)


# add suffix to columns "Amount", "Party", "StateAbbreviation" based on the dataset
columns_to_suffix <- c("Amount", "Party", "StateAbbreviation")
oil_113 <- add_suffix(oil_113, ".oil.113", columns_to_suffix)
oil_114 <- add_suffix(oil_114, ".oil.114", columns_to_suffix)
oil_115 <- add_suffix(oil_115, ".oil.115", columns_to_suffix)
oil_116 <- add_suffix(oil_116, ".oil.116", columns_to_suffix)
oil_117 <- add_suffix(oil_117, ".oil.117", columns_to_suffix)

coal_113 <- add_suffix(coal_113, ".coal.113", columns_to_suffix)
coal_114 <- add_suffix(coal_114, ".coal.114", columns_to_suffix)
coal_115 <- add_suffix(coal_115, ".coal.115", columns_to_suffix)
coal_116 <- add_suffix(coal_116, ".coal.116", columns_to_suffix)
coal_117 <- add_suffix(coal_117, ".coal.117", columns_to_suffix)

mining_113 <- add_suffix(mining_113, ".mining.113", columns_to_suffix)
mining_114 <- add_suffix(mining_114, ".mining.114", columns_to_suffix)
mining_115 <- add_suffix(mining_115, ".mining.115", columns_to_suffix)
mining_116 <- add_suffix(mining_116, ".mining.116", columns_to_suffix)
mining_117 <- add_suffix(mining_117, ".mining.117", columns_to_suffix)

gas_113 <- add_suffix(gas_113, ".gas.113", columns_to_suffix)
gas_114 <- add_suffix(gas_114, ".gas.114", columns_to_suffix)
gas_115 <- add_suffix(gas_115, ".gas.115", columns_to_suffix)
gas_116 <- add_suffix(gas_116, ".gas.116", columns_to_suffix)
gas_117 <- add_suffix(gas_117, ".gas.117", columns_to_suffix)

env_113 <- add_suffix(env_113, ".env.113", columns_to_suffix)
env_114 <- add_suffix(env_114, ".env.114", columns_to_suffix)
env_115 <- add_suffix(env_115, ".env.115", columns_to_suffix)
env_116 <- add_suffix(env_116, ".env.116", columns_to_suffix)
env_117 <- add_suffix(env_117, ".env.117", columns_to_suffix)

alternative_en_113 <- add_suffix(alternative_en_113, ".alt_en.113", columns_to_suffix)
alternative_en_114 <- add_suffix(alternative_en_114, ".alt_en.114", columns_to_suffix)
alternative_en_115 <- add_suffix(alternative_en_115, ".alt_en.115", columns_to_suffix)
alternative_en_116 <- add_suffix(alternative_en_116, ".alt_en.116", columns_to_suffix)
alternative_en_117 <- add_suffix(alternative_en_117, ".alt_en.117", columns_to_suffix)


# Process datasets for each congressional term
master_df_113 <- process_financial_data(
    list(
        oil_113,
        coal_113,
        mining_113,
        gas_113,
        env_113,
        alternative_en_113
    )
)
# view(master_df_113)
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
# view(master_df_114)
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
master_df_117 <- process_financial_data(
    list(
        oil_117,
        coal_117,
        mining_117,
        gas_117,
        env_117,
        alternative_en_117
    )
)
# view(master_df_117)
write.csv(master_df_113, "data/cleaned/contributions/113.csv", row.names = FALSE)
write.csv(master_df_114, "data/cleaned/contributions/114.csv", row.names = FALSE)
write.csv(master_df_115, "data/cleaned/contributions/115.csv", row.names = FALSE)
write.csv(master_df_116, "data/cleaned/contributions/116.csv", row.names = FALSE)
write.csv(master_df_117, "data/cleaned/contributions/117.csv", row.names = FALSE)
