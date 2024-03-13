# this dataset serves to clean the list of all representatives in the house sessions 114,
# 115 and 116, so that we have a complete list of financial contributions (also with members who did not receive fin. contributions)
# setup
source("src/cleaning/utils/rep_cleaning_functions.R")
source("src/cleaning/utils/fin_cleaning_functions.R")
source("src/cleaning/utils/roll_call_cleaning_functions.R")

library(tidyverse)
library(dplyr)

# import data
rep_114 <- read_csv("data/original/representatives_114_manual.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/original/representatives_115.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/original/representatives_116.csv", show_col_types = FALSE)

rep_114 <- rep_cleaning(rep_114)
rep_115 <- rep_cleaning(rep_115)
rep_116 <- rep_cleaning(rep_116)

# view(rep_114)

# write csv
write.csv(rep_114, "data/cleaned/cleaned_representatives_114.csv")
write.csv(rep_115, "data/cleaned/cleaned_representatives_115.csv")
write.csv(rep_116, "data/cleaned/cleaned_representatives_116.csv")

# all_reps_contributions <- full_join(master_df_114, rep_114["LastName", "FirstName"], by = c("LastName", "FirstName"))
# view(all_reps_contributions)

all_reps_contributions <- full_join(master_df_114, rep_114[, c("LastName", "FirstName")], by = c("LastName", "FirstName"))

# view(all_reps_contributions)

# no need to merge rep_114 to master_df_114, as we already included this in all_reps_114, check here
all_reps_114 <- read_csv("data/cleaned/cleaned_all_reps_contribution_114.csv", show_col_types = FALSE)
all_reps_115 <- read_csv("data/cleaned/cleaned_all_reps_contribution_115.csv", show_col_types = FALSE)
all_reps_116 <- read_csv("data/cleaned/cleaned_all_reps_contribution_116.csv", show_col_types = FALSE)

# check that there are people in the df without contributions
all_reps_114_0 <- all_reps_114 %>% dplyr::filter(Amount.oil.114 == 0 & Amount.coal.114 == 0 & Amount.mining.114 == 0 &
    Amount.gas.114 == 0 & Amount.env.114 == 0 & Amount.alt_en.114 == 0)
# view(all_reps_114_0)
# 18 reps received 0 contributions from energy & env. sectors
all_reps_115_0 <- all_reps_115 %>% dplyr::filter(Amount.oil.115 == 0 & Amount.coal.115 == 0 & Amount.mining.115 == 0 &
    Amount.gas.115 == 0 & Amount.env.115 == 0 & Amount.alt_en.115 == 0)
# view(all_reps_115_0)
# 25 reps received 0 contributions from energy & env. sectors
all_reps_116_0 <- all_reps_116 %>% dplyr::filter(Amount.oil.116 == 0 & Amount.coal.116 == 0 & Amount.mining.116 == 0 &
    Amount.gas.116 == 0 & Amount.env.116 == 0 & Amount.alt_en.116 == 0)
# view(all_reps_116_0)
# 18 reps received 0 contributions from energy & env. sectors




# import and clean unique identifiers of representatives
# import data
rep_u_id <- read_csv("data/original/unique_id_reps.csv", show_col_types = FALSE)
# view(rep_u_id)

rep_u_id <- clean_original_id_rep_list(rep_u_id)
# view(rep_u_id)

# write csv
write.csv(rep_u_id, "/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data/cleaned_unique_id_reps.csv")
