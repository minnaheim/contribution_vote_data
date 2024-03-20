## merge fin rep document
# SET UP
library(tidyverse)
library(fuzzyjoin)
library(stringdist)

# import data cleaning pipeline:
# source("src/cleaning/utils/fin_cleaning_functions.R")
# source("src/cleaning/utils/roll_call_cleaning_functions.R")

# import datasets
contributions <- read_csv("data/cleaned/contributions.csv",
    show_col_types = FALSE
)
roll_call <- read_csv("data/cleaned/roll_call.csv",
    show_col_types = FALSE
)

# view(contributions)
# view(roll_call)

# merge both cleaned data-frames together based on member_id
df <- left_join(roll_call, contributions, by = "member_id")
view(df)

df <- relocate(df, last_name.y)
df <- relocate(df, last_name.x, .after = last_name.y)
df <- relocate(df, first_name.x, .after = last_name.x)
df <- relocate(df, first_name.y, .after = first_name.x)
df <- relocate(df, member_id, .after = first_name.y)
