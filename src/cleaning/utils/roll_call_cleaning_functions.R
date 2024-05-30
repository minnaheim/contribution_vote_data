source("src/cleaning/utils/rep_cleaning_functions.R")
library(tidyverse)
library(fedmatch)

# this is a cleaning function for the pre-cleaned representative data,
# where we only need to remove a second index column, and change the state names
# into state abbreviations
# remove_index <- function(dataset) {
#     dataset <- subset(dataset, select = -...1)
# }


merge_roll_calls <- function(suffixes, datasets) {
    if (missing(suffixes) || length(datasets) == 0) {
        stop("Suffixes or datasets missing for merging.")
    }

    # Full join all datasets
    merged_data <- Reduce(function(x, y) full_join(x, y, by = "Representative", suffix = suffixes), datasets)

    # Split Representative column
    merged_data <- separate(merged_data, "Representative", c("last_name", "first_name"), sep = ", ")

    # combine cols
    merged_data <- combine_columns(merged_data, "Party")
    merged_data <- combine_columns(merged_data, "District")

    # # Create State column
    merged_data$State <- substr(merged_data$District, 1, 2)
    merged_data <- relocate(merged_data, District, .after = State)

    return(merged_data)
}

final_merge_roll_call <- function(datasets) {
    if (length(datasets) == 0) {
        stop("Suffixes or datasets missing for merging.")
    }

    # Full join all datasets
    merged_data <- Reduce(function(x, y) full_join(x, y, by = c("last_name", "first_name")), datasets)
    # merged_data <- datasets %>% Reduce(full_join, by = c("LastName", "FirstName"))

    # view(merged_data)

    # combine cols
    merged_data <- combine_columns(merged_data, "State")
    merged_data <- combine_columns(merged_data, "Party")
    merged_data <- combine_columns(merged_data, "District")

    # # Create State column
    merged_data$State <- substr(merged_data$District, 1, 2)
    merged_data <- relocate(merged_data, District, .after = State)

    return(merged_data)
}

# created a new column which counts votes (only - or + counts) and not n/a, ? or E
count_votes <- function(dataset) {
    vote_cols <- dataset %>% select(starts_with("Vote"))
    # view(vote_cols)
    dataset["Vote_count"] <- 0
    for (i in 1:nrow(vote_cols)) {
        count <- 0
        for (j in 1:ncol(vote_cols)) {
            if (is.na(vote_cols[i, j])) {
                count <- count + 0
            } else if (!is.na(vote_cols[i, j]) && vote_cols[i, j] == "+" || vote_cols[i, j] == "-") {
                count <- count + 1
            }
            dataset[i, ]["Vote_count"] <- count
        }
    }
    return(dataset)
}

# function that marks ? and n/a as NA
mark_na <- function(dataset) {
    # vote_cols <- dataset %>% select(starts_with("Vote"))
    # for (i in 1:nrow(vote_cols)) {
    #     mutate(glue([i] = ifelse([i] == "?" | [i] == "n/a", NA, [i]))
    #     mutate(Vote3 = ifelse(Vote3 == "?" | Vote3 == "n/a", NA, Vote3))
    # }
    dataset <- dataset %>%
        mutate(
            Vote3 = ifelse(Vote3 == "?" | Vote3 == "n/a", NA, Vote3),
            Vote4 = ifelse(Vote4 == "?" | Vote4 == "n/a", NA, Vote4),
            Vote51 = ifelse(Vote51 == "?" | Vote51 == "n/a", NA, Vote51),
            Vote52 = ifelse(Vote52 == "?" | Vote52 == "n/a", NA, Vote52),
            Vote6 = ifelse(Vote6 == "?" | Vote6 == "n/a", NA, Vote6),
            Vote7 = ifelse(Vote7 == "?" | Vote7 == "n/a", NA, Vote7)
        )
    return(dataset)
}


# count_vote_changes <- function(dataset) {
#     dataset$Vote_change <- NA

#     for (i in 1:nrow(dataset)) {
#         row <- dataset[i, ]
#         dataset[i, "Vote_change"] <- 0
#         if (row$Vote_count == 6) {
#             if (row$Vote3 != row$Vote4) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#             if (row$Vote4 != row$Vote51) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#             if (row$Vote51 != row$Vote52) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#             if (row$Vote52 != row$Vote6) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#             if (row$Vote6 != row$Vote7) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#         } else if (row$Vote_count == 5 || row$Vote_count == 4 || row$Vote_count == 3 || row$Vote_count == 2) {
#             if (!is.na(row$Vote3) && !is.na(row$Vote4) && row$Vote3 != row$Vote4) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#             if (!is.na(row$Vote4) && !is.na(row$Vote51) && row$Vote4 != row$Vote51) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#             if (!is.na(row$Vote51) && !is.na(row$Vote52) && row$Vote51 != row$Vote52) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#             if (!is.na(row$Vote52) && !is.na(row$Vote6) && row$Vote52 != row$Vote6) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#             if (!is.na(row$Vote6) && !is.na(row$Vote7) && row$Vote6 != row$Vote7) {
#                 dataset[i, "Vote_change"] <- ifelse(is.na(dataset[i, "Vote_change"]), 1, dataset[i, "Vote_change"] + 1)
#             }
#         } else { # vote_count == 1
#             dataset[i, "Vote_change"] <- 0
#         }
#     }
#     return(dataset)
# }


# try with seq_along()

# count_vote_changes <- function(dataset) {
#     dataset$Vote_change <- 0
#     vote_cols <- dataset %>% select(matches(("Vote[0-9]")))
#     for (i in row(vote_cols)) {
#         for (j in seq(vote_cols)) {
#             mutate(Vote_change, match([j-1], [j]) <= seq_along([j-1]), 1) # not 1 to vote change but + 1...
#         }
#     }
#     dataset$Vote_change <- vote_cols$Vote_change
#     return(vote_cols)
# }
