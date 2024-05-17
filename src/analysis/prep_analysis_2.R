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

# divide all contribution columns by 100
df <- df %>% mutate_at(vars(starts_with("Contribution")), ~ . / 1000)


# add abs value to nominates - cant be bothered to change the original source (rep_cleaning)
df <- df %>% mutate(
    nominate_dim1 = abs(nominate_dim1),
    nominate_dim2 = abs(nominate_dim2)
)

# change birthdays to only include years, and group into decades
# why does lubridate not work?
df$birthday <- as.Date(df$birthday, format = "%Y-%m-%d")
df$birthday <- as.numeric(format(df$birthday, "%Y"))

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


# pivot table longer
df_long <- aggregate_pivot_longer_function(df)
view(df_long)

# create vote_change cols
df_vote_change <- df_long %>% filter(Vote_change_dummy == 1)
df_vote_change <- create_vote_change_dummies(df_vote_change)
# view(df_vote_change)

# add dummy for pro and anti environmental contributions per vote.
df_long <- add_contrib_dummy(df_long)
df_vote_change <- add_contrib_dummy(df_vote_change)


# duplicate seniority_115 and rename seniority cols
df$seniority_1152 <- df$seniority_115
df$seniority_1151 <- df$seniority_115
df <- df %>% select(-c(seniority_115))
df <- df %>% relocate("seniority_1151", .after = "seniority_114")
df <- df %>% relocate("seniority_1152", .after = "seniority_1151")
# view(df)

# get all contributions leading up to the vote, to see if votes before have impact for next relevant vote
df_vote_4_2 <- process_session_data(df, 4)
df_vote_51_2 <- process_session_data(df, 51)
df_vote_52_2 <- process_session_data(df, 52)
df_vote_6_2 <- process_session_data(df, 6)
df_vote_7_2 <- process_session_data(df, 7)

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

# vote_change_type and vote_change_year columns using detect_changes and detect_year_of_changes functions
df_fe <- create_vote_change_dataframe(df_fe)
# view(df_fe)

# relocate cols
df_fe <- relocate(df_fe, "first_vote", .after = "vote_change_year")
df_fe$vote_change_type <- as.numeric(df_fe$vote_change_type)
df_fe <- df_fe %>% mutate(year = str_extract(vote_change_year, "(?<=-).*"))
df_sub <- relocate(df_fe, "year", .after = vote_change_year)

write.csv(df, "data/analysis/df.csv", row.names = FALSE)
write.csv(df_long, "data/analysis/df_long.csv", row.names = FALSE)
write.csv(df_vote_change, "data/analysis/df_vote_change.csv", row.names = FALSE)
write.csv(df_no_change, "data/analysis/df_no_change.csv", row.names = FALSE)
write.csv(df_vote_4_2, "data/analysis/df_vote_4_2.csv", row.names = FALSE)
write.csv(df_vote_51_2, "data/analysis/df_vote_51_2.csv", row.names = FALSE)
write.csv(df_vote_52_2, "data/analysis/df_vote_52_2.csv", row.names = FALSE)
write.csv(df_vote_6_2, "data/analysis/df_vote_6_2.csv", row.names = FALSE)
write.csv(df_vote_7_2, "data/analysis/df_vote_7_2.csv", row.names = FALSE)
write.csv(df_sub, "data/analysis/df_sub.csv", row.names = FALSE)
