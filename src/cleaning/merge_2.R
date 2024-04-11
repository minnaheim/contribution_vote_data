library(tidyverse)
library(fuzzyjoin)
library(fedmatch)
source("src/cleaning/utils/combine_columns.R")
source("src/cleaning/utils/rep_cleaning_functions.R")

# read in cleaned data
roll_call <- read_csv("data/cleaned/roll_call.csv", show_col_types = FALSE)
contributions <- read_csv("data/cleaned/contribs_wide.csv", show_col_types = FALSE)

print("Number of rows in roll_call")
print(nrow(roll_call))

# Initial join on BioID
df_1 <- left_join(roll_call, contributions, by = c("BioID" = "bioguide_id"))

# combine columns
df_1 <- combine_columns(df_1, "first_name")
df_1 <- combine_columns(df_1, "last_name")
df_1 <- combine_columns(df_1, "state")
df_1 <- combine_columns(df_1, "district")

# select all columns from contribs_wide that are not in df_1
unassigned_contribs <- contributions %>% anti_join(df_1, by = c("bioguide_id" = "BioID"))

unmerged <- df_1 %>% filter(is.na(BioID))

print(nrow(unassigned_contribs))
print(nrow(unmerged))

unmerged <- unmerged %>% select(first_name, last_name, state, district, everything()) # places relevant cols infront
unmerged$district <- as.numeric(unmerged$district)
df_1$district <- as.numeric(df_1$district)
unassigned_contribs$district <- as.numeric(unassigned_contribs$district)


# fuzzy join based on Names, District and States
# create function that returns True or False, if distance between two strings is less than 3
fuzzy_match <- function(x, y, max_dist = 5) {
    return(stringdist::stringdist(x, y) <= max_dist)
}


# create combined name column
unmerged <- unmerged %>% mutate(name = paste(first_name, last_name, sep = " "))
unassigned_contribs <- unassigned_contribs %>% mutate(name = paste(first_name, last_name, sep = " "))
unassigned_contribs$name <- clean_strings(unassigned_contribs$name)
unmerged$name <- clean_strings(unmerged$name)

df_2 <- fuzzy_left_join(
    unmerged,
    unassigned_contribs,
    by = c("state", "district", "name"),
    match_fun = list(`==`, `==`, fuzzy_match)
)

# put both name columns infront
# df_2 <- combine_columns(df_2, "name")
df_2 <- select(df_2, name.x, name.y, everything())

# to csv for manual inspection
# write.csv(df_2, "temp.csv", row.names = FALSE)
# view(df_2)

# left_join(unmerged, unassigned_contribs, by = c("state", "first_name", "last_name", "district"))

# combine columns
df_2 <- combine_columns(df_2, "opensecrets_id")
df_2 <- df_2 %>% rename(BioID.x = bioguide_id)
df_2 <- df_2 %>% rename(BioID.y = BioID)
df_2 <- combine_columns(df_2, "BioID")

view(df_2)

print("Number of rows in df_2")
print(nrow(df_2))

# combine all contribution columns
df_2 <- combine_columns(df_2, "Contribution_3_-")
df_2 <- combine_columns(df_2, "Contribution_3_+")
df_2 <- combine_columns(df_2, "Contribution_4_+")
df_2 <- combine_columns(df_2, "Contribution_4_-")
df_2 <- combine_columns(df_2, "Contribution_51_+")
df_2 <- combine_columns(df_2, "Contribution_51_-")
df_2 <- combine_columns(df_2, "Contribution_52_+")
df_2 <- combine_columns(df_2, "Contribution_52_-")
df_2 <- combine_columns(df_2, "Contribution_6_+")
df_2 <- combine_columns(df_2, "Contribution_6_-")
df_2 <- combine_columns(df_2, "Contribution_7_+")
df_2 <- combine_columns(df_2, "Contribution_7_-")




# transform to numeric.
df_2 <- df_2 %>% mutate(across(starts_with("Contribution"), as.numeric))

# NOT DONE YET, INITIALS WITH FUZZY JOIN (MERGE BY NAME, NOT FIRST AND LASTNAME)
# FIND OUT WHAT DO DO WITH PPL WHO RECEIVED 0 CONTRIBUTIONS

# Combine the successfully joined rows with the ones from the secondary join
df_1_merged_only <- df_1 %>% filter(!is.na(BioID))


final_df <- bind_rows(df_1_merged_only, df_2)
final_df <- combine_columns(final_df, "first_name")
final_df <- combine_columns(final_df, "last_name")
final_df <- combine_columns(final_df, "state")
final_df <- combine_columns(final_df, "district")
final_df <- combine_columns(final_df, "BioID")
# relocate cols
final_df <- relocate(final_df, BioID)
final_df <- relocate(final_df, GovtrackID, .after = BioID)
final_df <- relocate(final_df, opensecrets_id, .after = GovtrackID)
final_df <- relocate(final_df, first_name, .after = opensecrets_id)
final_df <- relocate(final_df, last_name, .after = first_name)
final_df <- relocate(final_df, state, .after = last_name)
final_df <- relocate(final_df, district, .after = state)
final_df <- relocate(final_df, party, .after = district)


# rename cols from + and - to _plus and _minus
final_df <- final_df %>% rename_with(~ str_replace(., "\\+", "plus"))
final_df <- final_df %>% rename_with(~ str_replace(., "-", "minus"))

# non merges appear twice (Robert (B.) Aderholt, Mark E. Amodei...)

# keep only distinct representatives
final_df <- final_df %>% distinct(first_name, last_name, state, district, .keep_all = TRUE)

# view(final_df)
# print(nrow(final_df))

# in case of NAs, merge manually based on first_name, last_name, state, district
write.csv(final_df, "data/cleaned/df.csv", row.names = FALSE)
