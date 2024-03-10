# SET UP
library(tidyverse)

# IMPORT DATASETS
# fossil fuel oriented
# oil & gas contributions
oil_114 <- read_csv("data/oil_gas_contribution-2013-2014.csv",
    show_col_types = FALSE
)
oil_115 <- read_csv("data/oil_gas_contribution-2015-2016.csv",
    show_col_types = FALSE
)
oil_116 <- read_csv("data/oil_gas_contribution-2017-2018.csv",
    show_col_types = FALSE
)
# coal mining contributions
coal_114 <- read_csv("data/Coal_2013-2014.csv",
    show_col_types = FALSE
)
coal_115 <- read_csv("data/Coal_2015-2016.csv",
    show_col_types = FALSE
)
coal_116 <- read_csv("data/Coal_2017-2018.csv",
    show_col_types = FALSE
)
# mining
mining_114 <- read_csv("data/Mining_2013-2014.csv",
    show_col_types = FALSE
)
mining_115 <- read_csv("data/Mining_2015-2016.csv",
    show_col_types = FALSE
)
mining_116 <- read_csv("data/Mining_2017-2018.csv",
    show_col_types = FALSE
)
# gas pipelines
gas_114 <- read_csv("data/Gas_2013-2014.csv",
    show_col_types = FALSE
)
gas_115 <- read_csv("data/Gas_2015-2016.csv",
    show_col_types = FALSE
)
gas_116 <- read_csv("data/Gas_2017-2018.csv",
    show_col_types = FALSE
)

# environmentally friendly financial contributions
# alternative energy production
alternative_en_114 <- read_csv("data/Alternative_Energy_Production_2013-2014.csv",
    show_col_types = FALSE
)
alternative_en_115 <- read_csv("data/Alternative_Energy_Production_2015-2016.csv",
    show_col_types = FALSE
)
alternative_en_116 <- read_csv("data/Alternative_Energy_Production_2017-2018.csv",
    show_col_types = FALSE
)
# environmental contributions
env_114 <- read_csv("data/Environment_2013-2014.csv",
    show_col_types = FALSE
)
env_115 <- read_csv("data/Environment_2015-2016.csv",
    show_col_types = FALSE
)
env_116 <- read_csv("data/Environment_2017-2018.csv",
    show_col_types = FALSE
)
# data with all politicians of this term (not only those who received contribution)
rep_114 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/term-114.csv", show_col_types = FALSE)
rep_115 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/term-115.csv", show_col_types = FALSE)
rep_116 <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/term-116.csv", show_col_types = FALSE)

# CLEAN DATA
# 114th Congress

# data cleaning pipeline:

contribution_clean <- function(dataset) {
    # remove $ and turn into numeric
    dataset$Amount <- as.numeric(sub("\\$", "", dataset$Amount))

    # separate political affiliation, in () into new column.
    dataset$Party <- gsub(".*\\((.*?)\\).*", "\\1", dataset$Representative)

    dataset$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", dataset$Representative)

    # split the representatives column of contribution _114 into the columns LastName and FirstName.
    dataset <- extract(dataset, Representative, c("LastName", "FirstName"), "([^ ]+) (.*)")

    # split Party and state-abbreviation into separate columns.
    dataset <- separate(dataset, Party, into = c("Party", "StateAbbreviation"), sep = "-")

    # relocate Party and StateAbbreviation columns to after Names
    dataset <- dataset %>% relocate(Party, StateAbbreviation, .after = FirstName)

    return(dataset)
}
# cleaned datasets:

# DIRTY
# oil & gas contributions
# view(oil_114)
oil_114 <- contribution_clean(oil_114)
oil_115 <- contribution_clean(oil_115)
oil_116 <- contribution_clean(oil_116)

# coal mining contributions
coal_114 <- contribution_clean(coal_114)
coal_115 <- contribution_clean(coal_115)
coal_116 <- contribution_clean(coal_116)

# mining
mining_114 <- contribution_clean(mining_114)
mining_115 <- contribution_clean(mining_115)
mining_116 <- contribution_clean(mining_116)

# gas pipelines
gas_114 <- contribution_clean(gas_114)
gas_115 <- contribution_clean(gas_115)
gas_116 <- contribution_clean(gas_116)

# CLEAN
# environmental contributions
env_114 <- contribution_clean(env_114)
env_115 <- contribution_clean(env_115)
env_116 <- contribution_clean(env_116)
# alternative energy sources
alternative_en_114 <- contribution_clean(alternative_en_114)
alternative_en_115 <- contribution_clean(alternative_en_115)
alternative_en_116 <- contribution_clean(alternative_en_116)

# view(alternative_en_114)
# view(env_114)
# view(gas_114)
# view(mining_114)
# view(coal_114)
# view(oil_114)



# cleaning the representatives dataset (list of all house of representatives per term)
# clean rep dataset, split sort_name by ,
rep_114[c("Last", "First")] <- str_split_fixed(rep_114$sort_name, ",", 2)

# select only important cols
rep_114 <- rep_114 %>% select(Last, First, group_id, area_id, )

# repeat for 115 and 116th congress
rep_115[c("First", "Last")] <- str_split_fixed(rep_115$sort_name, ",", 2)
rep_115 <- rep_115 %>% select(Last, First, group_id, area_id, )

rep_116[c("First", "Last")] <- str_split_fixed(rep_116$sort_name, ",", 2)
rep_116 <- rep_116 %>% select(Last, First, group_id, area_id, )

# merge all financial contribution datasets, per term

# Function to process financial contribution datasets for a given term
process_financial_data <- function(oil, coal, mining, gas, env, alternative_en) {
    # Merge datasets
    master_df <- full_join(oil, coal[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName"), suffix = c(".oil", ".coal"))

    # Handle missing Party and StateAbbreviation
    master_df$Party <- ifelse(is.na(master_df$Party.oil), master_df$Party.coal, master_df$Party.oil)
    master_df$StateAbbreviation <- ifelse(is.na(master_df$StateAbbreviation.oil), master_df$StateAbbreviation.coal, master_df$StateAbbreviation.oil)

    # Remove redundant columns
    master_df <- master_df[, !(names(master_df) %in% c("Party.oil", "Party.coal", "StateAbbreviation.oil", "StateAbbreviation.coal"))]

    # Move columns before Amounts
    master_df <- master_df %>%
        relocate(StateAbbreviation, .after = FirstName) %>%
        relocate(Party, .after = StateAbbreviation)

    # Iterate over each contribution dataset
    for (dataset in list(mining, gas, env, alternative_en)) {
        master_df <- full_join(master_df, dataset[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName"))
    }

    # Rename columns
    colnames(master_df) <- gsub("\\..*", "", colnames(master_df)) # remove suffixes
    colnames(master_df) <- gsub("\\.x$", "", colnames(master_df)) # remove .x suffixes

    # Update missing Party and StateAbbreviation columns
    for (col in c("Party", "StateAbbreviation")) {
        master_df[[paste0(col, ".x")]] <- ifelse(is.na(master_df[[paste0(col, ".x")]]), master_df[[paste0(col, ".y")]], master_df[[paste0(col, ".x")]])
    }

    # Remove redundant columns
    master_df <- master_df[, !(names(master_df) %in% c("Party.y", "StateAbbreviation.y"))]

    # Move columns before Amounts
    master_df <- master_df %>%
        relocate(StateAbbreviation.x, .after = FirstName) %>%
        relocate(Party.x, .after = StateAbbreviation.x)

    # Turn "invalid number" or NA into 0
    amount_cols <- grep("^Amount", names(master_df), value = TRUE)
    master_df[amount_cols][is.na(master_df[amount_cols])] <- 0

    return(master_df)
}

# Process datasets for each congressional term
master_df_114 <- process_financial_data(oil_114, coal_114, mining_114, gas_114, env_114, alternative_en_114)
master_df_115 <- process_financial_data(oil_115, coal_115, mining_115, gas_115, env_115, alternative_en_115)
master_df_116 <- process_financial_data(oil_116, coal_116, mining_116, gas_116, env_116, alternative_en_116)

# View final datasets
view(master_df_114)
view(master_df_115)
view(master_df_116)


# THIS IS THE FINAL FINANCIAL CONTRIBUTION DATASET FOR THE 116TH CONGRESSIONAL TERM

write.csv(master_df_114, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/master_df_114.csv")

write.csv(master_df_115, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/master_df_115.csv")

write.csv(master_df_115, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/master_df_116.csv")

# view(master_df_114)
# view(master_df_115)
# view(master_df_116)

# create merge function, that merges based on LastName, and only keeps if FirstName = first.

merged <- function(reps, contribution) {
    merge_last <- full_join(contribution, reps, by = c("LastName" = "Last"))
    # view(merge_last)
    for (i in 1:nrow(merge_last)) {
        if (is.na(merge_last[i, ]$First)) {
            final_merge <- merge_last[-i, ]
        } else if (is.na(merge_last[i, ]$FirstName)) {
            final_merge <- merge_last[-i, ]
        } else {
            print(i)
            print("first and last name coincide")
        }
    }
    return(final_merge)
}


# create master dataset, join by representative.
master_contribution <- contribution_for_114 %>% full_join(contribution_for_115,
    by = c("LastName", "FirstName"),
    suffix = c(".114", ".115")
)
# view(master_contribution)

master_contribution_1 <- master_contribution %>% full_join(contribution_for_116,
    by = c("LastName", "FirstName"),
    suffix = c(".114.115", ".116")
)

master_contribution_1 <- master_contribution_1 %>%
    rename(Party.116 = Party, StateAbbreviation.116 = StateAbbreviation, State.116 = State, Amount.116 = Amount)

# view(master_contribution_1)

# in total, the master dataset has 552 rows. aka 435 per Session = 1305 persons (since we only have 552 though, this means that most overlap)

# create a column called count_contribution



# merge financial contributions with unique id
id_reps <- suppressMessages(read_csv("data/cleaned_unique_id_reps_copy.csv", show_col_types = FALSE))


# remove index column, rename Member ID to member_id
id_reps <- subset(id_reps, select = -...1)
id_reps <- id_reps %>%
    rename(member_id = `Member ID`)

view(id_reps)


# to merge with fuzzy join, we also include the party and states, for that we need to include the abbreviations of the states
state_abbreviations <- suppressMessages(read_csv("data/state_abbreviations.csv", show_col_types = FALSE))
view(state_abbreviations)

# change State column to include only abbreviations of respective states
for (i in 1:nrow(id_reps)) {
    if (!is.na(id_reps$State[i]) && nchar(id_reps$State[i]) > 2) {
        state <- id_reps$State[i]
        matching_postal <- state_abbreviations$Postal[state_abbreviations$State == state]
        if (length(matching_postal) > 0) {
            id_reps$State[i] <- matching_postal[1]
        }
    }
}
view(id_reps)
