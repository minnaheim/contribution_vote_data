# this script serves to adjust the dataframes to fit to the requirements of each OLS
library(tidyverse)
library(ggplot2)
library(glue)
library(fastDummies)
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

# function that filters the data based on the session, add 1151, 1152 for these two sessions
filter_session_data <- function(df, session) {
    if (session == 113) {
        # Select columns based on conditions
        selected_cols <- c(
            "party", "anti_env.113", "pro_env.113", "Geographical",
            "Vote3", grep("^amount.*113$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        df <- df %>% filter(!is.na(Vote3))
        df <- dummy_cols(df, select_columns = "Vote3")
        df <- df %>%
            rename("Vote3_plus" = "Vote3_+") %>%
            rename("Vote3_minus" = "Vote3_-")
    }
    if (session == 114) {
        selected_cols <- c(
            "party", "anti_env.114", "pro_env.114", "Geographical",
            "Vote4", grep("^amount.*114$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        df <- df %>% filter(!is.na(Vote4))
        df <- dummy_cols(df, select_columns = "Vote4")
        df <- df %>%
            rename("Vote4_plus" = "Vote4_+") %>%
            rename("Vote4_minus" = "Vote4_-")
    }
    if (session == 1151) {
        selected_cols <- c(
            "party", "anti_env.115", "pro_env.115", "Geographical",
            "Vote51", grep("^amount.*115$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]

        df <- df %>% filter(!is.na(Vote51))
        df <- dummy_cols(df, select_columns = "Vote51")
        df <- df %>%
            rename("Vote51_plus" = "Vote51_+") %>%
            rename("Vote51_minus" = "Vote51_-")
    }
    if (session == 1152) {
        selected_cols <- c(
            "party", "anti_env.115", "pro_env.115", "Geographical",
            "Vote52", grep("^amount.*115$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        df <- df %>% filter(!is.na(Vote52))
        df <- dummy_cols(df, select_columns = "Vote52")
        df <- df %>%
            rename("Vote52_plus" = "Vote52_+") %>%
            rename("Vote52_minus" = "Vote52_-")
    }
    if (session == 116) {
        selected_cols <- c(
            "party", "anti_env.116", "pro_env.116", "Geographical",
            "Vote6", grep("^amount.*116$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        df <- df %>% filter(!is.na(Vote6))
        df <- dummy_cols(df, select_columns = "Vote6")
        df <- df %>%
            rename("Vote6_plus" = "Vote6_+") %>%
            rename("Vote6_minus" = "Vote6_-")
    }
    if (session == 117) {
        selected_cols <- c(
            "party", "anti_env.117", "pro_env.117", "Geographical",
            "Vote7", grep("^amount.*117$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        df <- df %>% filter(!is.na(Vote7))
        df <- dummy_cols(df, select_columns = "Vote7")
        df <- df %>%
            rename("Vote7_plus" = "Vote7_+") %>%
            rename("Vote7_minus" = "Vote7_-")
    }
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
                if (current_vote == "+" && next_vote == "-") {
                    changes <- c(changes, "0")
                }
                if (current_vote == "-" && next_vote == "+") {
                    changes <- c(changes, "1")
                }
            }
        }
    }
    paste(changes, collapse = ",")
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


vote_columns <- c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")
session_columns <- c("113", "114", "115", "115", "116", "117")

first_contribution <- function(row) {
    first_contribution <- NA
    # Iterate over the vote columns
    for (i in 1:length(vote_columns)) {
        # Check if the vote is not NA
        if (!is.na(row[vote_columns[i]])) {
            # Save the session as the base contribution
            first_contribution <- session_columns[i]
            # Break the loop
            break
        }
    }
    # Return the base contribution
    return(first_contribution)
}
