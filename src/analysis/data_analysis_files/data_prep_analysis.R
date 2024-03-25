# this script serves to adjust the dataframes to fit to the requirements of each OLS
library(tidyverse)
library(ggplot2)

df <- read.csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned/final_df.csv")

# df <- select(-c(X))
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
# view(df)

write.csv(df, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned/analysis_df.csv", row.names = FALSE)

# merge together each category of variables
df_sum <- df %>%
    rowwise() %>%
    mutate(oil_sum = sum(amount.oil.113, amount.oil.114, amount.oil.115, amount.oil.116, amount.oil.117, na.rm = TRUE)) %>%
    mutate(coal_sum = sum(amount.coal.113, amount.coal.114, amount.coal.115, amount.coal.116, amount.coal.117, na.rm = TRUE)) %>%
    mutate(gas_sum = sum(amount.gas.113, amount.gas.114, amount.gas.115, amount.gas.116, amount.gas.117, na.rm = TRUE)) %>%
    mutate(mining_sum = sum(amount.mining.113, amount.mining.114, amount.mining.115, amount.mining.116, amount.mining.117, na.rm = TRUE)) %>%
    mutate(env_sum = sum(amount.env.113, amount.env.114, amount.env.115, amount.env.116, amount.env.117, na.rm = TRUE)) %>%
    mutate(alt_en_sum = sum(amount.alt_en.113, amount.alt_en.114, amount.alt_en.115, amount.alt_en.116, amount.alt_en.117, na.rm = TRUE))

df_sum <- subset(df_sum, select = -c(
    amount.oil.113, amount.oil.114, amount.oil.115, amount.oil.116, amount.oil.117,
    amount.coal.113, amount.coal.114, amount.coal.115, amount.coal.116, amount.coal.117,
    amount.gas.113, amount.gas.114, amount.gas.115, amount.gas.116, amount.gas.117,
    amount.mining.113, amount.mining.114, amount.mining.115, amount.mining.116, amount.mining.117,
    amount.env.113, amount.env.114, amount.env.115, amount.env.116, amount.env.117,
    amount.alt_en.113, amount.alt_en.114, amount.alt_en.115, amount.alt_en.116, amount.alt_en.117
))
# view(df_sum)

write.csv(df_sum, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned/analysis_df_sum.csv", row.names = FALSE)

# function that filters the data based on the session, add 1151, 1152 for these two sessions
filter_session_data <- function(df, session) {
    if (session == 113) {
        # Select columns based on conditions
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote3", grep("^amount.*113$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        # excluded_cols <- grep("^(?!Vote*3|amount.*113$)", names(df), value = TRUE, perl = TRUE)
    }
    if (session == 114) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote4", grep("^amount.*114$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*4|amount.*114$)", names(df), value = TRUE, perl = TRUE)
    }
    if (session == 1151) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote51", grep("^amount.*115$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*51|amount.*115$)", names(df), value = TRUE, perl = TRUE)
    }
    if (session == 1152) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote52", grep("^amount.*115$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*52|amount.*115$)", names(df), value = TRUE, perl = TRUE)
    }
    if (session == 116) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote6", grep("^amount.*116$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        # excluded_cols <- grep("^(?!Vote*6|amount.*116$)", names(df), value = TRUE, perl = TRUE)
    }
    if (session == 117) {
        selected_cols <- c(
            "party", "Vote_change_dummy",
            "Vote7", grep("^amount.*117$", names(df), value = TRUE)
        )
        df <- df[, c(selected_cols)]
        view(df)
    }
    return(df)
}


## for subsample OLS - identify how people changed their minds
df_subsample <- df %>% dplyr::filter(Vote_change_dummy == 1)

# vote_analysis <- function(df) {
#     for (i in 1:nrow(df)) {
#         df["Vote_change_type"] <- NA
#         df <- dplyr::relocate(df, Vote_change_type, .after = Vote_change_dummy)
#         for (vote_col in c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")) {
#             vote <- df[[vote_col]][i]
#             next_vote <- df[[vote_col]][i]
#             if (!is.na(vote)) {
#                 if (vote == "-" && next_vote == "+") {
#                     df["Vote_change_type"][i] <- 1
#                 }
#                 if (vote == "+" && next_vote == "-") {
#                     df["Vote_change_type"][i] <- 0
#                 }
#                 break
#             }
#         }
#         return(df)
#     }
# }


# Define a function to detect vote changes and assign types
detect_vote_changes <- function(votes) {
    # Initialize the previous vote variable and the result list
    prev_vote <- votes[1]
    result <- c()

    # Loop through the votes starting from the second one
    for (i in 2:length(votes)) {
        if (prev_vote == "+" && votes[i] == "-") {
            result <- c(result, "0") # Change from + to -
        } else if (prev_vote == "-" && votes[i] == "+") {
            result <- c(result, "1") # Change from - to +
        }
        # Update the previous vote for the next iteration
        prev_vote <- votes[i]
    }

    # Combine the results into a single string, separated by commas
    return(paste(result, collapse = ","))
}

# Apply the function to each row
df <- df %>%
    rowwise() %>%
    mutate(vote_change_type = detect_vote_changes(c_across(starts_with("vote")))) %>%
    ungroup()

### FINISH THIS FUNCTION


df_subsample <- vote_analysis(df_subsample)
view(df_subsample)
write.csv(df_subsample, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned/df_subsample.csv")

# for (i in 1:nrow(df_subsample)) {
#     if (df$Vote_change > 1) {
#         # determine which vote was first, etc.
#     } else {
#     }
# }
