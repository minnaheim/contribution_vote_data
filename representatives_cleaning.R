# this dataset serves to clean the list of all representatives in the house sessions 114, 115 and 116, so that we have a complete list of financial contributions (also with members who did not receive fin. contributions)
# setup

library(tidyverse)
library(dplyr)

# import data
rep_114 <- read_csv("data/representatives_114_manual.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/representatives_115.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/representatives_116.csv", show_col_types = FALSE)

# multiple parsing issues appear, need to clean data
trimws(rep_114)
trimws(rep_115)
trimws(rep_116)

# create colnames
colnames(rep_114) <- c("LastName", "FirstName", "State", "Party", "Chamber")
colnames(rep_115) <- c("LastName", "FirstName", "State", "Party", "Chamber")
colnames(rep_116) <- c("LastName", "FirstName", "State", "Party", "Chamber")
# view(rep_114)

# remove senate members
rep_114 <- rep_114 %>% dplyr::filter(Chamber != "Senate")
rep_115 <- rep_115 %>% dplyr::filter(Chamber != "Senate")
rep_116 <- rep_116 %>% dplyr::filter(Chamber != "Senate")

# find number of rows for rep_114
# print(nrow(rep_114))
# [1] 437 -> that incl. header...

# view(rep_114)

# write csv
write.csv(rep_114, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_representatives_114.csv")
write.csv(rep_115, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_representatives_115.csv")
write.csv(rep_116, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_representatives_116.csv")

# view(rep_116)

# import datasets master_df_114, etc.
master_df_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/master_df_114.csv", show_col_types = FALSE)
# view(master_df_114)
view(rep_114)
# print(nrow(master_df_114))
# [1] 439 -> rep_114 had 437, also header


# merge

# all_reps_contributions <- full_join(master_df_114, rep_114["LastName", "FirstName"], by = c("LastName", "FirstName"))
# view(all_reps_contributions)

all_reps_contributions <- full_join(master_df_114, rep_114[, c("LastName", "FirstName")], by = c("LastName", "FirstName"))

# view(all_reps_contributions)

# 507 reps, something probably isnt right, ill clean the new df more
all_reps_contributions <- subset(all_reps_contributions, select = -...1)

# check how many people have the same last names
all_reps_contributions <- all_reps_contributions %>%
    group_by(LastName, FirstName) %>%
    mutate(dupe = n() > 1)

# all dupe = FALSE

# find all duplicates of  First & LastName
# 48 duplicates in LastName
# 207 duplicates in FIrst Name

duplicated_last_names <- duplicated(all_reps_contributions$LastName) | duplicated(all_reps_contributions$LastName, fromLast = TRUE)

# Subset the dataset to extract both original and duplicated rows based on last names
duplicated_rows_last_name <- all_reps_contributions[duplicated_last_names, ]

# Find duplicated first names
duplicated_first_names <- duplicated(all_reps_contributions$FirstName) | duplicated(all_reps_contributions$FirstName, fromLast = TRUE)

# Subset the dataset to extract both original and duplicated rows based on first names
duplicated_rows_first_name <- all_reps_contributions[duplicated_first_names, ]

# view(duplicated_rows_last_name)

# import and clean unique identifiers of representatives
# import data
rep_u_id <- read_csv("data/unique_id_reps.csv", show_col_types = FALSE)

trimws(rep_u_id)
# view(rep_u_id)

# most of the Party data is actually Party, but if not R,D, Independent or Libretarian, then add those rename col into Alias and put values R,D,I into new party col.
# create new column
rep_u_id["Alias"] <- NA

alias_finder <- function(dataset) {
    parties <- c("Republican", "Democratic", "Independent", "Libertarian")
    for (i in 1:nrow(dataset)) {
        if (!(dataset$Party[i] %in% parties)) {
            dataset[i, ]["Alias"] <- dataset$Party[i]
            dataset[i, ]["Party"] <- NA
        }
    }
    return(dataset)
}

rep_u_id <- alias_finder(rep_u_id)
# view(rep_u_id)

fix_na_and_shift <- function(data) {
    for (i in 1:nrow(data)) {
        # Check if there's NA in the Party column
        if (is.na(data[i, "Party"])) {
            # Move value from the next column to the Party column
            data[i, "Party"] <- data[i, "State"]
            data[i, "State"] <- data[i, "Member ID"]
            # remove everything after the first comma for the State column
            data[i, "State"] <- sub(",.*", "", data[i, "State"])
            # remove everything before the first comma for the Member ID column
            data[i, "Member ID"] <- sub("^(?:[^,]*,){1}", "", data[i, "Member ID"])
            if (is.na(data[i, "Party"])) {
                # Move value from the next column to the Party column
                data[i, "Party"] <- data[i, "State"]
                data[i, "State"] <- data[i, "Member ID"]
                # remove everything after the first comma for the State column
                data[i, "State"] <- sub(",.*", "", data[i, "State"])
                # remove everything before the first comma for the Member ID column
                data[i, "Member ID"] <- sub("^(?:[^,]*,){1}", "", data[i, "Member ID"])
            }
        }
    }
    return(data)
}

# view(rep_u_id)
fixed_data <- fix_na_and_shift(rep_u_id)

# Print the fixed data
# view(fixed_data)


# write csv
write.csv(fixed_data, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_unique_id_reps.csv")
