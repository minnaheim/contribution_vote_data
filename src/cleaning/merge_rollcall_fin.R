# this doc serves to merge all roll call data and the financial data

# set up
library(tidyverse)
# install.packages("fuzzyjoin", repos = "https://stat.ethz.ch/CRAN/")
library(fuzzyjoin)
# install.packages("stringdist", repos = "https://stat.ethz.ch/CRAN/")
library(stringdist)

# import rollcall data
roll_call <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_full_rollcall_votes.csv", show_col_types = FALSE)
# import financial data
contributions <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/all_reps_contribution.csv", show_col_types = FALSE)

# remove indices columns
roll_call <- subset(roll_call, select = -...1)
view(roll_call)

view(contributions)
# rows 601


# remove duplicates of rows in all all_reps_contributions datasets
all_reps_contributions <- distinct(contributions)
view(contributions)


# merge datasets
master_dataset <- full_join(contributions, roll_call, by = c("LastName", "FirstName"))

# change all District(.114) cols into StateAbbreviation(.114) cols, discard 2nd
master_dataset <- master_dataset %>%
    mutate(District.114 = str_extract(District.114, "^([A-Z]+)")) %>%
    mutate(District.115 = str_extract(District.115, "^([A-Z]+)")) %>%
    mutate(District.116 = str_extract(District.116, "^([A-Z]+)"))

master_dataset <- master_dataset %>%
    rename("StateAbbreviation.114" = "District.114") %>%
    rename("StateAbbreviation.115" = "District.115") %>%
    rename("StateAbbreviation.116" = "District.116")

roll_call <- roll_call %>%
    mutate(District.114 = str_extract(District.114, "^([A-Z]+)")) %>%
    mutate(District.115 = str_extract(District.115, "^([A-Z]+)")) %>%
    mutate(District.116 = str_extract(District.116, "^([A-Z]+)"))

roll_call <- roll_call %>%
    rename("StateAbbreviation.114" = "District.114") %>%
    rename("StateAbbreviation.115" = "District.115") %>%
    rename("StateAbbreviation.116" = "District.116")

# view(roll_call)

# create function that returns True or False, if distance between two strings is less than 3
fuzzy_match <- function(x, y, max_dist = 3) {
    return(stringdist::stringdist(x, y) <= max_dist)
}

fuzzy_match_last <- function(x, y) {
    return(fuzzy_match(x, y, 2))
}
fuzzy_match_first <- function(x, y) {
    return(fuzzy_match(x, y, 4))
}

# try fuzzy join
fuzzy_dataset <- fuzzy_full_join(contributions, roll_call,
    by = c("LastName", "FirstName", c("StateAbbreviation.x.114" = "StateAbbreviation.114"), c("Party.x.114" = "Party.114")), match_fun = list(fuzzy_match_last, fuzzy_match_first, `==`, `==`)
)

# move columns LastName.y and FirstName.y to be next to  LastName.x and FirstName.x
fuzzy_dataset <- fuzzy_dataset %>%
    relocate(LastName.y, .after = LastName.x) %>%
    relocate(FirstName.y, .after = FirstName.x)




# view(fuzzy_dataset)

# fuzzy_full_join(x,y,by=c('id'='id','time'='time'),match_fun=list(`==`,`==`)) %>%
#   mutate(id=coalesce(id.x, id.y), time = coalesce(time.x, time.y)) %>%
#   select(-matches('\\.x$|\\.y$'))


# include if Party,114 not include, add from...
# If Party and StateAbbreviation are missing in oil_candidates_114, use values from coal_candidates_114
# 114
master_dataset$Party.x.114 <- ifelse(is.na(master_dataset$Party.x.114), master_dataset$Party.114, master_dataset$Party.x.114)

master_dataset$StateAbbreviation.x.114 <- ifelse(is.na(master_dataset$StateAbbreviation.x.114), master_dataset$StateAbbreviation.114, master_dataset$StateAbbreviation.x.114)

# Remove redundant columns
master_dataset <- master_dataset %>% select(-Party.114, -StateAbbreviation.114)

# move columns before Amounts
master_dataset <- master_dataset %>%
    relocate(StateAbbreviation.x.114, .after = FirstName) %>%
    relocate(Party.x.114, .after = StateAbbreviation.x.114)

# 115
master_dataset$Party.x.114 <- ifelse(is.na(master_dataset$Party.x.114), master_dataset$Party.115, master_dataset$Party.x.114)

master_dataset$StateAbbreviation.x.114 <- ifelse(is.na(master_dataset$StateAbbreviation.x.114), master_dataset$StateAbbreviation.115, master_dataset$StateAbbreviation.x.114)

# Remove redundant columns
master_dataset <- master_dataset %>% select(-Party.115, -StateAbbreviation.115)

# move columns before Amounts
master_dataset <- master_dataset %>%
    relocate(StateAbbreviation.x.114, .after = FirstName) %>%
    relocate(Party.x.114, .after = StateAbbreviation.x.114)

# 116
master_dataset$Party.x.114 <- ifelse(is.na(master_dataset$Party.x.114), master_dataset$Party.116, master_dataset$Party.x.114)

master_dataset$StateAbbreviation.x.114 <- ifelse(is.na(master_dataset$StateAbbreviation.x.114), master_dataset$StateAbbreviation.116, master_dataset$StateAbbreviation.x.114)

# Remove redundant columns
master_dataset <- master_dataset %>% select(-Party.116, -StateAbbreviation.116)

# move columns before Amounts
master_dataset <- master_dataset %>%
    relocate(StateAbbreviation.x.114, .after = FirstName) %>%
    relocate(Party.x.114, .after = StateAbbreviation.x.114)


# filter out non-voting members
master_dataset <- master_dataset %>%
    dplyr::filter(StateAbbreviation.x.114 != "GU") %>%
    dplyr::filter(StateAbbreviation.x.114 != "PR") %>%
    dplyr::filter(StateAbbreviation.x.114 != "VI") %>%
    dplyr::filter(StateAbbreviation.x.114 != "American Samoa") %>%
    dplyr::filter(StateAbbreviation.x.114 != "DC") %>%
    dplyr::filter(StateAbbreviation.x.114 != "MP")

# view(master_dataset)
# works till here

# in some cases, two people are called differently in rollcall and financial contributions, e.g. Jeff and Jeffree, merge into one

# view(master_dataset)

# merge_representatives <- function(data) {
#     data %>%
#         group_by(StateAbbreviation.x.114, Party.x.114) %>%
#         group_map(~ {
#             dist_first <- stringdistmatrix(.x$FirstName, .x$FirstName)
#             dist_last <- stringdistmatrix(.x$LastName, .x$LastName)
#             keep_rows <- row_number(.x) == 1 | rowSums(dist_first <= 3 & dist_last <= 3) > 0
#             view(keep_rows)
#             if (any(keep_rows)) {
#                 view(.x)
#                 .x[keep_rows, ] %>%
#                     # group_by(LastName, FirstName, ) %>%
#                     mutate(
#                         across(
#                             .cols = !c(LastName, FirstName),
#                             ~ if_else(any(!is.na(.)), if_else(is.na(.), last(.[!is.na(.)]), .), .)
#                         )
#                     ) %>%
#                     distinct() %>%
#                     ungroup()
#             } else {
#                 NULL # Return NULL if no rows left in the group
#             }
#         }) %>%
#         bind_rows()
# }

# Assuming your dataset is named 'master_dataset'
# cleaned_data <- merge_representatives(master_dataset)

# merge_representatives <- function(master_df) {
#     # Find duplicated rows
#     # duplicated_rows <- master_df[duplicated(master_df[c("StateAbbreviation.x.114", "Party.x.114", "LastName", "FirstName")]), ]
#     # view(duplicated_rows)

#     # # Select only relevant columns from duplicated rows
#     # duplicated_cols <- duplicated_rows[, c("StateAbbreviation.x.114", "Party.x.114", "LastName", "FirstName", "Amount.oil.114", "Amount.coal.114", "Amount.mining.114", "Amount.gas.114", "Amount.env.114", "Amount.alt_en.114", "Amount.oil.115", "Amount.coal.115", "Amount.mining.115", "Amount.gas.115", "Amount.env.115", "Amount.alt_en.115", "Amount.oil.116", "Amount.coal.116", "Amount.mining.116", "Amount.gas.116", "Amount.env.116", "Amount.alt_en.116", "Vote.114", "Vote.115", "Vote.116", "Vote_count")]

#     # Perform fuzzy join
#     merged <- stringdist_full_join(master_df, master_df,
#         by = c("StateAbbreviation.x.114", "Party.x.114", "LastName", "FirstName"),
#         max_dist = 1
#     ) # Adjust the maximum distance as needed
#     view(merged)

#     # Replace NAs with values from duplicated columns
#     for (col in colnames(master_df)) {
#         if (col %in% colnames(duplicated_rows)) {
#             na_idx <- is.na(merged[[paste0(col, ".x")]])
#             merged[[paste0(col, ".x")]][na_idx] <- merged[[paste0(col, ".y")]][na_idx]
#         }
#     }

#     # Remove duplicated rows
#     merged <- merged[!duplicated(merged), ]

#     # Remove duplicated columns and unnecessary columns
#     merged <- merged[, !duplicated(colnames(merged))]

#     return(merged)
# }

# # Example usage
# # Assuming master_df is your master dataframe
# master_dataset <- merge_representatives(master_dataset)
# view(master_dataset)

# merge_representatives <- function(df) {
#     # grouped <- df %>%
#     #     dplyr::group_by(StateAbbreviation.x.114, Party.x.114, LastName, FirstLetter = substr(FirstName, 1, 1)) %>%
#     #     mutate(Count = n()) %>%
#     #     dplyr::filter(Count > 1) %>%
#     #     ungroup()

#     # Print the rows that need merging
#     duplicated <- data.frame(grouped)
#     # 295 duplicated
#     view(duplicated)

#     # remove duplicated from the original dataset


#     # Merge rows
#     merged <- grouped %>%
#         summarise_at(vars(FirstName, LastName, Party.x.114, StateAbbreviation.x.114, Amount.oil.114, Amount.coal.114, Amount.mining.114, Amount.gas.114, Amount.env.114, Amount.alt_en.114, Amount.oil.115, Amount.coal.115, Amount.mining.115, Amount.gas.115, Amount.env.115, Amount.alt_en.115, Amount.oil.116, Amount.coal.116, Amount.mining.116, Amount.gas.116, Amount.env.116, Amount.alt_en.116, Vote.114, Vote.115, Vote.116, Vote_count), function(x) {
#             na_idx <- which(is.na(x))
#             if (length(na_idx) > 0) {
#                 x[na_idx] <- x[which(!is.na(x))][1]
#             }
#             return(x[1])
#         })

#     # Print the merged rows
#     view(merged)
#     merged_duplicated <- data.frame(merged)
#     # view(merged_duplicated)

#     # Merge the merged rows with the original dataframe
#     df_merged <- merge(df, merged, by = c("StateAbbreviation.x.114", "Party.x.114", "LastName", "FirstName"), all.x = TRUE)
#     # view(df_merged)

#     return(df_merged)
# }

# # Example usage
# # Assuming df is your dataframe containing representatives and their votes
# master_dataset <- merge_representatives(master_dataset)

view(master_dataset)


# check if dataset is complete, by checking if amount....116 and vote.116 both not NA...
