# this doc serves to merge all roll call data and the financial data through the unique ID column

# set up
library(tidyverse)
# install.packages("fuzzyjoin", repos = "https://stat.ethz.ch/CRAN/")
library(fuzzyjoin)
# install.packages("stringdist", repos = "https://stat.ethz.ch/CRAN/")
library(stringdist)

# import rollcall data
roll_call <- suppressMessages(read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_roll_call_final.csv", show_col_types = FALSE))
# import financial data
contributions <- suppressMessages(read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_financial_data.csv", show_col_types = FALSE))

# remove ...1 cols
contributions <- contributions %>% select(-...1)
roll_call <- roll_call %>% select(-...1)


# change walter Jr from D -> R in roll_call and change Name to Walter B Jr
roll_call <- roll_call %>%
    mutate(Party = ifelse(LastName == "Jones" & FirstName == "Jr." & State == "NC", "R", Party)) %>%
    mutate(FirstName = ifelse(LastName == "Jones" & FirstName == "Jr." & State == "NC", "Walter B Jr.", FirstName)) %>%
    mutate(member_id = ifelse(LastName == "Jones" & State == "NC", "J000255", member_id))

# change John J Jr Duncan to Jr. in rollcall
roll_call <- roll_call %>%
    mutate(FirstName = ifelse(LastName == "Duncan" & FirstName == "Jr." & State == "TN", "John J Jr.", FirstName)) %>%
    mutate(member_id = ifelse(LastName == "Duncan" & State == "TN", "D000534", member_id))

# view(roll_call)


# remove non-voting members
roll_call <- roll_call %>%
    dplyr::filter(State != "GU") %>%
    dplyr::filter(State != "PR") %>%
    dplyr::filter(State != "VI") %>%
    dplyr::filter(State != "American Samoa") %>%
    dplyr::filter(State != "DC") %>%
    dplyr::filter(State != "MP")

contributions <- contributions %>%
    dplyr::filter(State != "GU") %>%
    dplyr::filter(State != "PR") %>%
    dplyr::filter(State != "VI") %>%
    dplyr::filter(State != "American Samoa") %>%
    dplyr::filter(State != "DC") %>%
    dplyr::filter(State != "MP")

# view datasets
# view(contributions)
# view(roll_call)

# merge rollcall data and financial contribution data based on unique ID.
df <- full_join(contributions, roll_call, by = "member_id")

# relocate cols
df <- relocate(df, LastName.y, .after = LastName.x)
df <- relocate(df, FirstName.y, .after = FirstName.x)
df <- relocate(df, member_id, .after = Party.x)
df <- relocate(df, State.y, .after = member_id)
df <- relocate(df, Party.y, .after = State.y)

# view(df)



# remove cols Alias, Party.y, State.y
df <- df %>% select(-c(Alias.x, Party.y, State.y, District))



# correct NAs dep on how they occur

# remove these reps, joined mid-session, didn't vote on bill (joined after 20.6.2019)
df <- subset(
    df,
    !(LastName.x == "Jones" &
        FirstName.x == "Brenda" &
        State.x == "MI")
)
df <- subset(
    df,
    !(LastName.x == "Mfume" &
        FirstName.x == "Kweisi" &
        State.x == "MD")
)
df <- subset(
    df,
    !(LastName.x == "Garcia" &
        FirstName.x == "Mike" &
        State.x == "CA")
)
df <- subset(
    df,
    !(LastName.x == "Jacobs" &
        FirstName.x == "Chris" &
        State.x == "NY")
)
df <- subset(
    df,
    !(LastName.x == "Murphy" &
        FirstName.x == "Greg" &
        State.x == "NC")
)

df <- subset(
    df,
    !(LastName.x == "Bishop" &
        FirstName.x == "Dan" &
        State.x == "NC")
)
df <- subset(
    df,
    !(LastName.x == "Tiffany" &
        FirstName.x == "Tom" &
        State.x == "WI")
)
# view(df)

# write csv
write.csv(df, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_n_merged_df_114-116.csv", row.names = FALSE)
