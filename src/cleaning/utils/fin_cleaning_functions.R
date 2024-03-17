library(tidyverse)
library(fuzzyjoin)

source("src/cleaning/utils/roll_call_cleaning_functions.R")
source("src/cleaning/utils/combine_columns.R")

# add suffix to columns in a dataset (rename columns)
add_suffix <- function(dataset, suffix, columns) {
    for (col in columns) {
        colnames(dataset)[colnames(dataset) == col] <- paste0(col, suffix)
    }
    return(dataset)
}

contribution_clean <- function(dataset) {
    # remove NA rows

    # remove $ and turn into numeric
    dataset$Amount <- as.numeric(sub("\\$", "", dataset$Amount))

    # separate political affiliation, in () into new column.
    dataset$Party <- gsub(".*\\((.*?)\\).*", "\\1", dataset$Representative)

    dataset$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", dataset$Representative)

    # split the representatives column of contribution _114 into the columns LastName and FirstName.
    dataset <- tidyr::extract(dataset, "Representative", c("last_name", "first_name"), "([^ ]+) (.*)")

    # split Party and state-abbreviation into separate columns.
    dataset <- tidyr::separate(dataset, "Party", into = c("party", "state_abbreviation"), sep = "-")

    # relocate Party and StateAbbreviation columns to after Names
    dataset <- dataset %>% relocate("party", "state_abbreviation", .after = "first_name")

    # make all columns lowercase
    dataset <- dataset %>%
        rename_with(tolower)

    return(dataset)
}


# Functions to process financial contribution datasets for a given term
# each dataset should have following columns LastName, FirstName, Amount, Party, StateAbbreviation
process_financial_data <- function(datasets) {
    # Create master dataframe
    master_df <- datasets[[1]]

    # Iterate over each contribution dataset except the first one using name of the dataset as suffix for the second df
    for (i in 2:length(datasets)) {
        master_df <- full_join(
            master_df,
            datasets[[i]],
            by = c("last_name", "first_name")
        )
    }

    # drop all columns except LastName.*, FirstName.*, Amount.*, Party.*, StateAbbreviation.*
    master_df <- master_df %>%
        select(
            matches("last_name"),
            matches("first_name"),
            matches("amount"),
            matches("party"),
            matches("state_abbreviation")
        )


    # Handle missing Party and StateAbbreviation, remove redundant cols
    master_df <- combine_columns(master_df, "party")
    master_df <- combine_columns(master_df, "state_abbreviation")

    # rename state_abbreviation to state
    master_df <- master_df %>%
        rename("state" = "state_abbreviation")

    # Turn "invalid number" or NA into 0
    amount_cols <- grep("^amount", names(master_df), value = TRUE)
    master_df[amount_cols][is.na(master_df[amount_cols])] <- 0

    return(master_df)
}

# function that merges the contribution datasets for the separate terms together, into a master financial dataset
term_merge <- function(datasets) {
    # Create master dataframe
    master_df <- datasets[[1]]

    # Iterate over each contribution dataset except the first one using name of the dataset as suffix for the second df
    for (i in 2:length(datasets)) {
        master_df <- full_join(
            master_df,
            datasets[[i]],
            by = c("LastName", "FirstName")
        )
    }
    # Handle missing Party and StateAbbreviation, remove redundant cols
    master_df <- combine_columns(master_df, "Party")
    master_df <- combine_columns(master_df, "StateAbbreviation")

    # relocate party and state cols
    master_df <- master_df %>% relocate("Party", "StateAbbreviation", .after = "FirstName")

    return(master_df)
}

# function that merges the contribution datasets for the separate terms together,
# into a master financial dataset, if State not StateAbbreviation
term_merge_2 <- function(datasets) {
    # Create master dataframe
    master_df <- datasets[[1]]

    # Iterate over each contribution dataset except the first one using name of the dataset as suffix for the second df
    for (i in 2:length(datasets)) {
        master_df <- full_join(
            master_df,
            datasets[[i]],
            by = c("LastName", "FirstName", "Party", "State")
        )
    }
    # Handle missing Party and StateAbbreviation, remove redundant cols
    master_df <- combine_columns(master_df, "Party")
    master_df <- combine_columns(master_df, "State")

    # relocate party and state cols
    master_df <- master_df %>% relocate("Party", "State", .after = "FirstName")

    return(master_df)
}


# function that merges the contribution datasets for the separate terms together,
# into a master financial dataset, if State not StateAbbreviation
term_merge_id <- function(datasets) {
    # Create master dataframe
    master_df <- datasets[[1]]

    # Iterate over each contribution dataset except the first one using name of the dataset as suffix for the second df
    for (i in 2:length(datasets)) {
        master_df <- full_join(
            master_df,
            datasets[[i]],
            by = c("member_id", "LastName", "FirstName", "Party", "State")
        )
    }
    # Handle missing Party and StateAbbreviation, remove redundant cols
    master_df <- combine_columns(master_df, "Party")
    master_df <- combine_columns(master_df, "State")
    master_df <- combine_columns(master_df, "Alias")

    # relocate party and state cols
    master_df <- master_df %>% relocate("Party", "State", "member_id", .after = "FirstName")

    # remove Alias col
    master_df <- select(master_df, -Alias)

    return(master_df)
}

# remove non-voting members (state = State)
remove_non_voting <- function(dataset) {
    dataset <- dataset %>%
        dplyr::filter(State != "GU") %>%
        dplyr::filter(State != "PR") %>%
        dplyr::filter(State != "VI") %>%
        dplyr::filter(State != "American Samoa") %>%
        dplyr::filter(State != "DC") %>%
        dplyr::filter(State != "MP")
    return(dataset)
}

# view(master_df)
# cleaning function for unique id of representatives


clean_id_reps <- function(dataset) {
    # remove index column, rename Member ID to member_id
    dataset <- subset(dataset, select = -...1)
    dataset <- dataset %>%
        rename(member_id = `Member ID`)

    # use add_state_abbrev function from rollcall data to change state names into state abbreviations
    dataset <- add_state_abbrev(dataset)

    # now turn party into abbreviations
    dataset <- party_abbreviation(dataset)

    return(dataset)
}

# if LastName.x, FirstName.x, State.x, Party.x are not equal to LastName.y,
# FirstName.y, State.y, Party.y, then remove these columns for row i.

non_matches <- function(dataset) {
    count <- 0
    df <- data.frame()
    for (i in 1:nrow(dataset)) {
        row <- dataset[i, ]
        for (i in 1:nrow(row)) {
            if (!is.na(row$LastName.x) && !is.na(row$LastName.y) && !is.na(row$FirstName.x) && !is.na(row$FirstName.y)) {
                if (row$LastName.x != row$LastName.y && row$FirstName.x != row$FirstName.y) {
                    count <- count + 1
                    df <- rbind(df, row[i])
                }
            }
        }
    }
    return(df)
}
# view(nr_non_matched)


# current dataset is correct, but need to remove duplicated rows and duplicated rows
remove_duplicated <- function(dataset) {
    for (i in 1:nrow(dataset)) {
        row <- dataset[i, ]
        next_row <- dataset[i + 1, ]
        if (!is.na(row$LastName.x) && !is.na(row$LastName.y) &&
            !is.na(row$FirstName.x) && !is.na(row$FirstName.y) &&
            !is.na(next_row$LastName.x) && !is.na(next_row$LastName.y) &&
            !is.na(next_row$FirstName.x) && !is.na(next_row$FirstName.y)) {
            if (row$LastName.x == next_row$LastName.x && row$FirstName.x == next_row$FirstName.x &&
                row$State.x == next_row$State.x && row$Party.x == next_row$Party.x) {
                dataset <- dataset[-i, ]
            }
        }
    }
    return(dataset)
}


# remove all .y cols
remove_y_cols <- function(dataset) {
    dataset <- select(dataset, -c(contains(".y")))
    dataset <- dataset %>%
        rename("LastName" = "LastName.x") %>%
        rename("FirstName" = "FirstName.x") %>%
        rename("Party" = "Party.x") %>%
        rename("State" = "State.x")
    return(dataset)
}
