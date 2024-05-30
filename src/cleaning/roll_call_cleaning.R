# here I import the LCV scorecard votes, clean them and prepare to merge them to the contributions dataset.
# out of the 6 rollcall votes, only the most recent vote, from 2021 has the bioguide and govtrack ID, so i will merge by that.
# the other 5 i will merge manually, by names, party, state and district.
library(tidyverse)
library(fuzzyjoin)
library(conflicted)
source("src/cleaning/utils/roll_call_cleaning_functions.R")

# read in data
lcv_2021 <- read_delim("data/original/roll_call/2021_lcv_votes.csv",
    show_col_types = FALSE
)
methane_113 <- read_csv("data/original/roll_call/methane-emissions-113.csv",
    show_col_types = FALSE
)
methane_114 <- read_csv("data/original/roll_call/methane-pollution-safeguards-114.csv",
    show_col_types = FALSE
)
methane_115 <- read_csv("data/original/roll_call/methane-pollution-safeguards-115.csv",
    show_col_types = FALSE
)
methane_115_2 <- read_csv("data/original/roll_call/methane-pollution-safeguards-115-2.csv",
    show_col_types = FALSE
)
methane_116 <- read_csv("data/original/roll_call/methane-pollution-safeguards-116.csv",
    show_col_types = FALSE
)


# 2021 vote
# manually removed spaced within cols, to snakecase
methane_117 <- lcv_2021 %>% select(District, Party, Member_of_Congress, BioID, GovtrackID, Repealing)
methane_117 <- methane_117 %>%
    rename(Representative = Member_of_Congress) %>%
    rename(Vote = Repealing)

# 2013 until 2019 votes
# Merge all roll calls (and remove the upper casing of names)
roll_call_full_1 <- merge_roll_calls(c("3", "4"), list(methane_113, methane_114))
roll_call_full_2 <- merge_roll_calls(c("51", "52"), list(methane_115, methane_115_2))

# merge methane_116 and methane_117 together by using fuzzyjoin clean names, (using clean_strings) and fuzzyjoin
fuzzy_match <- function(x, y, max_dist = 5) {
    return(stringdist::stringdist(x, y) <= max_dist)
}
# sub , out of all rows, representativein methane_116
methane_116$name <- methane_116$Representative
methane_116$name <- gsub(",", "", methane_116$name)
methane_116$name <- clean_strings(methane_116$Representative)
methane_117$name <- methane_117$Representative
methane_117$name <- gsub(",", "", methane_117$name)
methane_117$name <- clean_strings(methane_117$Representative)

roll_call_full_3 <- fuzzy_full_join(
    methane_116,
    methane_117,
    by = c("name", "Party", "District"),
    match_fun = list(fuzzy_match, `==`, `==`)
)

# combine all cols
roll_call_full_3 <- combine_columns(roll_call_full_3, "Representative")
roll_call_full_3 <- combine_columns(roll_call_full_3, "Party")
roll_call_full_3 <- combine_columns(roll_call_full_3, "District")
roll_call_full_3 <- combine_columns(roll_call_full_3, "name")
roll_call_full_3 <- roll_call_full_3 %>%
    rename(Vote6 = Vote.x) %>%
    rename(Vote7 = Vote.y)

# of those representatives that couldnt merge before, we have to remove the duplicated names
roll_call_full_3$Representative <- str_extract(roll_call_full_3$Representative, "^[^,]+,[^,]+")

# complete the rest of the merge_roll_calls function
# Split Representative column
roll_call_full_3 <- separate(roll_call_full_3, "Representative", c("last_name", "first_name"), sep = ", ")

# combine cols
roll_call_full_3 <- combine_columns(roll_call_full_3, "Party")
roll_call_full_3 <- combine_columns(roll_call_full_3, "District")

# # Create State column
roll_call_full_3$State <- substr(roll_call_full_3$District, 1, 2)
roll_call_full_3 <- relocate(roll_call_full_3, District, .after = State)


roll_call_full <- final_merge_roll_call(list(roll_call_full_1, roll_call_full_2, roll_call_full_3))
# view(roll_call_full)
# clean district column
roll_call_full <- roll_call_full %>%
    rename(district = District)
roll_call_full$district <- str_extract(roll_call_full$district, "^([^,]+)")
# remove 23 NAs, i.e. representatives from Alaska and Delaware, only one representative from each state
roll_call_full$district <- str_extract(roll_call_full$district, "(?<=-)[0-9]+")
roll_call_full$district <- str_replace(roll_call_full$district, "(?:0*([1-9][0-9]*))|(0)", "\\1")
roll_call_full$district[is.na(roll_call_full$district)] <- 0
# view(roll_call_full)

# insert count_votes column
# view(roll_call_full)
roll_call_full <- count_votes(roll_call_full)
# write ? and n/a values to NA
roll_call_full <- mark_na(roll_call_full)
# using count_changes function to find out how many reps changed their votes
roll_call_full <- count_vote_changes(roll_call_full)

# use fuzzy_join_rep_id to merge together roll_call data and id_reps, within function
roll_call_full <- rename(roll_call_full, c("party" = "Party")) %>%
    # rename(., c("first_name" = "FirstName")) %>%
    rename(., c("state" = "State"))


roll_call_full <- roll_call_full %>% relocate(BioID, GovtrackID)

view(roll_call_full)
# write df as csv
write.csv(roll_call_full, "data/cleaned/roll_call.csv", row.names = FALSE)
