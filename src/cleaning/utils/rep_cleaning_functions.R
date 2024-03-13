rep_cleaning <- function(dataset) {
    trimws(dataset)
    colnames(dataset) <- c("LastName", "FirstName", "State", "Party", "Chamber")
    dataset <- dataset %>% dplyr::filter(Chamber != "Senate")
    return(dataset)
}


# function to merge dataset with id_rep dataset
# merge_with_cleaned_id <- function(dataset) {
#     # read in id_rep dataset
#     read_csv("data/cleaned_unique_id_reps_copy.csv", show_col_types = FALSE) %>%
#         # remove index column, rename Member ID to member_id
#         select(-...1) %>%
#         rename(member_id = `Member ID`) %>%
#         # to merge with fuzzy join, we also include the party and states, for that we need to include the abbreviations of the states
#         full_join(
#             dataset,
#             read_csv("data/state_abbreviations.csv", show_col_types = FALSE),
#             by = c("State" = "State")
#         )
# }




# # remove index column, rename Member ID to member_id
# id_reps <- subset(id_reps, select = -...1)
# id_reps <- id_reps %>%
#     rename(member_id = `Member ID`)

# view(id_reps)


# # to merge with fuzzy join, we also include the party and states, for that we need to include the abbreviations of the states
# state_abbreviations <- suppressMessages(read_csv("data/state_abbreviations.csv", show_col_types = FALSE))
# view(state_abbreviations)

# # change State column to include only abbreviations of respective states
# for (i in 1:nrow(id_reps)) {
#     if (!is.na(id_reps$State[i]) && nchar(id_reps$State[i]) > 2) {
#         state <- id_reps$State[i]
#         matching_postal <- state_abbreviations$Postal[state_abbreviations$State == state]
#         if (length(matching_postal) > 0) {
#             id_reps$State[i] <- matching_postal[1]
#         }
#     }
# }



## copied from financial cleaning r file, do this in the main rep cleaning df:
# merge financial contributions with unique id
# id_reps <- suppressMessages(read_csv("data/cleaned_unique_id_reps_copy.csv", show_col_types = FALSE))

# merge with the unique id dataset
# remove index column, rename Member ID to member_id
# id_reps <- subset(id_reps, select = -...1)
# id_reps <- id_reps %>%
#     rename(member_id = `Member ID`)

# view(id_reps)

# MERGING & CLEANING ID_REPS NOT DONE WITH FINANCIAL DATA YET, DO THIS IN REP_CLEANING?
# # to merge with fuzzy join, we also include the party and states, for that we need to include the abbreviations of the states
# state_abbreviations <- suppressMessages(read_csv("data/state_abbreviations.csv", show_col_types = FALSE))
# view(state_abbreviations)

# # change State column to include only abbreviations of respective states
# for (i in 1:nrow(id_reps)) {
#     if (!is.na(id_reps$State[i]) && nchar(id_reps$State[i]) > 2) {
#         state <- id_reps$State[i]
#         matching_postal <- state_abbreviations$Postal[state_abbreviations$State == state]
#         if (length(matching_postal) > 0) {
#             id_reps$State[i] <- matching_postal[1]
#         }
#     }
# }
# view(id_reps)
