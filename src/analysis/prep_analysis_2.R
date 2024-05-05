library(tidyverse)
library(fastDummies)
library(ggplot2)
library(glue)

source("src/analysis/analysis_prep_functions.R")
df <- read.csv("data/cleaned/df.csv")


# remove representatives who voted only once, whose party isnt R,D,
df <- analysis_prep(df)
# change vote to dummy vars
df <- dummy_vote(df)

# view(df)


# change birthdays to only include years, and group into decades
# why does lubridate not work?
df$birthday <- as.Date(df$birthday, format = "%Y-%m-%d")
df$birthday <- as.numeric(format(df$birthday, "%Y"))
# view(df)


# view(df)
# CONTROL VARIABLES
# add dummy for majority party leadership
df["Dmajority_3"] <- 0
df["Dmajority_4"] <- 0
df["Dmajority_51"] <- 0
df["Dmajority_52"] <- 0
df["Dmajority_6"] <- 1
df["Dmajority_7"] <- 1

# add state dummies (categorised acc. to US Census Data -> https://www2.census.gov/geo/pdfs/reference/GARM/Ch6GARM.pdf)
state_abbreviation <- read_csv("data/original/control_variables/state_abbreviations.csv", show_col_types = FALSE) %>%
    select(Postal, Geographical) %>%
    filter(!is.na(Geographical))

table(state_abbreviation$Geographical)

df["Geographical"] <- NA
add_state_category <- function(df) {
    for (i in seq_len(nrow(df))) {
        for (j in seq_len(nrow(state_abbreviation))) {
            if (df$state[i] == state_abbreviation$Postal[j]) {
                df$Geographical[i] <- state_abbreviation$Geographical[j]
            }
        }
    }
    return(df)
}
df <- add_state_category(df)
df <- df %>% dplyr::filter(!is.na(df$Geographical))


# dummy variable for pro and anti environmental contributions, i.e. has the person ever
# received any pro or anti environmental contributions?
df$pro_env_dummy <- "0"
df$anti_env_dummy <- "0"

for (i in 1:nrow(df)) {
    if (any(df[i, c(
        "Contribution_3_plus", "Contribution_4_plus", "Contribution_51_plus",
        "Contribution_52_plus", "Contribution_6_plus", "Contribution_7_plus"
    )] > 1, na.rm = TRUE)) {
        df$pro_env_dummy[i] <- 1
    }
    # Check if any contributions minus are greater than 1
    if (any(df[i, c(
        "Contribution_3_minus", "Contribution_4_minus", "Contribution_51_minus",
        "Contribution_52_minus", "Contribution_6_minus", "Contribution_7_minus"
    )] > 1, na.rm = TRUE)) {
        df$anti_env_dummy[i] <- 1
    }
}
view(df)


# pivot table longer
df_long <- df
df_long$seniority_115_2 <- df_long$seniority_115
df_long <- df_long %>%
    rename("seniority_3" = "seniority_113") %>%
    rename("seniority_4" = "seniority_114") %>%
    rename("seniority_51" = "seniority_115") %>%
    rename("seniority_52" = "seniority_115_2") %>%
    rename("seniority_6" = "seniority_116") %>%
    rename("seniority_7" = "seniority_117") %>%
    rename("Contribution_minus_3" = "Contribution_3_minus") %>%
    rename("Contribution_plus_3" = "Contribution_3_plus") %>%
    rename("Contribution_minus_4" = "Contribution_4_minus") %>%
    rename("Contribution_plus_4" = "Contribution_4_plus") %>%
    rename("Contribution_minus_51" = "Contribution_51_minus") %>%
    rename("Contribution_plus_51" = "Contribution_51_plus") %>%
    rename("Contribution_minus_52" = "Contribution_52_minus") %>%
    rename("Contribution_plus_52" = "Contribution_52_plus") %>%
    rename("Contribution_minus_6" = "Contribution_6_minus") %>%
    rename("Contribution_plus_6" = "Contribution_6_plus") %>%
    rename("Contribution_minus_7" = "Contribution_7_minus") %>%
    rename("Contribution_plus_7" = "Contribution_7_plus")

# Define columns to keep as identifiers
id_vars <- c(
    "BioID", "GovtrackID", "opensecrets_id", "first_name", "last_name", "state", "district",
    "party", "name", "birthday", "Geographical", "nominate_dim1", "nominate_dim2"
)
view(df_long)
# Perform a single pivot_longer operation
df_long <- df_long %>%
    pivot_longer(
        cols = -all_of(id_vars), # Exclude identifier columns from pivoting
        names_to = c(".value", "Instance"), # .value keeps the metric name, Instance extracts the number
        names_pattern = "(.*?)(?:_)?(\\d+)$", # Separates the metric name and instance number
    )
df_long <- df_long %>% filter(!is.na(Instance))
view(df_long)


# add 2nd
df$seniority_1152 <- df$seniority_115
df <- df %>% rename("seniority_1151" = "seniority_115")
# view(df)


# filter for each session
df_vote_3 <- filter_session_data_2(df, 3)
df_vote_4 <- filter_session_data_2(df, 4)
df_vote_51 <- filter_session_data_2(df, 51)
df_vote_52 <- filter_session_data_2(df, 52)
df_vote_6 <- filter_session_data_2(df, 6)
df_vote_7 <- filter_session_data_2(df, 7)

# get all contributions leading up to the vote, to see if votes before have impact for next relevant vote
df_vote_4_2 <- filter_all_pre_session_data(df, 4)
df_vote_51_2 <- filter_all_pre_session_data(df, 51)
df_vote_52_2 <- filter_all_pre_session_data(df, 52)
df_vote_6_2 <- filter_all_pre_session_data(df, 6)
df_vote_7_2 <- filter_all_pre_session_data(df, 7)

# get all reps who voted only pos. or only neg. and regress with all contributions
df_no_change <- df %>% filter(Vote_change_dummy == 0)
df_no_change$"all_votes" <- 0
# create a col that indicates if the rep voted all pos or neg. votes
for (i in 1:nrow(df_no_change)) {
    if (!is.na(any(df_no_change[i, c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")] == "1"))) {
        df_no_change[i, "all_votes"] <- "1"
    } else if (!is.na(any(df_no_change[i, c("Vote3", "Vote4", "Vote51", "Vote52", "Vote6", "Vote7")] == "0"))) {
        df_no_change[i, "all_votes"] <- "0"
    }
}

df_no_change <- dummy_cols(df_no_change, select_columns = "all_votes")
# view(df_no_change)
df_no_change <- df_no_change %>% rename("all_votes_plus" = "all_votes_1")
df_no_change <- df_no_change %>% rename("all_votes_minus" = "all_votes_0")
df_no_change <- df_no_change %>% select(-c(
    all_votes, Vote_change_dummy, Vote_change, Vote_count,
    Vote3, Vote4, Vote51, Vote52, Vote6, Vote7, BioID, GovtrackID, opensecrets_id,
    first_name, last_name, name
))

# create df for subsample analysis (incl. fixed effects)
df_fe <- df %>% dplyr::filter(Vote_change_dummy == 1)
# view(df_fe)
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

write.csv(df, "data/analysis/df.csv", row.names = FALSE)
write.csv(df_long, "data/analysis/df_long.csv", row.names = FALSE)
write.csv(df_no_change, "data/analysis/df_no_change.csv", row.names = FALSE)
write.csv(df_vote_3, "data/analysis/df_vote_3.csv", row.names = FALSE)
write.csv(df_vote_4, "data/analysis/df_vote_4.csv", row.names = FALSE)
write.csv(df_vote_4_2, "data/analysis/df_vote_4_2.csv", row.names = FALSE)
write.csv(df_vote_51_2, "data/analysis/df_vote_51_2.csv", row.names = FALSE)
write.csv(df_vote_52_2, "data/analysis/df_vote_52_2.csv", row.names = FALSE)
write.csv(df_vote_6_2, "data/analysis/df_vote_6_2.csv", row.names = FALSE)
write.csv(df_vote_7_2, "data/analysis/df_vote_7_2.csv", row.names = FALSE)
write.csv(df_vote_51, "data/analysis/df_vote_51.csv", row.names = FALSE)
write.csv(df_vote_52, "data/analysis/df_vote_52.csv", row.names = FALSE)
write.csv(df_vote_6, "data/analysis/df_vote_6.csv", row.names = FALSE)
write.csv(df_vote_7, "data/analysis/df_vote_7.csv", row.names = FALSE)
write.csv(df_sub, "data/analysis/df_sub.csv", row.names = FALSE)
