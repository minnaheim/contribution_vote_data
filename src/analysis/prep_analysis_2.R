library(tidyverse)
library(fastDummies)
library(ggplot2)
library(glue)

source("src/analysis/analysis_prep_functions.R")
df <- read.csv("data/cleaned/df.csv")


# remove representatives who voted only once, whose party isnt R,D,
df <- analysis_prep(df)
# view(df)

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
df_vote_51 <- df_vote_51 %>% rename("Vote51_minus" = "Vote51_-")

df_vote_52 <- filter_session_data_2(df, 52)
df_vote_52 <- df_vote_52 %>% filter(!is.na(Vote52))
df_vote_52 <- dummy_cols(df_vote_52, select_columns = "Vote52")
df_vote_52 <- df_vote_52 %>% rename("Vote52_minus" = "Vote52_-")
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
    first_name, last_name, name
))

# create df for subsample analysis (incl. fixed effects)
df_fe <- df %>% dplyr::filter(Vote_change_dummy == 1)
view(df_fe)
df_fe$vote_change_type <- apply(df_fe[, vote_columns], 1, detect_changes)
df_fe <- df_fe %>% relocate(vote_change_type, .after = Vote_change)
df_fe$vote_change_year <- apply(df_fe[, vote_columns], 1, detect_year_of_changes)
df_fe <- df_fe %>% relocate(vote_change_year, .after = vote_change_type)
df_fe$first_vote <- apply(df_fe[, vote_columns], 1, base_year)
df_fe$first_contribution_minus <- apply(df_fe, 1, first_contribution_minus)
df_fe$first_contribution_plus <- apply(df_fe, 1, first_contribution_plus)
df_fe <- df_fe %>%
    # Convert to long format by splitting 'vote_change_type' and 'vote_change_year' strings into multiple rows
    separate_rows(vote_change_type, vote_change_year, sep = ",") %>%
    # Optionally, you can trim whitespace if necessary
    mutate(
        vote_change_type = trimws(vote_change_type),
        vote_change_year = trimws(vote_change_year)
    )
# relocate cols
df_fe <- relocate(df_fe, "first_vote", .after = "vote_change_year")
df_fe$vote_change_type <- as.numeric(df_fe$vote_change_type)
df_fe <- df_fe %>% mutate(year = str_extract(vote_change_year, "(?<=-).*"))
df_sub <- relocate(df_fe, "year", .after = vote_change_year)

# create dummy for vote change... 1 or 0 vote!! > von + -> - = 0, von - -> + = 1 (manually, use package for this)
df_sub$vote_change_to_pro <- df_sub$vote_change_type
df_sub$vote_change_to_pro[df_sub$vote_change_to_pro == 1] <- 1
df_sub$vote_change_to_anti <- df_sub$vote_change_type
df_sub$vote_change_to_anti[df_sub$vote_change_type == 0] <- 1
df_sub$vote_change_to_anti[df_sub$vote_change_type == 1] <- 0
df_sub <- relocate(df_sub, vote_change_to_pro, .after = vote_change_type)
df_sub <- relocate(df_sub, vote_change_to_anti, .after = vote_change_to_pro)

view(df_sub)

# create person fixed effects df.



write.csv(df, "data/analysis/df.csv", row.names = FALSE)
write.csv(df_no_change, "data/analysis/df_no_change.csv", row.names = FALSE)
write.csv(df_vote_3, "data/analysis/df_vote_3.csv", row.names = FALSE)
write.csv(df_vote_4, "data/analysis/df_vote_4.csv", row.names = FALSE)
write.csv(df_vote_51, "data/analysis/df_vote_51.csv", row.names = FALSE)
write.csv(df_vote_52, "data/analysis/df_vote_52.csv", row.names = FALSE)
write.csv(df_vote_6, "data/analysis/df_vote_6.csv", row.names = FALSE)
write.csv(df_vote_7, "data/analysis/df_vote_7.csv", row.names = FALSE)
write.csv(df_sub, "data/analysis/df_sub.csv", row.names = FALSE)
