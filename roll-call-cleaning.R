library(tidyverse)
# install.packages("conflicted")
# install.packages("fuzzyjoin", repos = "https://stat.ethz.ch/CRAN/")
library(fuzzyjoin)
library(conflicted)

# import roll call data of the 3 "offshore drilling subsidies" bills:
methane_114 <- read_csv("data/methane-pollution-safeguards-114.csv",
    show_col_types = FALSE
)
methane_115 <- read_csv("data/methane-pollution-safeguards-115.csv",
    show_col_types = FALSE
)
methane_116 <- read_csv("data/methane-pollution-safeguards-116.csv",
    show_col_types = FALSE
)

# view(methane_116)
# create merged dataset - merge based on representative (votes)

# # try with sample dataset
# sample_114 <- methane_114[1:10, ]
# sample_115 <- methane_115[1:10, ]
# sample_116 <- methane_116[1:10, ]

# # full join sample dataset
# sample_merge_full <- full_join(sample_114, sample_115, by = "Representative", suffix = c(".114", ".115"))
# # inner join sample dataset
# sample_merge_inner <- inner_join(sample_114, sample_115, by = "Representative", suffix = c(".114", ".115"))


# full dataset:

# full join dataset
roll_call_114_115_full <- full_join(methane_114, methane_115, by = "Representative", suffix = c(".114", ".115"))
roll_call_114_115_116_full <- full_join(roll_call_114_115_full, methane_116, by = "Representative", suffix = c(".114.115", ".116"))

# rename columns of Party, District and Vote, add suffix .116
roll_call_114_115_116_full <- roll_call_114_115_116_full %>%
    rename(Party.116 = Party, District.116 = District, Vote.116 = Vote)


# split Representative Column into LastName and FirstName

roll_call_114_115_116_full <- separate(roll_call_114_115_116_full, Representative, c("LastName", "FirstName"), sep = ", ")
# view(roll_call_114_115_116_full)

# 115
roll_call_114_115_116_full$Party.114 <- ifelse(is.na(roll_call_114_115_116_full$Party.114), roll_call_114_115_116_full$Party.115, roll_call_114_115_116_full$Party.114)

roll_call_114_115_116_full$District.114 <- ifelse(is.na(roll_call_114_115_116_full$District.114), roll_call_114_115_116_full$District.115, roll_call_114_115_116_full$District.114)

# 116
roll_call_114_115_116_full$Party.114 <- ifelse(is.na(roll_call_114_115_116_full$Party.114), roll_call_114_115_116_full$Party.116, roll_call_114_115_116_full$Party.114)

roll_call_114_115_116_full$District.114 <- ifelse(is.na(roll_call_114_115_116_full$District.114), roll_call_114_115_116_full$District.116, roll_call_114_115_116_full$District.114)

# remove obsolete columns
roll_call_114_115_116_full <- select(roll_call_114_115_116_full, -c("Party.115", "District.115", "Party.116", "District.116"))

# rename Party and District columns
roll_call_114_115_116_full <- roll_call_114_115_116_full %>%
    rename(Party = Party.114) %>%
    rename(District = District.114)

# create a new column state, which includes State, not district
roll_call_114_115_116_full$State <- substr(roll_call_114_115_116_full$District, 1, 2)

roll_call_114_115_116_full <- relocate(roll_call_114_115_116_full, State, .after = District)

# rename df
roll_call_full <- roll_call_114_115_116_full
# view(roll_call_full)

# create dataset for analysis (with at least two votes)

# # dataset which includes representatives who voted on at least 2 of the 3 bills
# repeated_votes <- roll_call_full %>%
#     dplyr::filter(!is.na(Vote.114) & !is.na(Vote.115) | !is.na(Vote.115) & !is.na(Vote.116) | !is.na(Vote.114) & !is.na(Vote.116))

# # create index column
# repeated_votes$ID <- 1:nrow(repeated_votes)

# # put ID col as the first column
# repeated_votes <- repeated_votes %>%
#     relocate(ID)

# # dataset which includes representatives who voted on >2 occasions and no n/a, ? or E

count_votes <- function(dataset) {
    dataset["Vote_count"] <- 0

    for (i in 1:nrow(dataset)) {
        row <- dataset[i, ]
        count <- 0
        # vote.114
        if (is.na(row$Vote.114)) {
            count <- count + 0
        } else if (!is.na(row$Vote.114) && row$Vote.114 == "+" || row$Vote.114 == "-") {
            count <- count + 1
        }
        # vote.115
        if (is.na(row$Vote.115)) {
            count <- count + 0
        } else if (!is.na(row$Vote.115) && row$Vote.115 == "+" || row$Vote.115 == "-") {
            count <- count + 1
        }
        # vote.116
        if (is.na(row$Vote.116)) {
            count <- count + 0
        } else if (!is.na(row$Vote.116) && row$Vote.116 == "+" || row$Vote.116 == "-") {
            count <- count + 1
        }
        # put values into new column, called vote_count
        dataset[i, ]["Vote_count"] <- count
    }
    return(dataset)
}

roll_call_full <- count_votes(roll_call_full)
# view(roll_call_full)
# -> why only 424 people?

# if n/a values of ? values in dataset, mark as NA
roll_call_full <- roll_call_full %>%
    mutate(
        Vote.114 = ifelse(Vote.114 == "?" | Vote.114 == "n/a", NA, Vote.114),
        Vote.115 = ifelse(Vote.115 == "?" | Vote.115 == "n/a", NA, Vote.115),
        Vote.116 = ifelse(Vote.116 == "?" | Vote.116 == "n/a", NA, Vote.116)
    )

# view(roll_call_full)


# find representatives in roll_call_114_115_116_full who changed their votes from + to - or vice versa, and count number of changes

# create new column
roll_call_full["Vote_change"] <- 0
# view(roll_call_full)

# create a function based on Vote_count. If Vote_count is 3, then check if there are any changes in votes, and count them. If vote_count is 2, then look at the non-NA values, and if they are + or -, then check whether there is a change in vote, i.e. from + to - or vice versa, if there are vote changes, put 1, if not 0. Dont look at 1 vote counts, as there is no change in vote.

count_vote_changes <- function(dataset) {
    for (i in 1:nrow(dataset)) {
        row <- dataset[i, ]
        Vote_change <- NA
        if (row$Vote_count == 3) {
            if (row$Vote.114 != row$Vote.115) {
                dataset[i, ]["Vote_change"] <- dataset[i, ]["Vote_change"] + 1
            }
            if (row$Vote.115 != row$Vote.116) {
                dataset[i, ]["Vote_change"] <- dataset[i, ]["Vote_change"] + 1
                # change in 3 votes can be max. 2, so if 114 != 115 and 115 != 116, then 114 == 116 (must be, since the only options are +, -)
            }
        } else if (row$Vote_count == 2) {
            # here, vote change will always be max. 1
            if (!is.na(row$Vote.114) && !is.na(row$Vote.115) && row$Vote.114 != row$Vote.115) {
                dataset[i, ]["Vote_change"] <- dataset[i, ]["Vote_change"] + 1
            } else if (!is.na(row$Vote.115) && !is.na(row$Vote.116) && row$Vote.115 != row$Vote.116) {
                dataset[i, ]["Vote_change"] <- dataset[i, ]["Vote_change"] + 1
            } else if (!is.na(row$Vote.114) && !is.na(row$Vote.116) && row$Vote.114 != row$Vote.116) {
                dataset[i, ]["Vote_change"] <- dataset[i, ]["Vote_change"] + 1
            }
        } else { # vote_count == 1
            dataset[i, ]["Vote_change"] <- 0
        }
    }
    return(dataset)
}
roll_call_full <- count_vote_changes(roll_call_full)
# view(roll_call_full)

# write df as csv
write.csv(roll_call_full, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_full_rollcall_votes.csv")
# THIS IS THE FINAL DATASET, above are JUST THOSE WITH > 2 VOTES.

# how many people voted on more than one bill
repeat_voters <- roll_call_full %>% dplyr::filter(Vote_count > 1)
# view(repeat_voters)
# 412 people repeatedly voted, out of 597


# how many people voted more than once and changed their votes
mind_changers <- roll_call_full %>% dplyr::filter(Vote_change > 0)
# view(mind_changers)
# 13 mind changers, only once, out of 412


# replicate Strattmann table
# find how many voted + on all bills
repeat_voters_plus <- repeat_voters %>% dplyr::filter(Vote.114 == "+" & Vote.115 == "+" & Vote.116 == "+")
# view(repeat_voters_plus)
# 136 people voted + on all bills

# find how many voted - on all bills
repeat_voters_minus <- repeat_voters %>% dplyr::filter(Vote.114 == "-" & Vote.115 == "-" & Vote.116 == "-")
# view(repeat_voters_minus)
# 125 voted - on all bills

# find how many voted + and then - from vote changers (then mark which bill)
# 1 person voted + and then - on 2 bills

# find how many voted - and then + from vote changers (then mark which bill)
# 12 persons voted - and then + on the bills


# merge unique ID with rollcall data
id_reps <- suppressMessages(read_csv("data/cleaned_unique_id_reps_copy.csv", show_col_types = FALSE))


# remove index column, rename Member ID to member_id
id_reps <- subset(id_reps, select = -...1)
id_reps <- id_reps %>%
    rename(member_id = `Member ID`)

# view(id_reps)


# to merge with fuzzy join, we also include the party and states, for that we need to include the abbreviations of the states
state_abbreviations <- suppressMessages(read_csv("data/state_abbreviations.csv", show_col_types = FALSE))
# view(state_abbreviations)

# change State column to include only abbreviations of respective states
for (i in 1:nrow(id_reps)) {
    if (!is.na(id_reps$State[i]) && nchar(id_reps$State[i]) > 2) {
        state <- id_reps$State[i]
        matching_postal <- state_abbreviations$Postal[state_abbreviations$State == state]
        if (length(matching_postal) > 0) {
            id_reps$State[i] <- matching_postal[1]
        }
    }
}
# view(id_reps)

# now turn party into abbreviations
for (i in 1:nrow(id_reps)) {
    if (id_reps$Party[i] == "Democratic") {
        id_reps$Party[i] <- "D"
    }
    if (id_reps$Party[i] == "Republican") {
        id_reps$Party[i] <- "R"
    }
    if (id_reps$Party[i] == "Independent") {
        id_reps$Party[i] <- "I"
    }
}


# MERGE WITH FUZZY JOIN
# create function that returns True or False, if distance between two strings is less than 3
fuzzy_match <- function(x, y, max_dist = 3) {
    return(stringdist::stringdist(x, y) <= max_dist)
}

fuzzy_match_last <- function(x, y) {
    return(fuzzy_match(x, y, 1))
}
fuzzy_match_first <- function(x, y) {
    return(fuzzy_match(x, y, 3))
}

# view(roll_call_full)
# view(id_reps)

# try fuzzy join
fuzzy_dataset <- fuzzy_left_join(roll_call_full, id_reps,
    by = c("LastName", "FirstName", "State", "Party"), match_fun = list(fuzzy_match_last, fuzzy_match_first, `==`, `==`)
)
# if i remove the functions : fuzzy_match_last, fuzzy_match_first, then it works, because only takes as many functions as there are columns to join on.

# relocate cols
fuzzy_dataset <- relocate(fuzzy_dataset, LastName.y, .after = LastName.x)
fuzzy_dataset <- relocate(fuzzy_dataset, FirstName.y, .after = FirstName.x)

view(fuzzy_dataset)
# 614 rows -> 17 more than roll_call_full

# write df as csv
write.csv(roll_call_full, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_vote_change_full_rollcall_votes.csv")

# if LastName.x, FirstName.x, State.x, Party.x are not equal to LastName.y, FirstName.y, State.y, Party.y, then remove these columns for row i.


non_matches <- function(dataset) {
    count <- 0
    df <- data.frame()
    for (i in 1:nrow(dataset)) {
        row <- dataset[i, ]
        for (i in 1:nrow(row)) {
            if (!is.na(row$LastName.x) && !is.na(row$LastName.y) && !is.na(row$FirstName.x) && !is.na(row$FirstName.y)) {
                if (row$LastName.x != row$LastName.y && row$FirstName.x != row$FirstName.y) {
                    count <- count + 1
                    df <- rbind(df, row[i])
                }
            }
        }
    }
    return(df)
}
nr_non_matched <- non_matches(fuzzy_dataset)
# view(nr_non_matched)


# current dataset is correct, but need to remove duplicated rows and duplicated rows
remove_duplicated <- function(dataset) {
    for (i in 1:nrow(dataset)) {
        row <- dataset[i, ]
        next_row <- dataset[i + 1, ]
        if (!is.na(row$LastName.x) && !is.na(row$LastName.y) && !is.na(row$FirstName.x) && !is.na(row$FirstName.y) && !is.na(next_row$LastName.x) && !is.na(next_row$LastName.y) && !is.na(next_row$FirstName.x) && !is.na(next_row$FirstName.y)) {
            if (row$LastName.x == next_row$LastName.x && row$FirstName.x == next_row$FirstName.x && row$State.x == next_row$State.x && row$Party.x == next_row$Party.x) {
                dataset <- dataset[-i, ]
            }
        }
    }
    return(dataset)
}
# before 602 rows
fuzzy_dataset <- remove_duplicated(fuzzy_dataset)
# view(fuzzy_dataset)
# now has 597 rows -> done

# remove all .y cols
fuzzy_dataset <- select(fuzzy_dataset, -c(contains(".y")))
fuzzy_dataset <- fuzzy_dataset %>%
    rename("LastName" = "LastName.x") %>%
    rename("FirstName" = "FirstName.x") %>%
    rename("Party" = "Party.x") %>%
    rename("State" = "State.x")


view(fuzzy_dataset)
# before 602, now 597


cleaned_roll_call <- fuzzy_dataset
# view(cleaned_roll_call)

write.csv(cleaned_roll_call, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_roll_call_final.csv")
