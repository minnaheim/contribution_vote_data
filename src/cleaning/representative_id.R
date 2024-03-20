library(tidyverse)
source("src/cleaning/utils/party_abbreviation.R")
source("src/cleaning/utils/state_abbreviation.R")
source("src/cleaning/utils/rep_cleaning_functions.R")
# read file line by line

con <- file("data/original/unique_id_reps.csv", "r")
lines <- readLines(con)
close(con)

df <- data.frame()
# some rows have more cols than others
# iterate over all lines
# split the row by comma
for (i in 2:length(lines)) {
    line <- strsplit(lines[i], ",")[[1]]

    # first item is always the last name
    last_name <- line[1]
    # second item is always the first name, unless this item has 2 char or less, then check the next item,
    # if it has 2 char or less, then the first name is the item after that.
    # (trying to find members who dont use their first names, but their middle names)
    if (nchar(line[2]) <= 2) {
        first_name <- line[3]
    }
    if (nchar(line[3]) <= 2) {
        first_name <- line[4]
    } else {
        first_name <- line[2]
    }
    # last item is always the representative id
    member_id <- line[length(line)]

    # second to last is the state
    state <- line[length(line) - 1]

    # third to last is the party
    party <- line[length(line) - 2]

    # the rest is part of the name
    if (length(line) > 5) {
        rest_of_name <- paste(line[3:(length(line) - 3)], collapse = " ")
    } else {
        rest_of_name <- NA
    }
    # non-used

    # create a new row
    new_row <- data.frame(last_name, first_name, rest_of_name, party, state, member_id)

    # add the new row to the dataframe
    df <- rbind(df, new_row)
}

# view(df)
df <- clean_names(df)
df <- party_abbreviation(df)
# trim whitespace of all columns
df <- df %>% mutate_all(str_squish)
df <- add_state_abbrev(df)

# view(df)
# write csv
write.csv(df, "data/cleaned/unique_id_reps.csv", row.names = FALSE)
