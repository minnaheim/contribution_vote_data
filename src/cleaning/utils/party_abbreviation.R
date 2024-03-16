party_abbreviation <- function(dataset, column_name = "party") {
    for (i in 1:nrow(dataset)) {
        if (startsWith(dataset[[i, column_name]], "Demo")) {
            dataset[[i, column_name]] <- "D"
        }
        if (dataset[[i, column_name]] == "Republican") {
            dataset[[i, column_name]] <- "R"
        }
        if (dataset[[i, column_name]] == "Independent") {
            dataset[[i, column_name]] <- "I"
        }
    }
    return(dataset)
}
