library(tidyverse)
library(fuzzyjoin)
library(fedmatch)
source("src/cleaning/utils/combine_columns.R")
source("src/cleaning/utils/rep_cleaning_functions.R")

# read in cleaned data
roll_call <- read_csv("data/cleaned/roll_call.csv", show_col_types = FALSE)
contributions <- read_csv("data/cleaned/contribs_wide.csv", show_col_types = FALSE)
view(roll_call)
view(contributions)

# Initial join on BioID
df_1 <- left_join(roll_call, contributions, by = c("BioID" = "bioguide_id"))
df_1 <- df_1 %>% relocate(opensecrets_id)
# 362 out of 802 didnt match
# 372 out of 802 didnt match

# combine columns
df_1 <- combine_columns(df_1, "first_name")
df_1 <- combine_columns(df_1, "last_name")
df_1 <- combine_columns(df_1, "state")
df_1 <- combine_columns(df_1, "district")
# view(df_1)

# select all columns from contribs_wide that are not in df_1
unassigned_contribs <- contributions %>% anti_join(df_1, by = c("bioguide_id" = "BioID"))

unmerged <- df_1 %>% filter(is.na(BioID))
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
# view(unassigned_contribs)
# view(unmerged)

df_2 <- fuzzy_left_join(
    unmerged,
    unassigned_contribs,
    by = c("state", "district", "name"),
    match_fun = list(`==`, `==`, fuzzy_match)
)

# put both name columns infront
# df_2 <- combine_columns(df_2, "name")
df_2 <- select(df_2, name.x, name.y, everything())

# left_join(unmerged, unassigned_contribs, by = c("state", "first_name", "last_name", "district"))

# combine columns
df_2 <- combine_columns(df_2, "opensecrets_id")
df_2 <- df_2 %>% rename(BioID.x = bioguide_id)
df_2 <- df_2 %>% rename(BioID.y = BioID)
df_2 <- combine_columns(df_2, "BioID")
df_2 <- combine_columns(df_2, "first_name")
df_2 <- combine_columns(df_2, "last_name")
df_2 <- combine_columns(df_2, "state")
df_2 <- combine_columns(df_2, "district")
df_2 <- combine_columns(df_2, "name")
df_2 <- combine_columns(df_2, "Contribution_3_minus")
df_2 <- combine_columns(df_2, "Contribution_3_plus")
df_2 <- combine_columns(df_2, "Contribution_4_minus")
df_2 <- combine_columns(df_2, "Contribution_4_plus")
df_2 <- combine_columns(df_2, "Contribution_51_minus")
df_2 <- combine_columns(df_2, "Contribution_51_plus")
df_2 <- combine_columns(df_2, "Contribution_52_minus")
df_2 <- combine_columns(df_2, "Contribution_52_plus")
df_2 <- combine_columns(df_2, "Contribution_6_minus")
df_2 <- combine_columns(df_2, "Contribution_6_plus")
df_2 <- combine_columns(df_2, "Contribution_7_minus")
df_2 <- combine_columns(df_2, "Contribution_7_plus")
df_2 <- combine_columns(df_2, "seniority_113")
df_2 <- combine_columns(df_2, "seniority_114")
df_2 <- combine_columns(df_2, "seniority_115")
df_2 <- combine_columns(df_2, "seniority_116")
df_2 <- combine_columns(df_2, "seniority_117")
df_2 <- combine_columns(df_2, "birthday")
df_2 <- combine_columns(df_2, "nominate_dim1")
df_2 <- combine_columns(df_2, "nominate_dim2")
df_2$birthday <- as.Date(df_2$birthday)
df_2 <- combine_columns(df_2, "gender")

# view(df_2)

# transform to numeric.
df_2 <- df_2 %>% mutate(across(starts_with("Contribution"), as.numeric))

# Combine the successfully joined rows with the ones from the secondary join
df_1_merged_only <- df_1 %>% filter(!is.na(BioID))
# view(df_1_merged_only)
# view(df_2)

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

# keep only distinct representatives
final_df <- final_df %>% distinct(first_name, last_name, state, district, .keep_all = TRUE)

view(final_df)
# only 106 NAs in final df (BioID)
# only 37 NAs left
# print(nrow(final_df))

# in case of NAs, merge manually based on first_name, last_name, state, district
write.csv(final_df, "data/cleaned/df.csv", row.names = FALSE)
