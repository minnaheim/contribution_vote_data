library(tidyverse)
# install.packages("conflicted")
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

# create dataset for analysis (with at least two votes)

# dataset which includes representatives who voted on at least 2 of the 3 bills
repeated_votes <- roll_call_114_115_116_full %>%
    dplyr::filter(!is.na(Vote.114) & !is.na(Vote.115) | !is.na(Vote.115) & !is.na(Vote.116) | !is.na(Vote.114) & !is.na(Vote.116))

# create index column
repeated_votes$ID <- 1:nrow(repeated_votes)

# put ID col as the first column
repeated_votes <- repeated_votes %>%
    relocate(ID)

# dataset which includes representatives who voted on >2 occasions and no n/a, ? or E

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

roll_call_votes <- count_votes(repeated_votes)
roll_call_114_115_116_full <- count_votes(roll_call_114_115_116_full)
# view(roll_call_114_115_116_full)
# view(repeated_votes)
# -> why only 424 people?

# remove second index column
roll_call_votes <- subset(roll_call_votes, select = -ID)

# if n/a values of ? values in dataset, mark as NA

roll_call_114_115_116_full <- roll_call_114_115_116_full %>%
    mutate(
        Vote.114 = ifelse(Vote.114 == "?" | Vote.114 == "n/a", NA, Vote.114),
        Vote.115 = ifelse(Vote.115 == "?" | Vote.115 == "n/a", NA, Vote.115),
        Vote.116 = ifelse(Vote.116 == "?" | Vote.116 == "n/a", NA, Vote.116)
    )

# view(roll_call_114_115_116_full)


# find representatives in roll_call_114_115_116_full who changed their votes from + to - or vice versa, and count number of changes

# create new column
roll_call_114_115_116_full["Vote_change"] <- 0

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
vote_change_roll_call <- count_vote_changes(roll_call_114_115_116_full)
view(vote_change_roll_call)

# write df as csv
write.csv(roll_call_114_115_116_full, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_full_rollcall_votes.csv")
# THIS IS THE FINAL DATASET, above are JUST THOSE WITH > 2 VOTES.

# how many people voted on more than one bill
repeat_voters <- vote_change_roll_call %>% dplyr::filter(Vote_count > 1)
# view(repeat_voters)
# 412 people repeatedly voted, out of 597


# how many people voted more than once and changed their votes
mind_changers <- vote_change_roll_call %>% dplyr::filter(Vote_change > 0)
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
