# this script serves to adjust the dataframes to fit to the requirements of each OLS
library(tidyverse)
library(ggplot2)
library(glue)
library(fastDummies)
library(glue)

# DF FOR ANALYSIS
analysis_prep <- function(df) {
    # parties only incl. R, D, no I
    df <- df %>% dplyr::filter(party %in% c("D", "R"))

    # only include if vote_count > 1
    df <- df %>% dplyr::filter(Vote_count > 1)

    # vote change = 1 if > 0, and 0 if 0.
    df["Vote_change_dummy"] <- NA

    for (i in 1:nrow(df)) {
        if (df$Vote_change[i] > 0) {
            df$Vote_change_dummy[i] <- 1
        } else {
            df$Vote_change_dummy[i] <- 0
        }
    }
    df <- relocate(df, "Vote_change_dummy", .after = "Vote_change")
}

# change all votes in vote columns to be 0 for - and 1 for +
dummy_vote <- function(df) {
    for (vote in vote_columns) {
        df[vote] <- ifelse(df[vote] == "+", 1, 0)
    }
    return(df)
}

# function which checks for each row in df if the contribution_minus column > 0 then set anti_env_dummy to 1,
# if contribution_plus > 0 then set pro_env_dummy to 1 in dplyr
add_contrib_dummy <- function(df) {
    df$anti_env_dummy <- rep(0, nrow(df))
    df$pro_env_dummy <- rep(0, nrow(df))

    for (i in 1:nrow(df)) {
        # Check Contribution_minus condition
        if (!is.na(df$Contribution_minus[i]) && df$Contribution_minus[i] > 0) {
            # print(df$Contribution_minus[i])
            df$anti_env_dummy[i] <- 1
        }
        # Check Contribution_plus condition
        if (!is.na(df$Contribution_plus[i]) && df$Contribution_plus[i] > 0) {
            # print(df$Contribution_plus[i])
            df$pro_env_dummy[i] <- 1
        }
    }
    return(df)
}


add_contrib_dummy_per_session <- function(df, current_vote) {
    df$anti_env_dummy <- rep(0, nrow(df))
    df$pro_env_dummy <- rep(0, nrow(df))

    for (i in 1:nrow(df)) {
        # Construct column names dynamically
        minus_col_name <- glue("Contribution_{current_vote}_minus")
        plus_col_name <- glue("Contribution_{current_vote}_plus")

        # Check Contribution_minus condition
        if (!is.na(df[[minus_col_name]][i]) && df[[minus_col_name]][i] > 0) {
            df$anti_env_dummy[i] <- 1
        }
        # Check Contribution_plus condition
        if (!is.na(df[[plus_col_name]][i]) && df[[plus_col_name]][i] > 0) {
            df$pro_env_dummy[i] <- 1
        }
    }
    return(df)
}


# DF WHERE CONTRIBUTION COLUMNS ARE MUTATED TOGETHER (summarised)
summarise_contributions <- function(df) {
    df_sum <- df %>%
        rowwise() %>%
        mutate(
            oil_sum = sum(amount.oil.113, amount.oil.114, amount.oil.115, amount.oil.116, amount.oil.117, na.rm = TRUE),
            coal_sum = sum(amount.coal.113, amount.coal.114, amount.coal.115, amount.coal.116, amount.coal.117, na.rm = TRUE),
            gas_sum = sum(amount.gas.113, amount.gas.114, amount.gas.115, amount.gas.116, amount.gas.117, na.rm = TRUE),
            mining_sum = sum(amount.mining.113, amount.mining.114, amount.mining.115, amount.mining.116, amount.mining.117, na.rm = TRUE),
            env_sum = sum(amount.env.113, amount.env.114, amount.env.115, amount.env.116, amount.env.117, na.rm = TRUE),
            alt_en_sum = sum(amount.alt_en.113, amount.alt_en.114, amount.alt_en.115, amount.alt_en.116, amount.alt_en.117, na.rm = TRUE)
        )

    df_sum <- subset(df_sum, select = -c(
        amount.oil.113, amount.oil.114, amount.oil.115, amount.oil.116, amount.oil.117,
        amount.coal.113, amount.coal.114, amount.coal.115, amount.coal.116, amount.coal.117,
        amount.gas.113, amount.gas.114, amount.gas.115, amount.gas.116, amount.gas.117,
        amount.mining.113, amount.mining.114, amount.mining.115, amount.mining.116, amount.mining.117,
        amount.env.113, amount.env.114, amount.env.115, amount.env.116, amount.env.117,
        amount.alt_en.113, amount.alt_en.114, amount.alt_en.115, amount.alt_en.116, amount.alt_en.117
    ))

    return(df_sum)
}

# function that filters the data based on the session
filter_all_pre_session_data <- function(df, vote) {
    all_votes <- c(3, 4, 51, 52, 6, 7)
    for (i in all_votes) {
        # include not only current vote but that of all votes before
        votes_before <- all_votes[1:(which(all_votes == i))]
        contribution_cols <- c()
        for (v in votes_before) {
            contribution_cols <- c(
                contribution_cols,
                glue("Contribution_{v}_minus"),
                glue("Contribution_{v}_plus")
            )
        }
    }
    # select relevant columns
    selected_cols <- c(
        "party", "Vote_change_dummy",
        glue("Vote{vote}"),
        contribution_cols,
        "state", "BioID", glue("seniority_11{vote}"), "birthday",
        "Geographical", "nominate_dim1", "nominate_dim2", "gender", "pro_env_dummy", "anti_env_dummy", "district"
    )
    df <- df[, c(selected_cols)]
    df <- df %>% filter(!is.na(glue("Vote{vote}")))
    df <- dummy_cols(df, select_columns = glue("Vote{vote}"))
    df <- df %>% rename_with(~ glue("Vote{vote}_plus"), .cols = glue("Vote{vote}_1"))
    df <- df %>% rename_with(~ glue("Vote{vote}_minus"), .cols = glue("Vote{vote}_0"))
    return(df)
}

process_session_data <- function(df, vote) {
    df <- add_contrib_dummy_per_session(df, vote)
    df <- filter_all_pre_session_data(df, vote)
    return(df)
}
# DF for SUBSAMPLE ANALYSIS
vote_columns <- c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")

# Function to detect changes and create the vote_change_type string
detect_changes <- function(row) {
    changes <- c()
    for (i in 1:(length(vote_columns) - 1)) {
        if (!is.na(vote_columns[i])) { # take non NA values
            current_vote <- row[vote_columns[i]]
            next_vote <- row[vote_columns[i + 1]]
            if (!is.na(current_vote != next_vote)) {
                if (current_vote == "1" && next_vote == "0") {
                    changes <- c(changes, "0")
                }
                if (current_vote == "0" && next_vote == "1") {
                    changes <- c(changes, "1")
                }
            }
        }
    }
    paste(changes, collapse = ",")
}

# FIXED EFFECTS DF
vote_y_columns <- c("2013", "2016", "2017", "2018", "2019", "2021")
session_columns <- c("113", "114", "115", "115", "116", "117")

# Adjusted function to detect the years of changes
detect_year_of_changes <- function(row) {
    year_change <- character(0)
    for (i in 1:(length(vote_columns) - 1)) {
        current_vote <- row[vote_columns[i]]
        next_vote <- row[vote_columns[i + 1]]
        # Check if there's a change and it's not NA
        if (!is.na(current_vote) && !is.na(next_vote) && current_vote != next_vote) {
            # Record the years of change
            # c(vote_y_columns[i], vote_y_columns[i + 1])/
            year_info <- glue("{vote_y_columns[i]}-{vote_y_columns[i + 1]}")
            year_change <- c(year_change, year_info)
        }
    }
    # Concatenate all year changes for the row
    paste(year_change, collapse = ", ")
}

# aggregate function that creates vote_change_type and vote_change_year columns using the 2 above functions
create_vote_change_dataframe <- function(df) {
    df <- df %>%
        mutate(vote_change_type = apply(.[, vote_columns], 1, detect_changes)) %>%
        relocate(vote_change_type, .after = Vote_change) %>%
        mutate(vote_change_year = apply(.[, vote_columns], 1, detect_year_of_changes)) %>%
        relocate(vote_change_year, .after = vote_change_type) %>%
        mutate(
            first_vote = apply(.[, vote_columns], 1, base_year), # base_year function needs to be defined
            first_contribution_minus = apply(., 1, first_contribution_minus), # function needs to be defined
            first_contribution_plus = apply(., 1, first_contribution_plus) # function needs to be defined
        ) %>%
        separate_rows(vote_change_type, vote_change_year, sep = ",") %>%
        mutate(
            vote_change_type = trimws(vote_change_type),
            vote_change_year = trimws(vote_change_year)
        )

    return(df)
}


# pivot longer function
pivot_longer_function <- function(df) {
    df <- df %>%
        separate(vote_change_type, paste0("change", c(1:4)), sep = ",")

    df <- pivot_longer(df, c(change1, change2, change3, change4),
        names_to = "votes", values_to = "change", values_drop_na = TRUE
    ) %>%
        relocate(change, .after = name) %>%
        relocate(votes, .after = change)

    return(df)
}


aggregate_pivot_longer_function <- function(df) {
    # create copy of seniority_115 to pivot easier
    df$seniority_115_2 <- df$seniority_115

    # Perform renaming operations to align with the desired naming convention
    # dry!!! - redo this part
    df <- df %>%
        rename(
            seniority_3 = "seniority_113",
            seniority_4 = "seniority_114",
            seniority_51 = "seniority_115",
            seniority_52 = "seniority_115_2",
            seniority_6 = "seniority_116",
            seniority_7 = "seniority_117",
            Contribution_minus_3 = "Contribution_3_minus",
            Contribution_plus_3 = "Contribution_3_plus",
            Contribution_minus_4 = "Contribution_4_minus",
            Contribution_plus_4 = "Contribution_4_plus",
            Contribution_minus_51 = "Contribution_51_minus",
            Contribution_plus_51 = "Contribution_51_plus",
            Contribution_minus_52 = "Contribution_52_minus",
            Contribution_plus_52 = "Contribution_52_plus",
            Contribution_minus_6 = "Contribution_6_minus",
            Contribution_plus_6 = "Contribution_6_plus",
            Contribution_minus_7 = "Contribution_7_minus",
            Contribution_plus_7 = "Contribution_7_plus"
        )

    # Define columns to keep as identifiers
    id_vars <- c(
        "BioID", "GovtrackID", "opensecrets_id", "first_name", "last_name", "state",
        "district", "party", "name", "birthday", "gender", "Geographical", "nominate_dim1", "nominate_dim2",
        "Vote_change_dummy", "Vote_change"
        # ,"vote_change_to_pro", "vote_change_to_anti"
        # "pro_env_dummy", "anti_env_dummy"
    )

    # Perform a single pivot_longer operation to reshape the data
    df <- df %>%
        pivot_longer(
            cols = -all_of(id_vars), # Exclude identifier columns from pivoting
            names_to = c(".value", "Instance"), # .value keeps the metric name, Instance extracts the number
            names_pattern = "(.*?)(?:_)?(\\d+)$" # Separates the metric name and instance number
        ) %>%
        filter(!is.na(Instance))

    return(df)
}

vote_columns <- c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")
session_columns <- c("3", "4", "51", "52", "6", "7")
contribution_columns <- c(
    "Contribution_3_minus", "Contribution_3_plus",
    "Contribution_4_minus", "Contribution_4_plus",
    "Contribution_51_minus", "Contribution_51_plus",
    "Contribution_52_minus", "Contribution_52_plus",
    "Contribution_6_minus", "Contribution_6_plus",
    "Contribution_7_minus", "Contribution_7_minus"
)

base_year <- function(row) {
    first_year <- NA
    # Iterate over the vote columns
    for (i in 1:length(vote_columns)) {
        # Check if the vote is not NA
        if (!is.na(row[vote_columns[i]])) {
            # Save the session as the base contribution
            first_year <- session_columns[i]
            # Break the loop
            break
        }
    }
    # Return the base contribution
    return(first_year)
}

# create a function that for each row, runs through the contributions columns,
# and copies the first non NA column into first_contributions_plus and first_contributions_minus
first_contribution_minus <- function(row) {
    for (i in contribution_columns) {
        if (!is.na(row[i])) {
            return(row[i])
        }
    }
    return(NA)
}

first_contribution_plus <- function(row) {
    found <- FALSE
    for (col in contribution_columns) {
        if (found) {
            return(row[col])
        }
        if (!is.na(row[col])) {
            found <- TRUE
        }
    }
    return(NA)
}
