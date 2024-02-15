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

# inspect datasets

# view(methane_114)
# view(methane_115)
# view(methane_116)

# create merged dataset - merge based on representative (votes)

# try with sample dataset
sample_114 <- methane_114[1:10, ]
sample_115 <- methane_115[1:10, ]
sample_116 <- methane_116[1:10, ]

# full join sample dataset
sample_merge_full <- full_join(sample_114, sample_115, by = "Representative", suffix = c(".114", ".115"))
# inner join sample dataset
sample_merge_inner <- inner_join(sample_114, sample_115, by = "Representative", suffix = c(".114", ".115"))

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

# view(roll_call_114_115_116_full)


# dataset which includes representatives who voted on at least 2 of the 3 bills
repeated_votes <- roll_call_114_115_116_full %>%
    filter(!is.na(Vote.114) & !is.na(Vote.115) | !is.na(Vote.115) & !is.na(Vote.116) | !is.na(Vote.114) & !is.na(Vote.116))
# view(repeated_votes)

# dataset which includes representatives who voted on >2 occasions and no n/a, ? or E
sample_dataset <- repeated_votes[8:9, ]
# view(sample_dataset)

determine_present_n_voting <- function(roll_call_dataset) {
    for (i in roll_call_dataset) {
        print(i)
        # for (j in i) {
        #     if (is.na(j) == TRUE) {
        #         print("NA in this obs")
        #     } else {
        #         print("no NA in this obs")
        #     }
        # }
    }
}

determine_present_n_voting(sample_dataset)

# determine mind changers
