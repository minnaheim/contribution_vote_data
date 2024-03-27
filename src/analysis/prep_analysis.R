# this script serves to adjust the dataframes to fit to the requirements of each OLS
library(tidyverse)
library(ggplot2)
library(glue)
source("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/src/analysis/analysis_prep_functions.R")

df <- read.csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned/final_df.csv")

# general DF
df_gen <- analysis_prep(df)
# view(df_gen)

# summarize contributions
df_sum <- analysis_prep(df)
df_sum <- summarise_contributions(df_sum)
# view(df_sum)

## for subsample OLS - identify how people changed their minds
df_subsample <- analysis_prep(df)
df_subsample <- df_subsample %>% dplyr::filter(Vote_change_dummy == 1)
# take each row of vote cols in df_subsample and apply detect_changes
df_subsample$vote_change_type <- apply(df_subsample[, vote_columns], 1, detect_changes)
df_subsample <- df_subsample %>% relocate(vote_change_type, .after = Vote_change)
df_subsample <- pivot_longer_function(df_subsample)
# view(df_subsample)

# apply summarise function
df_subsample_sum <- summarise_contributions(df_subsample)
# view(df_subsample_sum)

# use the subsample function to create the fixed effects dataframe
df_fe <- analysis_prep(df)
df_fe <- df_fe %>% dplyr::filter(Vote_change_dummy == 1)
df_fe$vote_change_type <- apply(df_fe[, vote_columns], 1, detect_changes)
df_fe <- df_fe %>% relocate(vote_change_type, .after = Vote_change)
# view(df_fe)

# df_fe <- first_contribution(df_fe)
df_fe$first_contribution <- apply(df_fe[, vote_columns], 1, first_contribution)
df_fe <- pivot_longer_function(df_fe)
df_fe <- relocate(df_fe, "first_contribution", .before = "Vote_change_dummy")

# write to csv
write.csv(df_gen, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df.csv", row.names = FALSE)
write.csv(df_sum, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df_sum.csv", row.names = FALSE)
write.csv(df_subsample, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df_subsample.csv", row.names = FALSE)
write.csv(df_subsample_sum, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df_subsample_sum.csv",
    row.names = FALSE
)
write.csv(df_fe, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df_fe.csv", row.names = FALSE)
