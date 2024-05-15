# setup
source("src/cleaning/utils/combine_columns.R")
# install.packages("fedmatch")
library(fedmatch)
library(glue)

# clean names, by removing all special symbols and making all names lowercase, cols need to be "last_name", and "first"
clean_names <- function(dataset) {
    dataset$last_name <- clean_strings(dataset$last_name)
    dataset$first_name <- clean_strings(dataset$first_name)
    # clean_names <- lapply(dataset[last_name], clean_strings)
    # dataset[last_name] <- clean_names
    # clean_names <- lapply(dataset[first_name], clean_strings)
    # dataset[first_name] <- clean_names
    return(dataset)
}


rep_cleaning <- function(dataset) {
    trimws(dataset)
    colnames(dataset) <- c("last_name", "first_name", "state", "party", "chamber", "district")
    dataset <- dataset %>% dplyr::filter(chamber != "Senate")
    # dataset <- clean_names(dataset)
    return(dataset)
}

# fuzzy join based on Names, Party and States
# create function that returns True or False, if distance between two strings is less than 3
fuzzy_match <- function(x, y, max_dist = 2) {
    return(stringdist::stringdist(x, y) <= max_dist)
}

fuzzy_match_last <- function(x, y) {
    return(fuzzy_match(x, y, 1))
}
fuzzy_match_first <- function(x, y) {
    return(fuzzy_match(x, y, 2)) # in roll_call = 3
}

# fuzzy merge function that merges each input dataset with the rep_u_id dataset,
# join_by must be this: c("last_name", "first_name", "party", "state")
fuzzy_join_representative_id <- function(dataset) {
    # import id_reps
    id_reps <- read_csv("data/cleaned/unique_id_reps.csv", show_col_types = FALSE)
    dataset["name"] <- paste(dataset$first_name, dataset$last_name)
    id_reps["name"] <- paste(id_reps$first_name, id_reps$last_name)
    dataset["name"] <- lapply(dataset["name"], clean_strings)
    id_reps["name"] <- lapply(id_reps["name"], clean_strings)
    # view(id_reps)
    # view(dataset)
    dataset <- fuzzy_left_join(
        dataset,
        id_reps,
        by = c("name", "party", "state"),
        match_fun = list(fuzzy_match, `==`, `==`)
    )
    # combine columns
    dataset <- combine_columns(dataset, "first_name", FALSE)
    dataset <- combine_columns(dataset, "last_name", FALSE)
    dataset <- combine_columns(dataset, "party")
    dataset <- combine_columns(dataset, "state")
    dataset <- combine_columns(dataset, "name.x", FALSE)
    dataset <- combine_columns(dataset, "name.y", FALSE)
    # relocate cols
    dataset <- relocate(dataset, "first_name")
    dataset <- relocate(dataset, "last_name", "party", "state", "member_id", .after = "first_name")

    return(dataset)
}
# find all name matches (when merging two datasets, take the input dataset as the base dataset, and then find all matches in id_reps, by name)
# dataset needs to have name column
name_match <- function(dataset) {
    # import id_reps
    id_reps <- read_csv("data/cleaned/unique_id_reps.csv", show_col_types = FALSE)
    id_reps["name"] <- paste(id_reps$first_name, id_reps$last_name)
    # for each name in the dataset, find the best match in id_reps
    for (i in 1:nrow(dataset)) {
        name <- dataset$name[i]
        matches <- id_reps$name
        probs <- stringsim(name, matches, method = "jw")
        best_match <- which.max(probs)
        dataset$member_id[i] <- id_reps$member_id[best_match]
        print(id_reps$member_id[best_match])
    }
    return(dataset)
}

# using the function stringsim, we calculate the similarities of the name matches, and then choose the best match, acc. to the highest probability

# function that goes through each row and reads out congressNumber, creates new variabl "seniority",
# for each congress number less than suffix from variable name, adds number of congresses to seniority
# returns df with new variables
add_seniority <- function(df, current_congress_number) {
    for (i in 1:nrow(df)) {
        congresses <- fromJSON(df$congresses[i]) %>%
            filter(congressNumber <= current_congress_number)
        current_congress_number <- as.character(current_congress_number)
        col_name <- glue("seniority_{current_congress_number}")
        df[[col_name]][i] <- nrow(congresses)
    }
    return(df)
}

keep_ids <- function(rep) {
    rep <- rep %>% select(
        id
    )
    rep <- right_join(full_reps, rep, by = c("bioguide_id" = "id"))
    rep <- rep %>% filter(!is.na(opensecrets_id))
    return(rep)
}
