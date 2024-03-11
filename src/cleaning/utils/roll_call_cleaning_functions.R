# create function to clean the representatives dataset,
# clean rep dataset, split sort_name by ,
rep_name_split_keep_imp_cols <- function(rep) {
    # split sort_name by ,
    rep[c("Last", "First")] <- str_split_fixed(rep$sort_name, ",", 2)

    # select only important cols
    rep <- rep %>% select(Last, First, group_id, area_id, )

    return(rep)
}

# this is a cleaning function for the pre-cleaned representative data,
# where we only need to remove a second index column, and change the state names
# into state abbreviations
remove_index <- function(dataset) {
    dataset <- subset(dataset, select = -...1)
}

add_state_abbrev <- function(dataset) {
    # read in state abbreviation
    state_abbrev <- read_csv("data/original/state_abbreviations.csv", show_col_types = FALSE)
    # now we want to look at the State Abbreviations column and match with state abbreviations, if the char length is > 2
    for (i in 1:nrow(dataset)) {
        if (!is.na(dataset$State[i]) && nchar(dataset$State[i]) > 2) {
            state <- dataset$State[i]
            matching_postal <- state_abbrev$Postal[state_abbrev$State == state]
            if (length(matching_postal) > 0) {
                dataset$State[i] <- matching_postal[1]
            }
        }
    }
    return(dataset)
}


party_abbreviation <- function(dataset) {
    for (i in 1:nrow(dataset)) {
        if (dataset$Party[i] == "Democrat") {
            dataset$Party[i] <- "D"
        }
        if (dataset$Party[i] == "Republican") {
            dataset$Party[i] <- "R"
        }
        if (dataset$Party[i] == "Independent") {
            dataset$Party[i] <- "I"
        }
    }
    return(dataset)
}


# cleaning functions that clean the unique ID datasets.
