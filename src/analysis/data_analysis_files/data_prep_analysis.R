# this script serves to adjust the dataframes to fit to the requirements of each OLS
library(tidyverse)
library(ggplot2)

df <- read.csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned/final_df.csv")

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

# remove irrelevant cols for analysis
# df <- df %>% select(-c(last_name, first_name, name, member_id, District, state))
df_full <- subset(df, select = -c(
    last_name, first_name, member_id, name, Vote_count, District,
    Vote3, Vote4, Vote51, Vote52, Vote6, Vote7, Vote_change, state
))
# view(df_full)

# create a function where the inputs are the df and the session to observe, and then dep. on the session,
# the function removes the irrelevant columns, i.e. if input is 113, then remove all amount columns
# that don't end in 113, and only keep the Vote column which ends in 3.

# function that checks the last char of each column name in a df
# substrRight <- function(x, n) {
#     substr(x, nchar(x) - n + 1, nchar(x))
# }
# session needs to be 3 characters, i.e. 113, and for 115, specify which session, either 1151 or 1152
# session_df <- function(dataset, session) {

#     vote_columns <- c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")
#     amount_columns <- c(
#         "amount.oil.113",
#         "amount.coal.113",
#         "amount.mining.113",
#         "amount.gas.113",
#         "amount.env.113",
#         "amount.alt_en.113",
#         "amount.coal.114",
#         "amount.oil.114",
#         "amount.mining.114",
#         "amount.gas.114",
#         "amount.env.114",
#         "amount.alt_en.114",
#         "amount.coal.115",
#         "amount.oil.115",
#         "amount.mining.115",
#         "amount.gas.115",
#         "amount.env.115",
#         "amount.alt_en.115",
#         "amount.coal.116",
#         "amount.oil.116",
#         "amount.mining.116",
#         "amount.gas.116",
#         "amount.env.116",
#         "amount.alt_en.116",
#         "amount.coal.117",
#         "amount.oil.117",
#         "amount.mining.117",
#         "amount.gas.117",
#         "amount.env.117",
#         "amount.alt_en.117"
#     )
#     exclude_columns <- vote_columns[substr(vote_columns, nchar("Vote") + 2, nchar(vote_columns)) == session]
#     view(exclude_columns)
#     exclude_columns <- c(exclude_columns, amount_columns[substr(amount_columns, nchar("amount") + 1, nchar(amount_columns)) != session])
#     # dataset <- dataset %>% select(-exclude_columns)
#     # dataset <- dataset %>% select(-exclude_columns)
#     return(dataset)
# }
# session_df(df, "113")


filter_session_data <- function(df, session) {
    if (session == 113) {
        # Select columns based on conditions
        selected_cols <- c("Vote3", grep("^amount.*113$", names(df), value = TRUE))
        excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        # Subset dataframe, add only selected cols, not excluded cols, those need to be removed
        df <- df[, !(names(df) %in% excluded_cols)]
    }
    if (session == 114) {
        selected_cols <- c("Vote4", grep("^amount.*114$", names(df), value = TRUE))
        excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        df <- df[, c(selected_cols, excluded_cols)]
    }
    if (session == 1151) {
        selected_cols <- c("Vote51", grep("^amount.*115$", names(df), value = TRUE))
        excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        df <- df[, c(selected_cols, excluded_cols)]
    }
    if (session == 1152) {
        selected_cols <- c("Vote52", grep("^amount.*115$", names(df), value = TRUE))
        excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        df <- df[, c(selected_cols, excluded_cols)]
    }
    if (session == 116) {
        selected_cols <- c("Vote6", grep("^amount.*116$", names(df), value = TRUE))
        excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        df <- df[, c(selected_cols, excluded_cols)]
    }
    if (session == 117) {
        selected_cols <- c("Vote7", grep("^amount.*117$", names(df), value = TRUE))
        excluded_cols <- grep("^vote|^amount", names(df), value = TRUE, invert = TRUE)
        df <- df[, c(selected_cols, excluded_cols)]
    }
    return(df)
}
