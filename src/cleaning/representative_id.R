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
    # second item is always the first name
    first_name <- line[2]

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

    # create a new row
    new_row <- data.frame(last_name, first_name, rest_of_name, party, state, member_id)

    # add the new row to the dataframe
    df <- rbind(df, new_row)
}

# view(df)
# write csv
write.csv(df, "data/cleaned/unique_id_reps.csv", row.names = FALSE)
