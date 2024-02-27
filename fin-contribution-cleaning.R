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
view(oil_114)
oil_114 <- contribution_clean(oil_114)
view(oil_114)
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
# 114
master_df_114 <- full_join(oil_114, coal_114[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName"), suffix = c(".oil", ".coal"))

# If Party and StateAbbreviation are missing in oil_115, use values from coal_115
master_df_114$Party <- ifelse(is.na(master_df_114$Party.oil), master_df_114$Party.coal, master_df_114$Party.oil)
master_df_114$StateAbbreviation <- ifelse(is.na(master_df_114$StateAbbreviation.oil), master_df_114$StateAbbreviation.coal, master_df_114$StateAbbreviation.oil)

# Remove redundant columns
master_df_114 <- master_df_114[, !(names(master_df_114) %in% c("Party.oil", "Party.coal", "StateAbbreviation.oil", "StateAbbreviation.coal"))]

# move columns before Amounts
master_df_114 <- master_df_114 %>%
    relocate(StateAbbreviation, .after = FirstName) %>%
    relocate(Party, .after = StateAbbreviation)

# view(master_df_114)

master_df_114 <- full_join(master_df_114, mining_114[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.mining" = "Amount") %>%
    rename("Party.mining" = "Party.y") %>%
    rename("StateAbbreviation.mining" = "StateAbbreviation.y")

# Update Party and StateAbbreviation columns if missing
master_df_114$Party.x <- ifelse(is.na(master_df_114$Party.x), master_df_114$Party.mining, master_df_114$Party.x)

master_df_114$StateAbbreviation.x <- ifelse(is.na(master_df_114$StateAbbreviation.x), master_df_114$StateAbbreviation.mining, master_df_114$StateAbbreviation.x)

# Remove redundant columns
master_df_114 <- master_df_114[, !(names(master_df_114) %in% c("Party.mining", "StateAbbreviation.mining"))]

# Move columns before Amounts
master_df_114 <- master_df_114 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_114)
# continue here

master_df_114 <- full_join(master_df_114, gas_114[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.gas" = "Amount") %>%
    rename("Party.gas" = "Party") %>%
    rename("StateAbbreviation.gas" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_114$Party.x <- ifelse(is.na(master_df_114$Party.x), master_df_114$Party.gas, master_df_114$Party.x)

master_df_114$StateAbbreviation.x <- ifelse(is.na(master_df_114$StateAbbreviation.x), master_df_114$StateAbbreviation.gas, master_df_114$StateAbbreviation.x)

# Remove redundant columns
master_df_114 <- master_df_114[, !(names(master_df_114) %in% c("Party.gas", "StateAbbreviation.gas"))]

# Move columns before Amounts
master_df_114 <- master_df_114 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_114)

master_df_114 <- full_join(master_df_114, env_114[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.env" = "Amount") %>%
    rename("Party.env" = "Party") %>%
    rename("StateAbbreviation.env" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_114$Party.x <- ifelse(is.na(master_df_114$Party.x), master_df_114$Party.env, master_df_114$Party.x)

master_df_114$StateAbbreviation.x <- ifelse(is.na(master_df_114$StateAbbreviation.x), master_df_114$StateAbbreviation.env, master_df_114$StateAbbreviation.x)

# Remove redundant columns
master_df_114 <- master_df_114[, !(names(master_df_114) %in% c("Party.env", "StateAbbreviation.env"))]

# Move columns before Amounts
master_df_114 <- master_df_114 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_114)

master_df_114 <- full_join(master_df_114, alternative_en_114[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.alt_en" = "Amount") %>%
    rename("Party.alt_en" = "Party") %>%
    rename("StateAbbreviation.alt_en" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_114$Party.x <- ifelse(is.na(master_df_114$Party.x), master_df_114$Party.alt_en, master_df_114$Party.x)

master_df_114$StateAbbreviation.x <- ifelse(is.na(master_df_114$StateAbbreviation.x), master_df_114$StateAbbreviation.alt_en, master_df_114$StateAbbreviation.x)

# Remove redundant columns
master_df_114 <- master_df_114[, !(names(master_df_114) %in% c("Party.alt_en", "StateAbbreviation.alt_en"))]

# Move columns before Amounts
master_df_114 <- master_df_114 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_114)

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(master_df_114), value = TRUE)
master_df_114[amount_cols][is.na(master_df_114[amount_cols])] <- 0
# view(master_df_114)
# THIS IS THE FINAL FINANCIAL CONTRIBUTION DATASET FOR THE 114TH CONGRESSIONAL TERM


# 115
master_df_115 <- full_join(oil_115, coal_115[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName"), suffix = c(".oil", ".coal"))

# If Party and StateAbbreviation are missing in oil_115, use values from coal_115
master_df_115$Party <- ifelse(is.na(master_df_115$Party.oil), master_df_115$Party.coal, master_df_115$Party.oil)
master_df_115$StateAbbreviation <- ifelse(is.na(master_df_115$StateAbbreviation.oil), master_df_115$StateAbbreviation.coal, master_df_115$StateAbbreviation.oil)

# Remove redundant columns
master_df_115 <- master_df_115[, !(names(master_df_115) %in% c("Party.oil", "Party.coal", "StateAbbreviation.oil", "StateAbbreviation.coal"))]

# move columns before Amounts
master_df_115 <- master_df_115 %>%
    relocate(StateAbbreviation, .after = FirstName) %>%
    relocate(Party, .after = StateAbbreviation)

# view(master_df_115)

master_df_115 <- full_join(master_df_115, mining_115[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.mining" = "Amount") %>%
    rename("Party.mining" = "Party.y") %>%
    rename("StateAbbreviation.mining" = "StateAbbreviation.y")

# Update Party and StateAbbreviation columns if missing
master_df_115$Party.x <- ifelse(is.na(master_df_115$Party.x), master_df_115$Party.mining, master_df_115$Party.x)

master_df_115$StateAbbreviation.x <- ifelse(is.na(master_df_115$StateAbbreviation.x), master_df_115$StateAbbreviation.mining, master_df_115$StateAbbreviation.x)

# Remove redundant columns
master_df_115 <- master_df_115[, !(names(master_df_115) %in% c("Party.mining", "StateAbbreviation.mining"))]

# Move columns before Amounts
master_df_115 <- master_df_115 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_115)

master_df_115 <- full_join(master_df_115, gas_115[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.gas" = "Amount") %>%
    rename("Party.gas" = "Party") %>%
    rename("StateAbbreviation.gas" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_115$Party.x <- ifelse(is.na(master_df_115$Party.x), master_df_115$Party.gas, master_df_115$Party.x)

master_df_115$StateAbbreviation.x <- ifelse(is.na(master_df_115$StateAbbreviation.x), master_df_115$StateAbbreviation.gas, master_df_115$StateAbbreviation.x)

# Remove redundant columns
master_df_115 <- master_df_115[, !(names(master_df_115) %in% c("Party.gas", "StateAbbreviation.gas"))]

# Move columns before Amounts
master_df_115 <- master_df_115 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_115)

master_df_115 <- full_join(master_df_115, env_115[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.env" = "Amount") %>%
    rename("Party.env" = "Party") %>%
    rename("StateAbbreviation.env" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_115$Party.x <- ifelse(is.na(master_df_115$Party.x), master_df_115$Party.env, master_df_115$Party.x)

master_df_115$StateAbbreviation.x <- ifelse(is.na(master_df_115$StateAbbreviation.x), master_df_115$StateAbbreviation.env, master_df_115$StateAbbreviation.x)

# Remove redundant columns
master_df_115 <- master_df_115[, !(names(master_df_115) %in% c("Party.env", "StateAbbreviation.env"))]

# Move columns before Amounts
master_df_115 <- master_df_115 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_115)

master_df_115 <- full_join(master_df_115, alternative_en_115[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.alt_en" = "Amount") %>%
    rename("Party.alt_en" = "Party") %>%
    rename("StateAbbreviation.alt_en" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_115$Party.x <- ifelse(is.na(master_df_115$Party.x), master_df_115$Party.alt_en, master_df_115$Party.x)

master_df_115$StateAbbreviation.x <- ifelse(is.na(master_df_115$StateAbbreviation.x), master_df_115$StateAbbreviation.alt_en, master_df_115$StateAbbreviation.x)

# Remove redundant columns
master_df_115 <- master_df_115[, !(names(master_df_115) %in% c("Party.alt_en", "StateAbbreviation.alt_en"))]

# Move columns before Amounts
master_df_115 <- master_df_115 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_115)

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(master_df_115), value = TRUE)
master_df_115[amount_cols][is.na(master_df_115[amount_cols])] <- 0
# view(master_df_115)
# THIS IS THE FINAL FINANCIAL CONTRIBUTION DATASET FOR THE 115TH CONGRESSIONAL TERM

# 116
master_df_116 <- full_join(oil_116, coal_116[, c("LastName", "FirstName", "Party", "StateAbbreviation", "Amount")], by = c("LastName", "FirstName"), suffix = c(".oil", ".coal"))

# If Party and StateAbbreviation are missing in oil_116, use values from coal_116
master_df_116$Party <- ifelse(is.na(master_df_116$Party.oil), master_df_116$Party.coal, master_df_116$Party.oil)
master_df_116$StateAbbreviation <- ifelse(is.na(master_df_116$StateAbbreviation.oil), master_df_116$StateAbbreviation.coal, master_df_116$StateAbbreviation.oil)

# Remove redundant columns
master_df_116 <- master_df_116[, !(names(master_df_116) %in% c("Party.oil", "Party.coal", "StateAbbreviation.oil", "StateAbbreviation.coal"))]

# move columns before Amounts
master_df_116 <- master_df_116 %>%
    relocate(StateAbbreviation, .after = FirstName) %>%
    relocate(Party, .after = StateAbbreviation)

# view(master_df_116)


master_df_116 <- full_join(master_df_116, mining_116[, c("LastName", "FirstName", "Party", "StateAbbreviation", "Amount")], by = c("LastName", "FirstName")) %>%
    rename("Party.mining" = "Party.y") %>%
    rename("StateAbbreviation.mining" = "StateAbbreviation.y") %>%
    rename("Amount.mining" = "Amount")

# Update Party and StateAbbreviation columns if missing
master_df_116$Party.x <- ifelse(is.na(master_df_116$Party.x), master_df_116$Party.mining, master_df_116$Party.x)

master_df_116$StateAbbreviation.x <- ifelse(is.na(master_df_116$StateAbbreviation.x), master_df_116$StateAbbreviation.mining, master_df_116$StateAbbreviation.x)

# Remove redundant columns
master_df_116 <- master_df_116[, !(names(master_df_116) %in% c("Party.mining", "StateAbbreviation.mining"))]

# Move columns before Amounts
master_df_116 <- master_df_116 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_116)

master_df_116 <- full_join(master_df_116, gas_116[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.gas" = "Amount") %>%
    rename("StateAbbreviation.gas" = "StateAbbreviation") %>%
    rename("Party.gas" = "Party")

# Update Party and StateAbbreviation columns if missing
master_df_116$Party.x <- ifelse(is.na(master_df_116$Party.x), master_df_116$Party.gas, master_df_116$Party.x)

master_df_116$StateAbbreviation.x <- ifelse(is.na(master_df_116$StateAbbreviation.x), master_df_116$StateAbbreviation.gas, master_df_116$StateAbbreviation.x)

# Remove redundant columns
master_df_116 <- master_df_116[, !(names(master_df_116) %in% c("Party.gas", "StateAbbreviation.gas"))]

# Move columns before Amounts
master_df_116 <- master_df_116 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_116)

master_df_116 <- full_join(master_df_116, env_116[, c("LastName", "FirstName", "Amount", "StateAbbreviation", "Party")], by = c("LastName", "FirstName")) %>%
    rename("Amount.env" = "Amount") %>%
    rename("Party.env" = "Party") %>%
    rename("StateAbbreviation.env" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_116$Party.x <- ifelse(is.na(master_df_116$Party.x), master_df_116$Party.env, master_df_116$Party.x)

master_df_116$StateAbbreviation.x <- ifelse(is.na(master_df_116$StateAbbreviation.x), master_df_116$StateAbbreviation.env, master_df_116$StateAbbreviation.x)

# Remove redundant columns
master_df_116 <- master_df_116[, !(names(master_df_116) %in% c("Party.env", "StateAbbreviation.env"))]

# Move columns before Amounts
master_df_116 <- master_df_116 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_116)

master_df_116 <- full_join(master_df_116, alternative_en_116[, c("LastName", "FirstName", "Amount", "Party", "StateAbbreviation")], by = c("LastName", "FirstName")) %>%
    rename("Amount.alt_en" = "Amount") %>%
    rename("Party.alt_en" = "Party") %>%
    rename("StateAbbreviation.alt_en" = "StateAbbreviation")

# Update Party and StateAbbreviation columns if missing
master_df_116$Party.x <- ifelse(is.na(master_df_116$Party.x), master_df_116$Party.alt_en, master_df_116$Party.x)

master_df_116$StateAbbreviation.x <- ifelse(is.na(master_df_116$StateAbbreviation.x), master_df_116$StateAbbreviation.alt_en, master_df_116$StateAbbreviation.x)

# Remove redundant columns
master_df_116 <- master_df_116[, !(names(master_df_116) %in% c("Party.alt_en", "StateAbbreviation.alt_en"))]

# Move columns before Amounts
master_df_116 <- master_df_116 %>%
    relocate(StateAbbreviation.x, .after = FirstName) %>%
    relocate(Party.x, .after = StateAbbreviation.x)

# view(master_df_116)

# turn "invalid number" or NA into 0
amount_cols <- grep("^Amount", names(master_df_116), value = TRUE)
master_df_116[amount_cols][is.na(master_df_116[amount_cols])] <- 0

# view(master_df_116)
# THIS IS THE FINAL FINANCIAL CONTRIBUTION DATASET FOR THE 116TH CONGRESSIONAL TERM

write.csv(master_df_114, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/master_df_114.csv")

write.csv(master_df_115, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/master_df_115.csv")

write.csv(master_df_115, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/master_df_116.csv")

# in the above dataset, "master_df_116" only those house reps. are shown, which have received contributions, i.e. we need to add in non-listed members, and their amounts = 0


# # merge sample dataset
# sample_rep_114 <- rep_114[309:310, ]
# sample_rep_115 <- rep_115[1:10, ]
# sample_dataset <- dataset[7:8, ]


# merged_sample_rep_114 <- full_join(sample_dataset, sample_rep_114, by = c("LastName" = "Last"))


# create merge function, that merges based on LastName, and only keeps if FirstName = first.

merged <- function(reps, contribution) {
    merge_last <- full_join(contribution, reps, by = c("LastName" = "Last"))
    view(merge_last)
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
master_contribution <- dataset %>% full_join(contribution_for_115,
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
