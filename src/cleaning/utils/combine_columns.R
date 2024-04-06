# combine all columns that start with column_name into one column
# if values are different, seperate by ","
# if values are the same or NA, keep the value
# remove the other columns
combine_columns <- function(dataset, column_start_with, combine = TRUE) {
    cols <- grep(paste0("^", column_start_with), names(dataset), value = TRUE)
    dataset[[column_start_with]] <- apply(
        dataset[cols],
        1,
        function(x) {
            x <- x[!is.na(x)]
            if (length(unique(x)) > 1 && combine) {
                paste(x, collapse = ",")
            } else {
                x[1]
            }
        }
    )


    # remove column_name from cols if exists
    cols <- cols[!cols %in% column_start_with]

    # remove other columns
    dataset <- dataset %>%
        select(-one_of(cols))

    return(dataset)
}

combine_diff_columns <- function(dataset, col1, col2, combine = TRUE) {
    dataset[[col1]] <- apply(
        dataset[c(col1, col2)],
        1,
        function(x) {
            x <- x[!is.na(x)]
            if (length(unique(x)) > 1 && combine) {
                paste(x, collapse = ",")
            } else {
                x[1]
            }
        }
    )
    # remove column_name from cols if exists
    dataset <- dataset %>% select(-one_of(col2))

    return(dataset)
}
