add_state_abbrev <- function(dataset, column_name = "state") {
    state_abbrev <- read_csv("data/original/state_abbreviations.csv", show_col_types = FALSE)

    for (i in seq_len(nrow(dataset))) {
        state <- as.character(dataset[i, column_name])
        # if you select in the way above, R saves this as a tibble, not as a string (check str())
        if (!is.na(state) && nchar(state) > 2) {
            matching_postal <- state_abbrev[state_abbrev$State == state, "Postal"]

            if (length(matching_postal) > 0) {
                dataset[i, column_name] <- matching_postal[1]
            }
        }
    }
    return(dataset)
}
