# this doc serves to merge all roll call data and the financial data

# set up
library(tidyverse)

# import rollcall data
roll_call <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_full_rollcall_votes.csv", show_col_types = FALSE)
# import financial data
contributions <- read_csv("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/all_reps_contribution.csv")

# remove indices columns
roll_call <- subset(roll_call, select = -...1)

# view(contributions)
# view(roll_call)

# merge datasets
master_dataset <- full_join(contributions, roll_call, by = c("LastName", "FirstName"))
view(master_dataset)

# remove the following Party.114, District 114, Party. 115, District 115, Party 116, District.116, Party.116.



# check if dataset is complete, by checking if amount....116 and vote.116 both not NA...
