library(tidyverse)
source("src/cleaning/utils/party_abbreviation.R")
source("src/cleaning/utils/state_abbreviation.R")
source("src/cleaning/utils/rep_cleaning_functions.R")

# new unique id cleaning with tsv
uid_df <- read_delim("data/original/uid_reps.tsv", show_col_types = FALSE) %>%
    mutate(
        party = str_extract(Member, "(?<=\\()[^-\\s)]+"),
        state = str_extract(Member, "(?<=-\\s)[^\\)]+"),
        member = str_remove(Member, "\\s*\\([^\\)]+\\)"),
        last_name = str_extract(member, "[^,]+"),
        first_name = str_extract(member, "(?<=,)[^,]+"),
    ) %>%
    rename(member_id = "Member ID")
# view(uid_df)

# in about 20 rows, there are middle names in the party col
# select columns which have middle names in party
incorrect_df <- uid_df %>% filter(!(party %in% c("Democratic", "Republican", "Libertarian", "Independent")))
# view(incorrect_df)

incorrect_df <- incorrect_df %>%
    rename(alias = party, ) %>%
    mutate(
        party = str_extract(member, "(?<=\\()[^-\\s)]+"),
        state = str_extract(member, "(?<=-\\s)[^\\)]+"),
        first_name = str_remove(first_name, "\\(.*")
    )

# view(incorrect_df)


uid_df["alias"] <- NA
# filter out the rows from uid_df where MemberID is in incorrect_df
uid_df <- uid_df %>% filter(!(member_id %in% incorrect_df$member_id))
# concatenate the two dataframes
uid_df <- rbind(uid_df, incorrect_df)

# remove member col
uid_df <- uid_df %>% select(-Member)
# view(uid_df)

# write csv
write.csv(uid_df, "data/cleaned/unique_id_reps.csv", row.names = FALSE)
