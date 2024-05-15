# this script serves to adjust the dataframes to fit to the requirements of each OLS
library(tidyverse)
library(ggplot2)
library(glue)
source("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/src/analysis/analysis_prep_functions.R")
df <- read.csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned/final_df.csv")

# add state dummies (categorised acc. to US Census Data -> https://www2.census.gov/geo/pdfs/reference/GARM/Ch6GARM.pdf)
state_abbreviation <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/original/state_abbreviations.csv", show_col_types = FALSE) %>%
    select(Postal, Geographical) %>%
    filter(!is.na(Geographical))


df["Geographical"] <- NA
view(df)
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

# group contribution variables into pro_env contributions and anti_env contributions per congressional session
group_columns <- function(df) {
    for (suffix in 113:117) {
        # Extract columns with the current suffix
        suffix_cols <- grep(paste0("\\.", suffix, "$"), names(df), value = TRUE)

        # Initialize lists to store column groups
        pro_env_cols <- c()
        anti_env_cols <- c()

        # Group columns based on prefixes
        for (col_name in suffix_cols) {
            if (grepl("amount.env|amount.alt_en", col_name)) {
                pro_env_cols <- c(pro_env_cols, col_name)
            } else if (grepl("amount.oil|amount.coal|amount.gas|amount.mining", col_name)) {
                anti_env_cols <- c(anti_env_cols, col_name)
            }
        }

        # Create new columns by combining groups
        if (length(pro_env_cols) > 0) {
            df[[paste0("pro_env.", suffix)]] <- rowSums(df[pro_env_cols])
        }
        if (length(anti_env_cols) > 0) {
            df[[paste0("anti_env.", suffix)]] <- rowSums(df[anti_env_cols])
        }

        # Remove original columns
        df <- df[, !(names(df) %in% c(pro_env_cols, anti_env_cols))]
    }

    return(df)
}
df <- group_columns(df)
view(df)

# general DF
df_gen <- analysis_prep(df)
df_gen <- group_columns(df_gen)

# view(df_gen)

# summarize contributions
# df_sum <- analysis_prep(df)
# df_sum <- summarise_contributions(df_sum)
# view(df_sum)

## for subsample OLS - identify how people changed their minds
df_subsample <- analysis_prep(df)
df_subsample <- group_columns(df_subsample)
df_subsample <- df_subsample %>% dplyr::filter(Vote_change_dummy == 1)
# take each row of vote cols in df_subsample and apply detect_changes
df_subsample$vote_change_type <- apply(df_subsample[, vote_columns], 1, detect_changes)
df_subsample <- df_subsample %>% relocate(vote_change_type, .after = Vote_change)
df_subsample <- pivot_longer_function(df_subsample)
view(df_subsample)


# create dummy for vote change... 1 or 0 vote!! > von + -> - = 0, von - -> + = 1 (manually, use package for this)
df_subsample$vote_change_to_pro <- df_subsample$change
df_subsample$vote_change_to_pro[df_subsample$vote_change_to_pro == 1] <- 1
df_subsample$vote_change_to_anti <- df_subsample$change
df_subsample$vote_change_to_anti[df_subsample$change == 0] <- 1
df_subsample$vote_change_to_anti[df_subsample$change == 1] <- 0
df_subsample <- relocate(df_subsample, vote_change_to_pro, .after = change)
df_subsample <- relocate(df_subsample, vote_change_to_anti, .after = vote_change_to_pro)



# apply summarise function
# df_subsample_sum <- summarise_contributions(df_subsample)
# view(df_subsample_sum)

# use the subsample function to create the fixed effects dataframe
# df_fe <- analysis_prep(df)
# df_fe <- df_fe %>% dplyr::filter(Vote_change_dummy == 1)
# df_fe$vote_change_type <- apply(df_fe[, vote_columns], 1, detect_changes)
# df_fe <- df_fe %>% relocate(vote_change_type, .after = Vote_change)
# df_fe$vote_change_year <- apply(df_fe[, vote_columns], 1, detect_year_of_changes)
# df_fe <- df_fe %>% relocate(vote_change_year, .after = vote_change_type)
# df_fe$first_contribution <- apply(df_fe[, vote_columns], 1, first_contribution)
# works until here
# view(df_fe)

# Separate the 'vote_change_type' and 'vote_change_year' into multiple rows where they are comma-separated
# df_fe <- df_fe %>%
#     # Convert to long format by splitting 'vote_change_type' and 'vote_change_year' strings into multiple rows
#     separate_rows(vote_change_type, vote_change_year, sep = ",") %>%
#     # Optionally, you can trim whitespace if necessary
#     mutate(
#         vote_change_type = trimws(vote_change_type),
#         vote_change_year = trimws(vote_change_year)
#     )

# View the transformed DataFrame
df_fe <- relocate(df_fe, "first_contribution", .after = "vote_change_year")
df_fe$vote_change_type <- as.numeric(df_fe$vote_change_type)
df_fe <- df_fe %>% mutate(year = str_extract(vote_change_year, "(?<=-).*"))
df_fe <- relocate(df_fe, "year", .after = vote_change_year)
view(df_fe)

# write to csv
write.csv(df_gen, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df.csv", row.names = FALSE)
# write.csv(df_sum, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df_sum.csv", row.names = FALSE)
write.csv(df_subsample, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df_subsample.csv", row.names = FALSE)
# write.csv(df_subsample_sum, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df_subsample_sum.csv",
#     row.names = FALSE
# )
# write.csv(df_fe, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/analysis/df_fe.csv", row.names = FALSE)
