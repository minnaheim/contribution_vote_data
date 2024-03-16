library(tidyverse)
library(fuzzyjoin)
library(conflicted)

source("src/cleaning/utils/roll_call_cleaning_functions.R")
source("src/cleaning/utils/fin_cleaning_functions.R")

# import roll call data of the 3 "offshore drilling subsidies" bills:
methane_113 <- read_csv("data/original/methane-emissions-113.csv",
    show_col_types = FALSE
)
methane_114 <- read_csv("data/original/methane-pollution-safeguards-114.csv",
    show_col_types = FALSE
)
methane_115 <- read_csv("data/original/methane-pollution-safeguards-115.csv",
    show_col_types = FALSE
)
methane_115_2 <- read_csv("data/original/methane-pollution-safeguards-115-2.csv",
    show_col_types = FALSE
)
methane_116 <- read_csv("data/original/methane-pollution-safeguards-116.csv",
    show_col_types = FALSE
)
methane_117 <- read_csv("data/original/repealing-assault_methane_pollution_safeguards-117.csv",
    show_col_types = FALSE
)

# Merge all roll calls
roll_call_full_1 <- merge_roll_calls(c("3", "4"), list(methane_113, methane_114))
roll_call_full_2 <- merge_roll_calls(c("51", "52"), list(methane_115, methane_115_2))
roll_call_full_3 <- merge_roll_calls(c("6", "7"), list(methane_116, methane_117))

# merge last 3 datasets together
roll_call_full <- final_merge_roll_call(list(roll_call_full_1, roll_call_full_2, roll_call_full_3))

# view(roll_call_full)
# cleaned rollcall dataset with all 6 bills

# insert count_votes column
roll_call_full <- count_votes(roll_call_full)
# write ? and n/a values to NA
roll_call_full <- mark_na(roll_call_full)
# using count_changes function to find out how many reps changed their votes
roll_call_full <- count_vote_changes(roll_call_full)
# view(roll_call_full)

# how many people voted on more than one bill
repeat_voters <- roll_call_full %>% dplyr::filter(Vote_count > 1)
# view(repeat_voters)

# how many people voted more than once and changed their votes
mind_changers <- roll_call_full %>% dplyr::filter(Vote_change > 0)
# view(mind_changers)

# replicate Strattmann table
# find how many voted + on all bills
repeat_voters_plus <- repeat_voters %>% dplyr::filter(Vote3 == "+" & Vote4 == "+" &
    Vote51 == "+" & Vote52 == "+" & Vote6 == "+" & Vote7 == "+")
# view(repeat_voters_plus)

# find how many voted - on all bills
repeat_voters_minus <- repeat_voters %>% dplyr::filter(Vote3 == "-" & Vote4 == "-" &
    Vote51 == "-" & Vote52 == "-" & Vote6 == "-" & Vote7 == "-")
# view(repeat_voters_minus)


# merge with unique ID (import functions from fin_cleaning_functions.R)

id_reps <- suppressMessages(read_csv("data/cleaned/cleaned_unique_id_reps_copy.csv", show_col_types = FALSE))

id_reps <- clean_id_reps(id_reps)

# view(id_reps)


# MERGE WITH FUZZY JOIN
roll_call_full <- fuzzy_join_id(roll_call_full, id_reps)
roll_call_full <- remove_duplicated(roll_call_full)
# 6 rows less
roll_call_full <- remove_y_cols(roll_call_full)

# view(roll_call_full)

# write df as csv
write.csv(roll_call_full, "data/cleaned/cleaned_full_roll_call_votes.csv", row.names = FALSE)
