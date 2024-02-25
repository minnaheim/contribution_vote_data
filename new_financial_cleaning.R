# setup
library(tidyverse)
library(ggplot2)

# import datasets
oil_candidates_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/oil_gas_house_candidates_2014_el.csv", show_col_types = FALSE)
# view(oil_candidates_114)

gas_candidates_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/gas_house_candidates_2014_el.csv", show_col_types = FALSE)
# view(gas_candidates_114)

mining_candidates_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/mining_house_candidates_2014_el.csv", show_col_types = FALSE)
# view(mining_candidates_114)

coal_candidates_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/coal_house_candidates_2014_el.csv", show_col_types = FALSE)
# view(coal_candidates_114)

env_candidates_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/env_house_candidates_2014_el.csv", show_col_types = FALSE)
# view(env_candidates_114)

alt_en_candidates_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/alt_en_house_candidates_2014_el.csv", show_col_types = FALSE)
# view(alt_en_candidates_114)

oil_candidates_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/oil_house_candidates_2016_el.csv", show_col_types = FALSE)
# view(oil_candidates_115)

gas_candidates_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/gas_house_candidates_2016_el.csv", show_col_types = FALSE)
# view(gas_candidates_115)

mining_candidates_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/mining_house_candidates_2016_el.csv", show_col_types = FALSE)
# view(mining_candidates_115)

coal_candidates_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/coal_house_candidates_2016_el.csv", show_col_types = FALSE)
# view(coal_candidates_115)

env_candidates_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/env_house_candidates_2016_el.csv", show_col_types = FALSE)
# view(env_candidates_115)

alt_en_candidates_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/alt_en_house_candidates_2018_el.csv", show_col_types = FALSE)
# view(alt_en_candidates_115)

oil_candidates_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/oil_house_candidates_2018_el.csv", show_col_types = FALSE)
# view(oil_candidates_116)

gas_candidates_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/gas_house_candidates_2018_el.csv", show_col_types = FALSE)
# view(gas_candidates_116)

mining_candidates_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/mining_house_candidates_2018_el.csv", show_col_types = FALSE)
# view(mining_candidates_116)

coal_candidates_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/coal_house_candidates_2018_el.csv", show_col_types = FALSE)
# view(coal_candidates_116)

env_candidates_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/env_house_candidates_2018_el.csv", show_col_types = FALSE)
# view(env_candidates_116)

alt_en_candidates_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/alt_en_house_candidates_2018_el.csv", show_col_types = FALSE)
# view(alt_en_candidates_116)


# clean data
# data cleaning pipeline:

contribution_clean <- function(dataset) {
    # remove $ and turn into numeric
    dataset$Amount <- as.numeric(sub("\\$", "", dataset$Amount))

    # separate political affiliation, in () into new column.
    dataset$Party <- gsub(".*\\((.*?)\\).*", "\\1", dataset$Representative)

    dataset$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", dataset$Representative)

    # split the representatives column of contribution _144 into the columns LastName and FirstName.
    dataset <- extract(dataset, Representative, c("LastName", "FirstName"), "([^ ]+) (.*)")

    # split Party and state-abbreviation into separate columns.
    dataset <- separate(dataset, Party, into = c("Party", "StateAbbreviation"), sep = "-")

    # relocate Party and StateAbbreviation columns to after Names
    dataset <- dataset %>% relocate(Party, StateAbbreviation, .after = FirstName)

    return(dataset)
}
# cleaned datasets:

# DIRTY
# oil & gas contributions
oil_candidates_114 <- contribution_clean(oil_candidates_114)
oil_candidates_115 <- contribution_clean(oil_candidates_115)
oil_candidates_116 <- contribution_clean(oil_candidates_116)

# coal mining contributions
coal_candidates_114 <- contribution_clean(coal_candidates_114)
coal_candidates_115 <- contribution_clean(coal_candidates_115)
coal_candidates_116 <- contribution_clean(coal_candidates_116)
# mining
mining_candidates_114 <- contribution_clean(mining_candidates_114)
mining_candidates_115 <- contribution_clean(mining_candidates_115)
mining_candidates_116 <- contribution_clean(mining_candidates_116)
# gas pipelines
gas_candidates_114 <- contribution_clean(gas_candidates_114)
gas_candidates_115 <- contribution_clean(gas_candidates_115)
gas_candidates_116 <- contribution_clean(gas_candidates_116)
# CLEAN
# environmental contributions
env_candidates_114 <- contribution_clean(env_candidates_114)
env_candidates_115 <- contribution_clean(env_candidates_115)
env_candidates_116 <- contribution_clean(env_candidates_116)
# alternative energy sources
alt_en_candidates_114 <- contribution_clean(alt_en_candidates_114)
alt_en_candidates_115 <- contribution_clean(alt_en_candidates_115)
alt_en_candidates_116 <- contribution_clean(alt_en_candidates_116)

# view(alt_en_candidates_116)

#  MERGE ALL DIFFERENT FINANCIAL CONTRIBUTIONS TOGETHER
# 114
master_df_candidates_114 <- full_join(oil_candidates_114, coal_candidates_114[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName"), suffix = c(".oil", ".coal"))

# If Party and StateAbbreviation are missing in oil_candidates_114, use values from coal_candidates_114
master_df_candidates_114$Party <- ifelse(is.na(master_df_candidates_114$Party.oil), master_df_candidates_114$Party.coal, master_df_candidates_114$Party.oil)

master_df_candidates_114$StateAbbreviation <- ifelse(is.na(master_df_candidates_114$StateAbbreviation.oil), master_df_candidates_114$StateAbbreviation.coal, master_df_candidates_114$StateAbbreviation.oil)

# Remove redundant columns
master_df_candidates_114 <- master_df_candidates_114[, !(names(master_df_candidates_114) %in% c("Party.oil", "Party.coal", "StateAbbreviation.oil", "StateAbbreviation.coal"))]

# move columns before Amounts
master_df_candidates_114 <- master_df_candidates_114 %>%
    relocate(StateAbbreviation, .after = FirstName) %>%
    relocate(Party, .after = StateAbbreviation)

# view(master_df_candidates_114)
# works until here

master_df_candidates_114 <- full_join(master_df_candidates_114, mining_candidates_114[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.mining" = "Amount") %>%
    rename("Party.mining" = "Party.y") %>%
    rename("StateAbbreviation.mining" = "StateAbbreviation.y")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_114$Party.x <- ifelse(is.na(master_df_candidates_114$Party.x), master_df_candidates_114$Party.mining, master_df_candidates_114$Party.x)

master_df_candidates_114$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_114$StateAbbreviation.x), master_df_candidates_114$StateAbbreviation.mining, master_df_candidates_114$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_114 <- master_df_candidates_114[, !(names(master_df_candidates_114) %in% c("Party.mining", "StateAbbreviation.mining"))]

# Move columns before Amounts
master_df_candidates_114 <- master_df_candidates_114 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_114)

master_df_candidates_114 <- full_join(master_df_candidates_114, gas_candidates_114[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.gas" = "Amount") %>%
    rename("Party.gas" = "Party") %>%
    rename("StateAbbreviation.gas" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_114$Party.x <- ifelse(is.na(master_df_candidates_114$Party.x), master_df_candidates_114$Party.gas, master_df_candidates_114$Party.x)

master_df_candidates_114$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_114$StateAbbreviation.x), master_df_candidates_114$StateAbbreviation.gas, master_df_candidates_114$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_114 <- master_df_candidates_114[, !(names(master_df_candidates_114) %in% c("Party.gas", "StateAbbreviation.gas"))]

# Move columns before Amounts
master_df_candidates_114 <- master_df_candidates_114 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_114)

master_df_candidates_114 <- full_join(master_df_candidates_114, env_candidates_114[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.env" = "Amount") %>%
    rename("Party.env" = "Party") %>%
    rename("StateAbbreviation.env" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_114$Party.x <- ifelse(is.na(master_df_candidates_114$Party.x), master_df_candidates_114$Party.env, master_df_candidates_114$Party.x)

master_df_candidates_114$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_114$StateAbbreviation.x), master_df_candidates_114$StateAbbreviation.env, master_df_candidates_114$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_114 <- master_df_candidates_114[, !(names(master_df_candidates_114) %in% c("Party.env", "StateAbbreviation.env"))]

# Move columns before Amounts
master_df_candidates_114 <- master_df_candidates_114 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_114)

master_df_candidates_114 <- full_join(master_df_candidates_114, alt_en_candidates_114[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.alt_en" = "Amount") %>%
    rename("Party.alt_en" = "Party") %>%
    rename("StateAbbreviation.alt_en" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_114$Party.x <- ifelse(is.na(master_df_candidates_114$Party.x), master_df_candidates_114$Party.alt_en, master_df_candidates_114$Party.x)

master_df_candidates_114$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_114$StateAbbreviation.x), master_df_candidates_114$StateAbbreviation.alt_en, master_df_candidates_114$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_114 <- master_df_candidates_114[, !(names(master_df_candidates_114) %in% c("Party.alt_en", "StateAbbreviation.alt_en"))]

# Move columns before Amounts
master_df_candidates_114 <- master_df_candidates_114 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_114)
# works until here

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(master_df_candidates_114), value = TRUE)
master_df_candidates_114[amount_cols][is.na(master_df_candidates_114[amount_cols])] <- 0
# view(master_df_candidates_114)
# THIS IS THE FINAL FINANCIAL CONTRIBUTION DATASET FOR THE 114TH CONGRESSIONAL TERM

# KEEP ONLY THE REPS AND THEIR CONTRIBUTIONS IF == REP_114
# import & clean rep_114
rep_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_representatives_114.csv", show_col_types = FALSE)
# view(rep_114)

# MERGE DATA
all_reps_contributions <- left_join(rep_114[, c("LastName", "FirstName")], master_df_candidates_114, by = c("LastName", "FirstName"), suffix = c(".rep", ".fin"))

# remove the state column
all_reps_contributions_114 <- all_reps_contributions %>% select(-State)

# when doing a left join, there are still some house representative that are in rep_114 but not in any contribution data. those have = 0 contributions. change so that at least state and party info is given

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(all_reps_contributions_114), value = TRUE)
all_reps_contributions_114[amount_cols][is.na(all_reps_contributions_114[amount_cols])] <- 0

# view(all_reps_contributions_114)

# create a function that goes through each row of the dataset, and if the columns StateAbbreviation.x and Party.x are NA, then fill in the values from the rep_114 dataset
fill_in_missing_values <- function(dataset) {
    for (i in 1:nrow(dataset)) {
        if (is.na(dataset$StateAbbreviation.x[i])) {
            dataset$StateAbbreviation.x[i] <- rep_114$State[rep_114$LastName == dataset$LastName[i] & rep_114$FirstName == dataset$FirstName[i]]
        }
        if (is.na(dataset$Party.x[i])) {
            dataset$Party.x[i] <- rep_114$Party[rep_114$LastName == dataset$LastName[i] & rep_114$FirstName == dataset$FirstName[i]]
        }
    }
    return(dataset)
}

all_reps_contributions_114 <- fill_in_missing_values(all_reps_contributions_114)
# view(all_reps_contributions_114)

# now we just need to turn the entries into abbreviations

for (i in 1:nrow(all_reps_contributions_114)) {
    if (all_reps_contributions_114$Party.x[i] == "Democrat") {
        all_reps_contributions_114$Party.x[i] <- "D"
    }
    if (all_reps_contributions_114$Party.x[i] == "Republican") {
        all_reps_contributions_114$Party.x[i] <- "R"
    }
}

# now we want to look at the State Abbreviations column and match with state abbreviations
# view(all_reps_contributions_114)
state_abbreviations <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/state_abbreviations.csv", show_col_types = FALSE)
# view(state_abbreviations)

# now we want to look at the State Abbreviations column and match with state abbreviations, if the char length is > 2

for (i in 1:nrow(all_reps_contributions_114)) {
    if (nchar(all_reps_contributions_114$StateAbbreviation.x[i]) > 2) {
        state <- all_reps_contributions_114$StateAbbreviation.x[i]
        matching_postal <- state_abbreviations$Postal[state_abbreviations$State == state]
        if (length(matching_postal) > 0) {
            all_reps_contributions_114$StateAbbreviation.x[i] <- matching_postal[1]
        }
    }
}
# view(all_reps_contributions_114)

# repeat the whole financial cleaning process with the 115th congress
#  MERGE ALL DIFFERENT FINANCIAL CONTRIBUTIONS TOGETHER
# 115
master_df_candidates_115 <- full_join(oil_candidates_115, coal_candidates_115[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName"), suffix = c(".oil", ".coal"))

# If Party and StateAbbreviation are missing in oil_candidates_115, use values from coal_candidates_115
master_df_candidates_115$Party <- ifelse(is.na(master_df_candidates_115$Party.oil), master_df_candidates_115$Party.coal, master_df_candidates_115$Party.oil)

master_df_candidates_115$StateAbbreviation <- ifelse(is.na(master_df_candidates_115$StateAbbreviation.oil), master_df_candidates_115$StateAbbreviation.coal, master_df_candidates_115$StateAbbreviation.oil)

# Remove redundant columns
master_df_candidates_115 <- master_df_candidates_115[, !(names(master_df_candidates_115) %in% c("Party.oil", "Party.coal", "StateAbbreviation.oil", "StateAbbreviation.coal"))]

# move columns before Amounts
master_df_candidates_115 <- master_df_candidates_115 %>%
    relocate(StateAbbreviation, .after = FirstName) %>%
    relocate(Party, .after = StateAbbreviation)

# view(master_df_candidates_115)

master_df_candidates_115 <- full_join(master_df_candidates_115, mining_candidates_115[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.mining" = "Amount") %>%
    rename("Party.mining" = "Party.y") %>%
    rename("StateAbbreviation.mining" = "StateAbbreviation.y")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_115$Party.x <- ifelse(is.na(master_df_candidates_115$Party.x), master_df_candidates_115$Party.mining, master_df_candidates_115$Party.x)

master_df_candidates_115$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_115$StateAbbreviation.x), master_df_candidates_115$StateAbbreviation.mining, master_df_candidates_115$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_115 <- master_df_candidates_115[, !(names(master_df_candidates_115) %in% c("Party.mining", "StateAbbreviation.mining"))]

# Move columns before Amounts
master_df_candidates_115 <- master_df_candidates_115 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_115)

master_df_candidates_115 <- full_join(master_df_candidates_115, gas_candidates_115[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.gas" = "Amount") %>%
    rename("Party.gas" = "Party") %>%
    rename("StateAbbreviation.gas" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_115$Party.x <- ifelse(is.na(master_df_candidates_115$Party.x), master_df_candidates_115$Party.gas, master_df_candidates_115$Party.x)

master_df_candidates_115$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_115$StateAbbreviation.x), master_df_candidates_115$StateAbbreviation.gas, master_df_candidates_115$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_115 <- master_df_candidates_115[, !(names(master_df_candidates_115) %in% c("Party.gas", "StateAbbreviation.gas"))]

# Move columns before Amounts
master_df_candidates_115 <- master_df_candidates_115 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_115)

master_df_candidates_115 <- full_join(master_df_candidates_115, env_candidates_115[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.env" = "Amount") %>%
    rename("Party.env" = "Party") %>%
    rename("StateAbbreviation.env" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_115$Party.x <- ifelse(is.na(master_df_candidates_115$Party.x), master_df_candidates_115$Party.env, master_df_candidates_115$Party.x)

master_df_candidates_115$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_115$StateAbbreviation.x), master_df_candidates_115$StateAbbreviation.env, master_df_candidates_115$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_115 <- master_df_candidates_115[, !(names(master_df_candidates_115) %in% c("Party.env", "StateAbbreviation.env"))]

# Move columns before Amounts
master_df_candidates_115 <- master_df_candidates_115 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_115)

master_df_candidates_115 <- full_join(master_df_candidates_115, alt_en_candidates_115[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.alt_en" = "Amount") %>%
    rename("Party.alt_en" = "Party") %>%
    rename("StateAbbreviation.alt_en" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_115$Party.x <- ifelse(is.na(master_df_candidates_115$Party.x), master_df_candidates_115$Party.alt_en, master_df_candidates_115$Party.x)

master_df_candidates_115$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_115$StateAbbreviation.x), master_df_candidates_115$StateAbbreviation.alt_en, master_df_candidates_115$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_115 <- master_df_candidates_115[, !(names(master_df_candidates_115) %in% c("Party.alt_en", "StateAbbreviation.alt_en"))]

# Move columns before Amounts
master_df_candidates_115 <- master_df_candidates_115 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_115)
# works until here

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(master_df_candidates_115), value = TRUE)
master_df_candidates_115[amount_cols][is.na(master_df_candidates_115[amount_cols])] <- 0

# view(master_df_candidates_115)
# THIS IS THE FINAL FINANCIAL CONTRIBUTION DATASET FOR THE 115TH CONGRESSIONAL TERM

# KEEP ONLY THE REPS AND THEIR CONTRIBUTIONS IF == REP_115
# import & clean rep_115
rep_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_representatives_115.csv", show_col_types = FALSE)
# view(rep_115)

# MERGE DATA
all_reps_contributions_115 <- left_join(rep_115[, c("LastName", "FirstName")], master_df_candidates_115, by = c("LastName", "FirstName"), suffix = c(".rep", ".fin"))

# remove the state column
all_reps_contributions_115 <- all_reps_contributions_115 %>% select(-State)

# when doing a left join, there are still some house representative that are in rep_115 but not in any contribution data. those have = 0 contributions.

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(all_reps_contributions_115), value = TRUE)
all_reps_contributions_115[amount_cols][is.na(all_reps_contributions_115[amount_cols])] <- 0
# view(all_reps_contributions_115)

# create a function that goes through each row of the dataset, and if the columns StateAbbreviation.x and Party.x are NA, then fill in the values from the rep_114 dataset
fill_in_missing_values <- function(dataset) {
    for (i in 1:nrow(dataset)) {
        if (is.na(dataset$StateAbbreviation.x[i])) {
            dataset$StateAbbreviation.x[i] <- rep_115$State[rep_115$LastName == dataset$LastName[i] & rep_115$FirstName == dataset$FirstName[i]]
        }
        if (is.na(dataset$Party.x[i])) {
            dataset$Party.x[i] <- rep_115$Party[rep_115$LastName == dataset$LastName[i] & rep_115$FirstName == dataset$FirstName[i]]
        }
    }
    return(dataset)
}

all_reps_contributions_115 <- fill_in_missing_values(all_reps_contributions_115)

# now we just need to turn the entries into abbreviations

for (i in 1:nrow(all_reps_contributions_115)) {
    if (all_reps_contributions_115$Party.x[i] == "Democrat") {
        all_reps_contributions_115$Party.x[i] <- "D"
    }
    if (all_reps_contributions_115$Party.x[i] == "Republican") {
        all_reps_contributions_115$Party.x[i] <- "R"
    }
}

# now we want to look at the State Abbreviations column and match with state abbreviations
state_abbreviations <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/state_abbreviations.csv", show_col_types = FALSE)
# view(state_abbreviations)

# now we want to look at the State Abbreviations column and match with state abbreviations, if the char length is > 2

for (i in 1:nrow(all_reps_contributions_115)) {
    if (nchar(all_reps_contributions_115$StateAbbreviation.x[i]) > 2) {
        state <- all_reps_contributions_115$StateAbbreviation.x[i]
        matching_postal <- state_abbreviations$Postal[state_abbreviations$State == state]
        if (length(matching_postal) > 0) {
            all_reps_contributions_115$StateAbbreviation.x[i] <- matching_postal[1]
        }
    }
}
# view(all_reps_contributions_115)

# repeat the whole financial cleaning process with the 116th congress
# MERGE ALL DIFFERENT FINANCIAL CONTRIBUTIONS TOGETHER
# 116
master_df_candidates_116 <- full_join(oil_candidates_116, coal_candidates_116[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName"), suffix = c(".oil", ".coal"))

# If Party and StateAbbreviation are missing in oil_candidates_116, use values from coal_candidates_116
master_df_candidates_116$Party <- ifelse(is.na(master_df_candidates_116$Party.oil), master_df_candidates_116$Party.coal, master_df_candidates_116$Party.oil)

master_df_candidates_116$StateAbbreviation <- ifelse(is.na(master_df_candidates_116$StateAbbreviation.oil), master_df_candidates_116$StateAbbreviation.coal, master_df_candidates_116$StateAbbreviation.oil)

# Remove redundant columns
master_df_candidates_116 <- master_df_candidates_116[, !(names(master_df_candidates_116) %in% c("Party.oil", "Party.coal", "StateAbbreviation.oil", "StateAbbreviation.coal"))]

# move columns before Amounts
master_df_candidates_116 <- master_df_candidates_116 %>%
    relocate(StateAbbreviation, .after = FirstName) %>%
    relocate(Party, .after = StateAbbreviation)

# view(master_df_candidates_116)

master_df_candidates_116 <- full_join(master_df_candidates_116, mining_candidates_116[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.mining" = "Amount") %>%
    rename("Party.mining" = "Party.y") %>%
    rename("StateAbbreviation.mining" = "StateAbbreviation.y")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_116$Party.x <- ifelse(is.na(master_df_candidates_116$Party.x), master_df_candidates_116$Party.mining, master_df_candidates_116$Party.x)

master_df_candidates_116$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_116$StateAbbreviation.x), master_df_candidates_116$StateAbbreviation.mining, master_df_candidates_116$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_116 <- master_df_candidates_116[, !(names(master_df_candidates_116) %in% c("Party.mining", "StateAbbreviation.mining"))]

# Move columns before Amounts
master_df_candidates_116 <- master_df_candidates_116 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_116)

master_df_candidates_116 <- full_join(master_df_candidates_116, gas_candidates_116[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.gas" = "Amount") %>%
    rename("Party.gas" = "Party") %>%
    rename("StateAbbreviation.gas" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_116$Party.x <- ifelse(is.na(master_df_candidates_116$Party.x), master_df_candidates_116$Party.gas, master_df_candidates_116$Party.x)

master_df_candidates_116$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_116$StateAbbreviation.x), master_df_candidates_116$StateAbbreviation.gas, master_df_candidates_116$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_116 <- master_df_candidates_116[, !(names(master_df_candidates_116) %in% c("Party.gas", "StateAbbreviation.gas"))]

# Move columns before Amounts
master_df_candidates_116 <- master_df_candidates_116 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_116)

master_df_candidates_116 <- full_join(master_df_candidates_116, env_candidates_116[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.env" = "Amount") %>%
    rename("Party.env" = "Party") %>%
    rename("StateAbbreviation.env" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_116$Party.x <- ifelse(is.na(master_df_candidates_116$Party.x), master_df_candidates_116$Party.env, master_df_candidates_116$Party.x)

master_df_candidates_116$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_116$StateAbbreviation.x), master_df_candidates_116$StateAbbreviation.env, master_df_candidates_116$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_116 <- master_df_candidates_116[, !(names(master_df_candidates_116) %in% c("Party.env", "StateAbbreviation.env"))]

# Move columns before Amounts
master_df_candidates_116 <- master_df_candidates_116 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_116)

master_df_candidates_116 <- full_join(master_df_candidates_116, alt_en_candidates_116[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.alt_en" = "Amount") %>%
    rename("Party.alt_en" = "Party") %>%
    rename("StateAbbreviation.alt_en" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_candidates_116$Party.x <- ifelse(is.na(master_df_candidates_116$Party.x), master_df_candidates_116$Party.alt_en, master_df_candidates_116$Party.x)

master_df_candidates_116$StateAbbreviation.x <- ifelse(is.na(master_df_candidates_116$StateAbbreviation.x), master_df_candidates_116$StateAbbreviation.alt_en, master_df_candidates_116$StateAbbreviation.x)

# Remove redundant columns
master_df_candidates_116 <- master_df_candidates_116[, !(names(master_df_candidates_116) %in% c("Party.alt_en", "StateAbbreviation.alt_en"))]

# Move columns before Amounts
master_df_candidates_116 <- master_df_candidates_116 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_candidates_116)
# works until here

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(master_df_candidates_116), value = TRUE)
master_df_candidates_116[amount_cols][is.na(master_df_candidates_116[amount_cols])] <- 0

# view(master_df_candidates_116)
# THIS IS THE FINAL FINANCIAL CONTRIBUTION DATASET FOR THE 115TH CONGRESSIONAL TERM

# KEEP ONLY THE REPS AND THEIR CONTRIBUTIONS IF == REP_116
# import & clean rep_116
rep_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_representatives_116.csv", show_col_types = FALSE)
# view(rep_116) -> 433 members (435 members?)
# view(rep_115) -> 437 members
# view(rep_114) -> 437 members

# MERGE DATA -> keep only candidates that won seats.
all_reps_contributions_116 <- left_join(rep_116[, c("LastName", "FirstName")], master_df_candidates_116, by = c("LastName", "FirstName"), suffix = c(".rep", ".fin"))

# remove the state column
all_reps_contributions_116 <- all_reps_contributions_116 %>% select(-State)
# view(all_reps_contributions_116)

# when doing a left join, there are still some house representative that are in rep_115 but not in any contribution data. those have = 0 contributions.

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(all_reps_contributions_116), value = TRUE)
all_reps_contributions_116[amount_cols][is.na(all_reps_contributions_116[amount_cols])] <- 0

# create a function that goes through each row of the dataset, and if the columns StateAbbreviation.x and Party.x are NA, then fill in the values from the rep_114 dataset
fill_in_missing_values <- function(dataset) {
    for (i in 1:nrow(dataset)) {
        if (is.na(dataset$StateAbbreviation.x[i])) {
            dataset$StateAbbreviation.x[i] <- rep_116$State[rep_116$LastName == dataset$LastName[i] & rep_116$FirstName == dataset$FirstName[i]]
        }
        if (is.na(dataset$Party.x[i])) {
            dataset$Party.x[i] <- rep_116$Party[rep_116$LastName == dataset$LastName[i] & rep_116$FirstName == dataset$FirstName[i]]
        }
    }
    return(dataset)
}

all_reps_contributions_116 <- fill_in_missing_values(all_reps_contributions_116)
# view(all_reps_contributions_116)

# now we just need to turn the entries into abbreviations

for (i in 1:nrow(all_reps_contributions_116)) {
    if (all_reps_contributions_116$Party.x[i] == "Democrat") {
        all_reps_contributions_116$Party.x[i] <- "D"
    }
    if (all_reps_contributions_116$Party.x[i] == "Republican") {
        all_reps_contributions_116$Party.x[i] <- "R"
    }
}

# now we want to look at the State Abbreviations column and match with state abbreviations
state_abbreviations <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/state_abbreviations.csv", show_col_types = FALSE)
# view(state_abbreviations)

# now we want to look at the State Abbreviations column and match with state abbreviations, if the char length is > 2

for (i in 1:nrow(all_reps_contributions_116)) {
    if (nchar(all_reps_contributions_116$StateAbbreviation.x[i]) > 2) {
        state <- all_reps_contributions_116$StateAbbreviation.x[i]
        matching_postal <- state_abbreviations$Postal[state_abbreviations$State == state]
        if (length(matching_postal) > 0) {
            all_reps_contributions_116$StateAbbreviation.x[i] <- matching_postal[1]
        }
    }
}

# merge datasets into one .114, .115, .116, etc.

all_reps_contributions <- full_join(all_reps_contributions_114, all_reps_contributions_115[, c("LastName", "FirstName", "Party.x", "StateAbbreviation.x", "Amount.oil", "Amount.coal", "Amount.mining", "Amount.gas", "Amount.env", "Amount.alt_en")], by = c("LastName", "FirstName"), suffix = c(".114", ".115"))


# Update Party and StateAbbreviation columns if missing
all_reps_contributions$Party.x.114 <- ifelse(is.na(all_reps_contributions$Party.x.114), all_reps_contributions$Party.x.115, all_reps_contributions$Party.x.114)


all_reps_contributions$StateAbbreviation.x.114 <- ifelse(is.na(all_reps_contributions$StateAbbreviation.x.114), all_reps_contributions$StateAbbreviation.x.115, all_reps_contributions$StateAbbreviation.x.114)


# Remove redundant columns
all_reps_contributions <- all_reps_contributions[, !(names(all_reps_contributions) %in% c("Party.x.115", "StateAbbreviation.x.115"))]

# Move columns before Amounts
all_reps_contributions <- all_reps_contributions %>%
    relocate(StateAbbreviation.x.114, .after = FirstName) %>%
    relocate(Party.x.114, .after = StateAbbreviation.x.114)


# works until here
# view(all_reps_contributions)

# merge all_reps (114,115) with 116.

all_reps_contributions <- full_join(all_reps_contributions, all_reps_contributions_116[, c("LastName", "FirstName", "Party.x", "StateAbbreviation.x", "Amount.oil", "Amount.coal", "Amount.mining", "Amount.gas", "Amount.env", "Amount.alt_en")], by = c("LastName", "FirstName")) %>%
    rename("Amount.oil.116" = "Amount.oil") %>%
    rename("Amount.coal.116" = "Amount.coal") %>%
    rename("Amount.mining.116" = "Amount.mining") %>%
    rename("Amount.gas.116" = "Amount.gas") %>%
    rename("Amount.env.116" = "Amount.env") %>%
    rename("Amount.alt_en.116" = "Amount.alt_en") %>%
    rename("Party.x.116" = "Party.x") %>%
    rename("StateAbbreviation.x.116" = "StateAbbreviation.x")

# view(all_reps_contributions)

# Update Party and StateAbbreviation columns if missing
all_reps_contributions$Party.x.114 <- ifelse(is.na(all_reps_contributions$Party.x.114), all_reps_contributions$Party.x.116, all_reps_contributions$Party.x.114)

all_reps_contributions$StateAbbreviation.x.114 <- ifelse(is.na(all_reps_contributions$StateAbbreviation.x.114), all_reps_contributions$StateAbbreviation.x.116, all_reps_contributions$StateAbbreviation.x.114)

# Remove redundant columns
all_reps_contributions <- all_reps_contributions[, !(names(all_reps_contributions) %in% c("Party.x.116", "StateAbbreviation.x.116"))]

# Move columns before Amounts
all_reps_contributions <- all_reps_contributions %>%
    relocate(StateAbbreviation.x.114, .after = FirstName) %>%
    relocate(Party.x.114, .after = StateAbbreviation.x.114)

# view(all_reps_contributions)
# final version

# write csv, clean reps
write_csv(all_reps_contributions, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/all_reps_contribution.csv")
write_csv(all_reps_contributions_114, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/all_reps_contribution_114.csv")
write_csv(all_reps_contributions_115, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/all_reps_contribution_115.csv")
write_csv(all_reps_contributions_116, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/all_reps_contribution_116.csv")
