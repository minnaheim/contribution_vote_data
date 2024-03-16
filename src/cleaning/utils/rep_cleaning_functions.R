rep_cleaning <- function(dataset) {
    trimws(dataset)
    colnames(dataset) <- c("last_name", "first_name", "state", "party", "chamber")
    dataset <- dataset %>% dplyr::filter(chamber != "Senate")
    return(dataset)
}

# create a fuzzy merge function that merges each input dataset with the rep_u_id dataset,
# join_by must be a vector of strings that represent the columns to join by, if names != "last_name", "first_name", "party", "state",
# then create new list c()s in the function call. <3
# example: c("last_name", "first_name", "party", "state")
fuzzy_join_representative_id <- function(dataset, join_by) {
    # import id_reps
    id_reps <- read_csv("data/cleaned/unique_id_reps.csv", show_col_types = FALSE)
    view(id_reps)
    dataset <- fuzzy_left_join(
        dataset,
        id_reps,
        by = join_by,
        match_fun = list(fuzzy_match_last, fuzzy_match_first, `==`, `==`)
    )
    return(dataset)
}
