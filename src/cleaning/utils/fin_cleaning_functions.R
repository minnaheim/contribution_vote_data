library(tidyverse)

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
    dataset <- extract(dataset, "Representative", c("LastName", "FirstName"), "([^ ]+) (.*)")

    # split Party and state-abbreviation into separate columns.
    dataset <- separate(dataset, "Party", into = c("Party", "StateAbbreviation"), sep = "-")

    # relocate Party and StateAbbreviation columns to after Names
    dataset <- dataset %>% relocate("Party", "StateAbbreviation", .after = "FirstName")

    return(dataset)
}


# combine all columns that start with column_name into one column
# if values are different, seperate by ","
# if values are the same or NA, keep the value
# remove the other columns
combine_columns <- function(dataset, column_name) {
    cols <- grep(paste0("^", column_name), names(dataset), value = TRUE)
    dataset[[column_name]] <- apply(
        dataset[cols],
        1,
        function(x) {
            x <- x[!is.na(x)]
            if (length(unique(x)) > 1) {
                paste(x, collapse = ",")
            } else {
                x[1]
            }
        }
    )


    # remove column_name from cols if exists
    cols <- cols[!cols %in% column_name]

    # remove other columns
    dataset <- dataset %>%
        select(-one_of(cols))

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
            by = c("LastName", "FirstName")
        )
    }

    # drop all columns except LastName.*, FirstName.*, Amount.*, Party.*, StateAbbreviation.*
    master_df <- master_df %>%
        select(
            matches("LastName"),
            matches("FirstName"),
            matches("Amount"),
            matches("Party"),
            matches("StateAbbreviation")
        )


    # Handle missing Party and StateAbbreviation, remove redundant cols
    master_df <- combine_columns(master_df, "Party")
    master_df <- combine_columns(master_df, "StateAbbreviation")

    # Turn "invalid number" or NA into 0
    amount_cols <- grep("^Amount", names(master_df), value = TRUE)
    master_df[amount_cols][is.na(master_df[amount_cols])] <- 0

    return(master_df)
}

# function that merges the contribution datasets for the seperate terms together, into a master financaial dataset

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

    return(master_df)
}
