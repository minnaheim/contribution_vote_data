# SET UP
library(tidyverse)
library(fuzzyjoin)

# import data cleaning pipeline:
source("src/cleaning/utils/fin_cleaning_functions.R")
source("src/cleaning/utils/roll_call_cleaning_functions.R")
source("src/cleaning/utils/read_from_folder.R")
# source("src/cleaning/utils/rep_cleaning_functions.R")


contributions <- read_from_folder("data/cleaned/contributions")
representatives <- read_from_folder("data/cleaned/representatives")


# apply remove_index_state_abbrev function to each df
representatives <- lapply(representatives, remove_index)

# apply state abbreviations to state
representatives <- lapply(representatives, add_state_abbrev)

# apply party abbreviation function
representatives <- lapply(representatives, party_abbreviation)


merged <- c()
# for each element in representatives, left_join with the element contributions
for (i in 1:length(representatives)) {
    temp <- fuzzy_left_join(
        representatives[[i]][, c("LastName", "FirstName", "State", "Party")],
        contributions[[i]],
        by = c("LastName", "FirstName", c("State" = "StateAbbreviation"), c("Party")),
        match_fun = list(fuzzy_match_last, fuzzy_match_first, `==`, `==`)
    )
    temp <- combine_columns(temp, "Party")
    temp <- select(temp, -c("StateAbbreviation"))
    # relocate cols
    temp <- relocate(temp, LastName.y, .after = LastName.x)
    temp <- relocate(temp, FirstName.y, .after = FirstName.x)

    merged <- append(merged, list(temp))
}

view(merged[1])
# not done here, include manual dataset, instead of representatives_113

# 117
# merge with ID first
rep_117 <- fuzzy_join_id(rep_117, id_reps)
# view(rep_117) # -> all good.

# view(master_df_117)
# view(id_reps)
# master_df_117 <- master_df_117 %>% rename("State" = "StateAbbreviation")
# master_df_117 <- fuzzy_join_id(master_df_117, id_reps)



# now add the unique ID reps:
# merge financial contributions with unique id
id_reps <- suppressMessages(read_csv("data/cleaned/cleaned_unique_id_reps_copy_2.csv", show_col_types = FALSE))

# apply cleaning function to id_reps
id_reps <- clean_id_reps(id_reps)
# view(id_reps)


# merge id with fuzzy join

all_reps_114 <- fuzzy_join_id(all_reps_114, id_reps)
all_reps_115 <- fuzzy_join_id(all_reps_115, id_reps)
all_reps_116 <- fuzzy_join_id(all_reps_116, id_reps)

all_reps_114 <- remove_duplicated(all_reps_114)
all_reps_115 <- remove_duplicated(all_reps_115)
all_reps_116 <- remove_duplicated(all_reps_116)

all_reps_114 <- remove_y_cols(all_reps_114)
all_reps_115 <- remove_y_cols(all_reps_115)
all_reps_116 <- remove_y_cols(all_reps_116)

# view(all_reps_114) -> no more ID NAs
# view(all_reps_115) -> no more ID NAs
# view(all_reps_116) -> no more ID NAs
# looks like no mismatches?

# merge based on id, party, state and names
all_reps <- term_merge_id(list(all_reps_114, all_reps_115, all_reps_116))
# view(all_reps)


# 597 elements -> ac count for changes in house of representatives...(approx. 20 changes per session)
write.csv(all_reps, "data/cleaned/reps_contributions.csv", row.names = FALSE)
