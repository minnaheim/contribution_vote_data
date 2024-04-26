# this script serves to adjust the dataframes to fit to the requirements of each OLS
library(tidyverse)
library(ggplot2)
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
filter_session_data_2 <- function(df, vote) {
    if (vote == 3) {
        # Select columns based on conditions
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote3", "Contribution_3_minus", "Contribution_3_plus", "state", "BioID", "seniority_113", "birthday",
            "Geographical", "nominate_dim1", "nominate_dim2"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        # excluded_cols <- grep("^(?!Vote*3|amount.*113$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 4) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote4", "Contribution_4_minus", "Contribution_4_plus", "state", "BioID", "seniority_114",
            "birthday", "Geographical", "nominate_dim1", "nominate_dim2"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*4|amount.*114$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 51) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote51", "Contribution_51_minus", "Contribution_51_plus", "state", "BioID", "seniority_115",
            "birthday", "Geographical", "nominate_dim1", "nominate_dim2"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*51|amount.*115$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 52) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote52", "Contribution_52_minus", "Contribution_52_plus", "state", "BioID", "seniority_115",
            "birthday", "Geographical", "nominate_dim1", "nominate_dim2"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*52|amount.*115$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 6) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote6", "Contribution_6_minus", "Contribution_6_plus", "state", "BioID", "seniority_116",
            "birthday", "Geographical", "nominate_dim1", "nominate_dim2"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*6|amount.*116$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 7) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote7", "Contribution_7_minus", "Contribution_7_plus", "state", "BioID", "seniority_117",
            "birthday", "Geographical", "nominate_dim1", "nominate_dim2"
        )
        df <- df[, c(selected_cols)]
        # view(df)
    }


    return(df)
}

# function that filters the data based on the session
filter_all_pre_session_data <- function(df, vote) {
    if (vote == 3) {
        # Select columns based on conditions
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote3", "Contribution_3_minus", "Contribution_3_plus",
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        # excluded_cols <- grep("^(?!Vote*3|amount.*113$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 4) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote4", "Contribution_3_minus", "Contribution_3_plus", "Contribution_4_minus", "Contribution_4_plus"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*4|amount.*114$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 51) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote51", "Contribution_3_minus", "Contribution_3_plus",
            "Contribution_4_minus", "Contribution_4_plus",
            "Contribution_51_minus", "Contribution_51_plus"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*51|amount.*115$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 52) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote52", "Contribution_3_minus", "Contribution_3_plus",
            "Contribution_4_minus", "Contribution_4_plus",
            "Contribution_51_minus", "Contribution_51_plus",
            "Contribution_52_minus", "Contribution_52_plus"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*52|amount.*115$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 6) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote6", "Contribution_3_minus", "Contribution_3_plus",
            "Contribution_4_minus", "Contribution_4_plus",
            "Contribution_51_minus", "Contribution_51_plus",
            "Contribution_52_minus", "Contribution_52_plus",
            "Contribution_6_minus", "Contribution_6_plus"
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*6|amount.*116$)", names(df), value = TRUE, perl = TRUE)
    }
    if (vote == 7) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote7", "Contribution_3_minus", "Contribution_3_plus",
            "Contribution_4_minus", "Contribution_4_plus",
            "Contribution_51_minus", "Contribution_51_plus",
            "Contribution_52_minus", "Contribution_52_plus",
            "Contribution_6_minus", "Contribution_6_plus",
            "Contribution_7_minus", "Contribution_7_plus"
        )
        df <- df[, c(selected_cols)]
        # view(df)
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


# # based on first contribution, find the corresponding contributions
base_amount_plus <- function(row) {
    base_amount_plus <- NA
    base_amount_plus <- mutate(base_amount_plus = str_extract(glue("Contribution_{first_vote}_plus"), "\\d+"))
    return(base_amount_plus)
}
# base_amount_minus <- function(row) {
#     base_amount_minus <- NA
#     base_amount_minus <- mutate(base_amount_minus = str_extract(glue("Contribution_{session}_minus"), "\\d+"))
#     return(base_amount_minus)
# }
