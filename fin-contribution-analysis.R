# SET UP
library(tidyverse)
library(ggplot2)

# IMPORT DATASETS
contribution_for_114 <- read_csv("data/oil_gas_contribution-2013-2014.csv",
    show_col_types = FALSE
)
contribution_for_115 <- read_csv("data/oil_gas_contribution-2015-2016.csv",
    show_col_types = FALSE
)
contribution_for_116 <- read_csv("data/oil_gas_contribution-2017-2018.csv",
    show_col_types = FALSE
)

# data with all politicians of this term (not only those who received contribution)
rep_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/term-114.csv", show_col_types = FALSE)
rep_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/term-115.csv", show_col_types = FALSE)
rep_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/term-116.csv", show_col_types = FALSE)


# CLEAN DATA
# 114th Congress
# remove $ and transform to numeric
contribution_for_114$Amount <- as.numeric(sub("\\$", "", contribution_for_114$Amount))

# separate political affiliation, in () into new column.
contribution_for_114$Party <- gsub(".*\\((.*?)\\).*", "\\1", contribution_for_114$Representative)

contribution_for_114$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", contribution_for_114$Representative)

# split the representatives column of contribution _144 into the columns LastName and FirstName.
contribution_for_114 <- extract(contribution_for_114, Representative, c("LastName", "FirstName"), "([^ ]+) (.*)")

# split Party and state-abbreviation into separate columns.
contribution_for_114 <- separate(contribution_for_114, Party, into = c("Party", "StateAbbreviation"), sep = "-")

# relocate Party and StateAbbreviation columns to after Names
contribution_for_114 <- contribution_for_114 %>% relocate(Party, StateAbbreviation, .after = FirstName)

view(contribution_for_114)

# 115th Congress
# remove $ and transform to numeric
contribution_for_115$Amount <- as.numeric(sub("\\$", "", contribution_for_115$Amount))

# separate political affiliation, in () into new column.
contribution_for_115$Party <- gsub(".*\\((.*?)\\).*", "\\1", contribution_for_115$Representative)

contribution_for_115$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", contribution_for_115$Representative)

# split the representatives column of contribution _144 into the columns LastName and FirstName.
contribution_for_115 <- extract(contribution_for_115, Representative, c("LastName", "FirstName"), "([^ ]+) (.*)")

# split Party and state-abbreviation into separate columns.
contribution_for_115 <- separate(contribution_for_115, Party, into = c("Party", "StateAbbreviation"), sep = "-")

# relocate Party and StateAbbreviation columns to after Names
contribution_for_115 <- contribution_for_115 %>% relocate(Party, StateAbbreviation, .after = FirstName)


# 116th Congress
# remove $ and transform to numeric
contribution_for_116$Amount <- as.numeric(sub("\\$", "", contribution_for_116$Amount))

# separate political affiliation, in () into new column.
contribution_for_116$Party <- gsub(".*\\((.*?)\\).*", "\\1", contribution_for_116$Representative)

contribution_for_116$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", contribution_for_116$Representative)

# split the representatives column of contribution _144 into the columns LastName and FirstName.
contribution_for_116 <- extract(contribution_for_116, Representative, c("LastName", "FirstName"), "([^ ]+) (.*)")

# split Party and state-abbreviation into separate columns.
contribution_for_116 <- separate(contribution_for_116, Party, into = c("Party", "StateAbbreviation"), sep = "-")

# relocate Party and StateAbbreviation columns to after Names
contribution_for_116 <- contribution_for_116 %>% relocate(Party, StateAbbreviation, .after = FirstName)

view(contribution_for_114)
view(contribution_for_115)
view(contribution_for_116)


# clean rep dataset, split sort_name by ,
rep_114[c("Last", "First")] <- str_split_fixed(rep_114$sort_name, ",", 2)

# select only important cols
rep_114 <- rep_114 %>% select(Last, First, group_id, area_id, )
view(rep_114)

# repeat for 115 and 116th congress
rep_115[c("First", "Last")] <- str_split_fixed(rep_115$sort_name, ",", 2)
rep_115 <- rep_115 %>% select(Last, First, group_id, area_id, )

rep_116[c("First", "Last")] <- str_split_fixed(rep_116$sort_name, ",", 2)
rep_116 <- rep_116 %>% select(Last, First, group_id, area_id, )



# in the oil_gas_contribution.csv, only those house reps. are shown, which have received contributions, i.e. we need to add in non-listed members, and their amounts = 0

# merge sample dataset
sample_rep_114 <- rep_114[309:310, ]
sample_rep_115 <- rep_115[1:10, ]
# view(rep_114)

sample_contribution_for_114 <- contribution_for_114[7:8, ]
# view(sample_contribution_for_114)

# view(sample_contribution_114)

merged_sample_rep_114 <- full_join(sample_contribution_for_114, sample_rep_114, by = c("LastName" = "Last"))
# view(merged_sample_rep_114)


# create merge function, that merges based on Lastname, and only keeps if firstname = first.

merged <- function(reps, contribution) {
    merge_last <- full_join(contribution, reps, by = c("LastName" = "Last"))
    view(merge_last)
    for (i in 1:nrow(merge_last)) {
        if (is.na(merge_last[i, ]$First)) {
            final_merge <- merge_last[-i, ]
        } else if (is.na(merge_last[i, ]$FirstName)) {
            final_merge <- merge_last[-i, ]
        } else {
            print(i)
            print("first and last name coincide")
        }
    }
    return(final_merge)
}

# merged_first_last <- merged(sample_rep_114, sample_contribution_for_114)
# view(merged_first_last)

sample_rep_115 <-
    full_contribution_115 <- full_join(contribution_for_115, rep_115, by = c("FirstName" = "First", "LastName" = "Last"))
# view(sample_rep_115)

# create master dataset, join by representative.
master_contribution <- contribution_for_114 %>% full_join(contribution_for_115,
    by = c("LastName", "FirstName"),
    suffix = c(".114", ".115")
)
# view(master_contribution)

master_contribution_1 <- master_contribution %>% full_join(contribution_for_116,
    by = c("LastName", "FirstName"),
    suffix = c(".114.115", ".116")
)

master_contribution_1 <- master_contribution_1 %>%
    rename(Party.116 = Party, StateAbbreviation.116 = StateAbbreviation, State.116 = State, Amount.116 = Amount)

# view(master_contribution_1)

# in total, the master dataset has 552 rows. aka 435 per Session = 1305 persons (since we only have 552 though, this means that most overlap)

# create a column called count_contribution




#
