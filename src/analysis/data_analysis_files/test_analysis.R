library(tidyverse)
library(ggplot2)

df <- read.csv("data/cleaned/final_df.csv")

# remove index col
df <- df %>% select(-c("X"))

# PREP DATASET FOR ANALYSIS
# parties only incl. R, D, no I
df <- df %>% dplyr::filter(party %in% c("D", "R"))

# only include if vote_count > 1
df <- df %>% dplyr::filter(Vote_count > 1)
# view(df)

# vote change = 1 if > 0, and 0 if 0.
df["Vote_change_dummy"] <- NA

for (i in 1:nrow(df)) {
    if (df$Vote_change[i] > 0) {
        df$Vote_change_dummy[i] <- 1
    } else {
        df$Vote_change_dummy[i] <- 0
    }
}
df <- relocate(df, "Vote_change_dummy", .after = "Vote_change")
# view(df)

# categorise amount cols into one... just amount.*


# OLS
ols <- lm(Vote_change_dummy ~ party, data = df)
summary(ols)
