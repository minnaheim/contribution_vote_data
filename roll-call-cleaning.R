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

view(methane_116)
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
# inner join dataset
roll_call_114_115 <- inner_join(methane_114, methane_115, by = "Representative", suffix = c(".114", ".115"))
roll_call_114_115_116 <- inner_join(roll_call_114_115, methane_116, by = "Representative", suffix = c(".114.115", ".116"))

# full join dataset
roll_call_114_115_full <- full_join(methane_114, methane_115, by = "Representative", suffix = c(".114", ".115"))
roll_call_114_115_116_full <- full_join(roll_call_114_115_full, methane_116, by = "Representative", suffix = c(".114.115", ".116"))

# rename columns of Party, District and Vote, add suffix .116
roll_call_114_115_116_full <- roll_call_114_115_116_full %>%
    rename(Party.116 = Party, District.116 = District, Vote.116 = Vote)


# split Representative Column into LastName and FirstName

roll_call_114_115_116_full <- extract(roll_call_114_115_116_full, Representative, c("LastName", "FirstName"), "([^,]+), *(.+)")
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
view(roll_call_114_115_116_full)
# view(repeated_votes)
# -> why only 424 people?

# remove second index column
roll_call_votes <- subset(roll_call_votes, select = -ID)

# str(repeated_votes)
# roll_call_votes <- roll_call_votes  %>% dplyr::filter(repeated_votes$Vote_count >= 2)
view(roll_call_votes)
view(repeated_votes)

# write df as csv
write.csv(roll_call_114_115_116_full, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_full_rollcall_votes.csv")
# THIS IS THE FINAL DATASET, above are JUST THOSE WITH > 2 VOTES.
