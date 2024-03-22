## merge fin rep document
# SET UP
library(tidyverse)
library(fuzzyjoin)
# library(stringdist)


# import datasets
contributions <- read_csv("data/cleaned/contributions.csv",
    show_col_types = FALSE
)
roll_call <- read_csv("data/cleaned/roll_call.csv",
    show_col_types = FALSE
)

view(contributions)
view(roll_call)

df <- fuzzy_left_join(
    roll_call,
    contributions,
    by = c("name", "party", "state", "member_id"),
    match_fun = list(`fuzzy_match_first`, `==`, `==`, `==`)
)
df <- combine_columns(df, "first_name", FALSE)
df <- combine_columns(df, "last_name", FALSE)
df <- combine_columns(df, "party")
df <- combine_columns(df, "state")
df <- combine_columns(df, "name.x", FALSE)
df <- combine_columns(df, "name", FALSE)
df <- combine_columns(df, "member_id", FALSE)
df <- combine_columns(df, "rest_of_name", FALSE)
df <- select(df, -rest_of_name)

# relocate cols
df <- relocate(df, last_name)
df <- relocate(df, first_name, .after = last_name)
df <- relocate(df, name, .after = first_name)
df <- relocate(df, party, .after = name)
df <- relocate(df, state, .after = party)
df <- relocate(df, member_id, .after = state)

# view(df)

remove_duplicate_names <- function(data) {
    # Identify duplicates based on first and last name
    duplicates <- data %>%
        group_by(first_name, last_name) %>%
        mutate(duplicate_count = n()) %>%
        dplyr::filter(duplicate_count > 1)
    # Identify rows with a comma in the name column
    has_comma <- duplicates %>%
        dplyr::filter(grepl(",", name))
    # Remove duplicates with comma in the name column
    non_comma_duplicates <- duplicates %>%
        anti_join(has_comma)

    # Combine the non-comma duplicates with original data
    result <- bind_rows(non_comma_duplicates, data) %>%
        distinct(first_name, last_name, .keep_all = TRUE)
    return(result)
}

# remove_duplicate_names(df)
# result contains 725 instead of 739

# jr. jones changed his party twice, R,D,R -> just change to R
for (i in 1:nrow(df)) {
    if (df$last_name[i] == "Jones" & df$first_name[i] == "Jr.") {
        df$party[i] <- "R"
    }
}
# view(df)

write.csv(df, "data/cleaned/final_df.csv", row.names = FALSE)
