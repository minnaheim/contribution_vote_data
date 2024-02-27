# this doc serves to merge all roll call data and the financial data

# set up
library(tidyverse)

# import rollcall data
roll_call <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_full_rollcall_votes.csv", show_col_types = FALSE)
# import financial data
contributions <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/all_reps_contribution.csv", show_col_types = FALSE)

# remove indices columns
roll_call <- subset(roll_call, select = -...1)

# view(contributions)
# view(roll_call)

# merge datasets
master_dataset <- full_join(contributions, roll_call, by = c("LastName", "FirstName"))
# view(master_dataset)

# change all District(.114) cols into StateAbbreviation(.114) cols, discard 2nd
master_dataset <- master_dataset %>%
    mutate(District.114 = str_extract(District.114, "^([A-Z]+)")) %>%
    mutate(District.115 = str_extract(District.115, "^([A-Z]+)")) %>%
    mutate(District.116 = str_extract(District.116, "^([A-Z]+)"))

master_dataset <- master_dataset %>%
    rename("StateAbbreviation.114" = "District.114") %>%
    rename("StateAbbreviation.115" = "District.115") %>%
    rename("StateAbbreviation.116" = "District.116")

# include if Party,114 not include, add from...
# If Party and StateAbbreviation are missing in oil_candidates_114, use values from coal_candidates_114
# 114
master_dataset$Party.x.114 <- ifelse(is.na(master_dataset$Party.x.114), master_dataset$Party.114, master_dataset$Party.x.114)

master_dataset$StateAbbreviation.x.114 <- ifelse(is.na(master_dataset$StateAbbreviation.x.114), master_dataset$StateAbbreviation.114, master_dataset$StateAbbreviation.x.114)

# Remove redundant columns
master_dataset <- master_dataset %>% select(-Party.114, -StateAbbreviation.114)

# move columns before Amounts
master_dataset <- master_dataset %>%
    relocate(StateAbbreviation.x.114, .after = FirstName) %>%
    relocate(Party.x.114, .after = StateAbbreviation.x.114)

# 115
master_dataset$Party.x.114 <- ifelse(is.na(master_dataset$Party.x.114), master_dataset$Party.115, master_dataset$Party.x.114)

master_dataset$StateAbbreviation.x.114 <- ifelse(is.na(master_dataset$StateAbbreviation.x.114), master_dataset$StateAbbreviation.115, master_dataset$StateAbbreviation.x.114)

# Remove redundant columns
master_dataset <- master_dataset %>% select(-Party.115, -StateAbbreviation.115)

# move columns before Amounts
master_dataset <- master_dataset %>%
    relocate(StateAbbreviation.x.114, .after = FirstName) %>%
    relocate(Party.x.114, .after = StateAbbreviation.x.114)

# 116
master_dataset$Party.x.114 <- ifelse(is.na(master_dataset$Party.x.114), master_dataset$Party.116, master_dataset$Party.x.114)

master_dataset$StateAbbreviation.x.114 <- ifelse(is.na(master_dataset$StateAbbreviation.x.114), master_dataset$StateAbbreviation.116, master_dataset$StateAbbreviation.x.114)

# Remove redundant columns
master_dataset <- master_dataset %>% select(-Party.116, -StateAbbreviation.116)

# move columns before Amounts
master_dataset <- master_dataset %>%
    relocate(StateAbbreviation.x.114, .after = FirstName) %>%
    relocate(Party.x.114, .after = StateAbbreviation.x.114)

# view(master_dataset)

# filter out non-voting members
master_dataset <- master_dataset %>%
    dplyr::filter(StateAbbreviation.x.114 != "GU") %>%
    dplyr::filter(StateAbbreviation.x.114 != "PR") %>%
    dplyr::filter(StateAbbreviation.x.114 != "VI") %>%
    dplyr::filter(StateAbbreviation.x.114 != "American Samoa") %>%
    dplyr::filter(StateAbbreviation.x.114 != "DC") %>%
    dplyr::filter(StateAbbreviation.x.114 != "MP")

# view(master_dataset)

# in some cases, two people are called differently in rollcall and financial contributions, e.g. Jeff and Jeffree, merge into one
view(master_dataset)

merge_representatives <- function(df) {
    grouped <- df %>%
        group_by(StateAbbreviation.x.114, Party.x.114, LastName, FirstLetter = substr(FirstName, 1, 1)) %>%
        mutate(Count = n()) %>%
        dplyr::filter(Count > 1) %>%
        ungroup()

    # Print the rows that need merging
    duplicated <- data.frame(grouped)
    # 295 duplicated
    # view(duplicated)

    # Merge rows
    merged <- grouped %>%
        summarise_at(vars(FirstName, LastName, Party.x.114, StateAbbreviation.x.114, Amount.oil.114, Amount.coal.114, Amount.mining.114, Amount.gas.114, Amount.env.114, Amount.alt_en.114, Amount.oil.115, Amount.coal.115, Amount.mining.115, Amount.gas.115, Amount.env.115, Amount.alt_en.115, Amount.oil.116, Amount.coal.116, Amount.mining.116, Amount.gas.116, Amount.env.116, Amount.alt_en.116, Vote.114, Vote.115, Vote.116, Vote_count), function(x) {
            na_idx <- which(is.na(x))
            if (length(na_idx) > 0) {
                x[na_idx] <- x[which(!is.na(x))][1]
            }
            return(x[1])
        })

    # Print the merged rows
    # print(merged)
    merged_duplicated <- data.frame(merged)
    view(merged_duplicated)

    # Merge the merged rows with the original dataframe
    df_merged <- merge(df, merged, by = c("StateAbbreviation.x.114", "Party.x.114", "LastName", "FirstName"), all.x = TRUE)

    # # Remove duplicated rows with NAs
    # df_merged <- df_merged[!duplicated(df_merged) | complete.cases(df_merged), ]

    # Merge the merged rows with the original dataframe
    df_merged <- merge(df, merged, by = c("StateAbbreviation.x.114", "Party.x.114", "LastName", "FirstName"), all.x = TRUE)

    # Select only the merged rows
    df_merged <- df_merged[complete.cases(df_merged), ]

    view(df_merged)
    return(df_merged)
}

# Example usage
# Assuming df is your dataframe containing representatives and their votes
master_dataset <- merge_representatives(master_dataset)

# view(master_dataset)


# check if dataset is complete, by checking if amount....116 and vote.116 both not NA...
