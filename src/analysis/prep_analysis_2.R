library(tidyverse)
library(fastDummies)
library(ggplot2)
library(glue)

source("src/analysis/analysis_prep_functions.R")
df <- read.csv("data/cleaned/df.csv")

# remove representatives who voted only once, whose party isnt R,D,
df <- analysis_prep(df)

view(df)

# filter for each session
df_vote_3 <- filter_session_data_2(df, 3)

# dry...
df_vote_3 <- df_vote_3 %>% filter(!is.na(Vote3))
df_vote_3 <- dummy_cols(df_vote_3, select_columns = "Vote3")
df_vote_3 <- df_vote_3 %>% rename("Vote3_plus" = "Vote3_+")
df_vote_3 <- df_vote_3 %>% rename("Vote3_minus" = "Vote3_-")

df_vote_4 <- filter_session_data_2(df, 4)

df_vote_4 <- df_vote_4 %>% filter(!is.na(Vote4))
df_vote_4 <- dummy_cols(df_vote_4, select_columns = "Vote4")
df_vote_4 <- df_vote_4 %>% rename("Vote4_plus" = "Vote4_+")
df_vote_4 <- df_vote_4 %>% rename("Vote4_minus" = "Vote4_-")

df_vote_51 <- filter_session_data_2(df, 51)
df_vote_51 <- df_vote_51 %>% filter(!is.na(Vote51))
df_vote_51 <- dummy_cols(df_vote_51, select_columns = "Vote51")
df_vote_51 <- df_vote_51 %>% rename("Vote51_plus" = "Vote51_+")

df_vote_52 <- filter_session_data_2(df, 52)
df_vote_52 <- df_vote_52 %>% filter(!is.na(Vote52))
df_vote_52 <- dummy_cols(df_vote_52, select_columns = "Vote52")
df_vote_52 <- df_vote_52 %>% rename("Vote52_plus" = "Vote52_+")

df_vote_6 <- filter_session_data_2(df, 6)

df_vote_6 <- df_vote_6 %>% filter(!is.na(Vote6))
df_vote_6 <- dummy_cols(df_vote_6, select_columns = "Vote6")
df_vote_6 <- df_vote_6 %>% rename("Vote6_plus" = "Vote6_+")
df_vote_6 <- df_vote_6 %>% rename("Vote6_minus" = "Vote6_-")

df_vote_7 <- filter_session_data_2(df, 7)

df_vote_7 <- df_vote_7 %>% filter(!is.na(Vote7))
df_vote_7 <- dummy_cols(df_vote_7, select_columns = "Vote7")
df_vote_7 <- df_vote_7 %>% rename("Vote7_plus" = "Vote7_+")
df_vote_7 <- df_vote_7 %>% rename("Vote7_minus" = "Vote7_-")

# view(df_vote_3)
# out of 802, only 553 remain


# get all reps who voted only pos. or only neg. and regress with all contributions
df_no_change <- df %>% filter(Vote_change_dummy == 0)
df_no_change$"all_votes" <- 0
# create a col that indicates if the rep voted all pos or neg. votes
for (i in 1:nrow(df_no_change)) {
    if (!is.na(any(df_no_change[i, c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")] == "+"))) {
        df_no_change[i, "all_votes"] <- "+"
    } else if (!is.na(any(df_no_change[i, c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")] == "-"))) {
        df_no_change[i, "all_votes"] <- "-"
    }
}

df_no_change <- dummy_cols(df_no_change, select_columns = "all_votes")
df_no_change <- df_no_change %>% rename("all_votes_plus" = "all_votes_+")
df_no_change <- df_no_change %>% rename("all_votes_minus" = "all_votes_-")
df_no_change <- df_no_change %>% select(-c(
    all_votes, Vote_change_dummy, Vote_change, Vote_count,
    Vote3, Vote4, Vote51, Vote52, Vote6, Vote7, BioID, GovtrackID, opensecrets_id,
    first_name, last_name, name.x, name.y
))

# create df for subsample analysis
df_sub <- df %>% dplyr::filter(Vote_change_dummy == 1)
view(df_sub)




write.csv(df, "data/analysis/df.csv", row.names = FALSE)
write.csv(df_no_change, "data/analysis/df_no_change.csv", row.names = FALSE)
write.csv(df_vote_3, "data/analysis/df_vote_3.csv", row.names = FALSE)
write.csv(df_vote_4, "data/analysis/df_vote_4.csv", row.names = FALSE)
write.csv(df_vote_51, "data/analysis/df_vote_51.csv", row.names = FALSE)
write.csv(df_vote_52, "data/analysis/df_vote_52.csv", row.names = FALSE)
write.csv(df_vote_6, "data/analysis/df_vote_6.csv", row.names = FALSE)
write.csv(df_vote_7, "data/analysis/df_vote_7.csv", row.names = FALSE)
write.csv(df_sub, "data/analysis/df_sub.csv", row.names = FALSE)
