library(tidyverse)
source("src/cleaning/utils/combine_columns.R")

# read in cleaned data
roll_call <- read_csv("data/cleaned/roll_call.csv", show_col_types = FALSE)
contribs_wide <- read_csv("data/cleaned/contribs_wide.csv", show_col_types = FALSE)

# view(roll_call)
# view(contribs_wide)

# if I merge by bioguide ID, then out of approx. 800 representatives, about 500 are merged
# create a merge function, start by merging with bioguide, if not successful, try with name
# FIND OUT WHAT HAPPENS TO THOSE WITH 0 CONTRIBUTIONS

# Initial join on BioID
df_1 <- left_join(roll_call, contribs_wide, by = c("BioID" = "bioguide_id"))

# if "," in first_name and no "," in district, then take the second name, and discard the first in firstname

# combine columns
df_1 <- combine_columns(df_1, "first_name")
df_1 <- combine_columns(df_1, "last_name")
df_1 <- combine_columns(df_1, "state")
df_1 <- combine_columns(df_1, "district")
# view(df_1)

unmerged <- df_1 %>% filter(is.na(BioID))
unmerged <- combine_columns(unmerged, "first_name")
unmerged <- combine_columns(unmerged, "last_name")
unmerged <- combine_columns(unmerged, "state")
unmerged <- combine_columns(unmerged, "district")
# view(unmerged)

unmerged_for_join <- unmerged %>% select(first_name, last_name, state, district, everything()) # places relevant cols infront
unmerged_for_join$district <- as.numeric(unmerged_for_join$district)
# view(unmerged_for_join)

df_2 <- left_join(unmerged_for_join, contribs_wide, by = c("state", "first_name", "last_name", "district"))
# combine columns
df_2 <- combine_columns(df_2, "opensecrets_id")
df_2 <- df_2 %>% rename(BioID.x = bioguide_id)
df_2 <- df_2 %>% rename(BioID.y = BioID)
df_2 <- combine_columns(df_2, "BioID")

# combine all contribution columns
df_2 <- combine_columns(df_2, "Contribution_3_-")
df_2 <- combine_columns(df_2, "Contribution_3_+")
df_2 <- combine_columns(df_2, "Contribution_4_-")
df_2 <- combine_columns(df_2, "Contribution_4_+")
df_2 <- combine_columns(df_2, "Contribution_51_-")
df_2 <- combine_columns(df_2, "Contribution_51_+")
df_2 <- combine_columns(df_2, "Contribution_52_-")
df_2 <- combine_columns(df_2, "Contribution_52_+")
df_2 <- combine_columns(df_2, "Contribution_6_-")
df_2 <- combine_columns(df_2, "Contribution_6_+")
df_2 <- combine_columns(df_2, "Contribution_7_-")
df_2 <- combine_columns(df_2, "Contribution_7_+")

view(df_2)
# NOT DONE YET, INITIALS WITH FUZZY JOIN (MERGE BY NAME, NOT FIRST AND LASTNAME)
# FIND OUT WHAT DO DO WITH PPL WHO RECEIVED 0 CONTRIBUTIONS

# # Combine the successfully joined rows with the ones from the secondary join
# df_1_merged_only <- df_1 %>% filter(!is.na(BioID))

# final_df <- bind_rows(df_1_merged_only, df_2)
# final_df <- combine_columns(final_df, "first_name")
# final_df <- combine_columns(final_df, "last_name")
# final_df <- combine_columns(final_df, "state")
# final_df <- combine_columns(final_df, "district")
# final_df <- combine_columns(final_df, "BioID")

# # relocate cols
# final_df <- relocate(final_df, BioID)
# final_df <- relocate(final_df, GovtrackID, .after = BioID)
# final_df <- relocate(final_df, opensecrets_id, .after = GovtrackID)
# final_df <- relocate(final_df, first_name, .after = opensecrets_id)
# final_df <- relocate(final_df, last_name, .after = first_name)
# final_df <- relocate(final_df, state, .after = last_name)
# final_df <- relocate(final_df, district, .after = state)
# final_df <- relocate(final_df, party, .after = district)
# view(final_df)


# in case of NAs, merge manually based on first_name, last_name, state, district
