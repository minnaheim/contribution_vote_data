source("src/cleaning/utils/combine_columns.R")

rep_cleaning <- function(dataset) {
    trimws(dataset)
    colnames(dataset) <- c("last_name", "first_name", "state", "party", "chamber")
    dataset <- dataset %>% dplyr::filter(chamber != "Senate")
    return(dataset)
}

# fuzzy join based on Names, Party and States
# create function that returns True or False, if distance between two strings is less than 3
fuzzy_match <- function(x, y, max_dist = 3) {
    return(stringdist::stringdist(x, y) <= max_dist)
}

fuzzy_match_last <- function(x, y) {
    return(fuzzy_match(x, y, 1))
}
fuzzy_match_first <- function(x, y) {
    return(fuzzy_match(x, y, 3)) # in roll_call = 3
}

# create a fuzzy merge function that merges each input dataset with the rep_u_id dataset,
# join_by must be this: c("last_name", "first_name", "party", "state")
fuzzy_join_representative_id <- function(dataset) {
    # import id_reps
    id_reps <- read_csv("data/cleaned/unique_id_reps.csv", show_col_types = FALSE)
    dataset <- fuzzy_left_join(
        dataset,
        id_reps,
        by = c("last_name", "first_name", "party", "state"),
        match_fun = list(fuzzy_match_last, fuzzy_match_first, `==`, `==`)
    )
    # combine columns
    dataset <- combine_columns(dataset, "first_name", FALSE)
    dataset <- combine_columns(dataset, "last_name", FALSE)
    dataset <- combine_columns(dataset, "party")
    dataset <- combine_columns(dataset, "state")
    # relocate cols
    dataset <- relocate(dataset, "first_name")
    dataset <- relocate(dataset, "last_name", "party", "state", "member_id", .after = "first_name")

    return(dataset)
}
