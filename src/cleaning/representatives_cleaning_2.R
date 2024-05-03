# setup
source("src/cleaning/utils/rep_cleaning_functions.R")
library(tidyverse)
library(jsonlite)


# import historical and current congress members
hist_reps <- read_delim("data/original/representatives/hist_reps.csv", show_col_types = FALSE)
curr_reps <- read_delim("data/original/representatives/curr_reps.csv", show_col_types = FALSE)
reps_113_117 <- read_delim("data/original/representatives/rep_113-117_bioguide.csv", show_col_types = FALSE)

reps_113_117 <- add_seniority(reps_113_117, 3)
reps_113_117 <- add_seniority(reps_113_117, 4)
reps_113_117 <- add_seniority(reps_113_117, 51)
reps_113_117 <- add_seniority(reps_113_117, 52)
reps_113_117 <- add_seniority(reps_113_117, 6)
reps_113_117 <- add_seniority(reps_113_117, 7)

# when reading in the bioguide data, we have all cols except for one in CSV format,
# the remaining in JSON, contains all congresses which representative participated in.
# we only need the individual rep lists for the contributions, and the rep_113_117 for the roll_calls
rep_113 <- read_delim("data/original/representatives/rep_113.csv", show_col_types = FALSE)
rep_114 <- read_delim("data/original/representatives/rep_114.csv", show_col_types = FALSE)
rep_115 <- read_delim("data/original/representatives/rep_115.csv", show_col_types = FALSE)
rep_116 <- read_delim("data/original/representatives/rep_116.csv", show_col_types = FALSE)
rep_117 <- read_delim("data/original/representatives/rep_117.csv", show_col_types = FALSE)

# create full congress members df, with all congress members, choose only reps
full_reps <- bind_rows(hist_reps, curr_reps)
# now that we have the full representatives, we need to remove senators and only keep those, which were in sessions 113-117.
full_reps <- full_reps %>% dplyr::filter(type == "rep")

# keep only cols of full_rep, whose bioguide_id or id is in the reps_113_117.
# DO THIS THE CORRECT WAY, INSIDE JOIN!
full_reps <- full_reps %>% select(
    last_name, first_name, birthday,
    gender, type, state, district, bioguide_id, opensecrets_id, govtrack_id, icpsr_id
)
reps_113_117 <- reps_113_117 %>% select(id, birthYear, starts_with("seniority_11"))

full_reps <- right_join(full_reps, reps_113_117, by = c("bioguide_id" = "id"))

rep_113 <- add_seniority(rep_113, 3)
view(rep_113)
rep_114 <- add_seniority(rep_114, 4)
rep_1151 <- add_seniority(rep_115, 5)
rep_1152 <- add_seniority(rep_115, 51)
rep_116 <- add_seniority(rep_116, 6)
rep_117 <- add_seniority(rep_117, 7)
# merges rep_11* with full_reps -> adds ids, and other control vars
rep_113 <- keep_ids(rep_113)
rep_114 <- keep_ids(rep_114)
rep_115 <- keep_ids(rep_115)
rep_116 <- keep_ids(rep_116)
rep_117 <- keep_ids(rep_117)


# add DW-Nominate Information for every representative in every session
session_numbers <- c(113, 114, 115, 116, 117)
dataframes <- list()

for (session_num in session_numbers) {
    file_path <- paste0("data/original/control_variables/H", session_num, "_members.csv")
    dataframes[[paste0("dw_", session_num)]] <- read_csv(file_path, show_col_types = FALSE) %>%
        filter(chamber == "House") %>%
        select(c("bioguide_id", "nominate_dim1", "nominate_dim2"))
}
view(dataframes$dw_113)
view(dataframes$dw_114)
# add DW-Nominate Information for every representative in panel df
rep_113 <- left_join(rep_113, dataframes$dw_113, by = "bioguide_id")
rep_114 <- left_join(rep_114, dataframes$dw_114, by = "bioguide_id")
rep_115 <- left_join(rep_115, dataframes$dw_115, by = "bioguide_id")
rep_116 <- left_join(rep_116, dataframes$dw_116, by = "bioguide_id")
rep_117 <- left_join(rep_117, dataframes$dw_117, by = "bioguide_id")


# write to csv
# full_reps and rep_11* are the same!
write.csv(full_reps, "data/cleaned/bioguide_full_reps.csv", row.names = FALSE)
write.csv(rep_113, "data/cleaned/bioguide_113_rep.csv", row.names = FALSE)
write.csv(rep_114, "data/cleaned/bioguide_114_rep.csv", row.names = FALSE)
write.csv(rep_115, "data/cleaned/bioguide_115_rep.csv", row.names = FALSE)
write.csv(rep_116, "data/cleaned/bioguide_116_rep.csv", row.names = FALSE)
write.csv(rep_117, "data/cleaned/bioguide_117_rep.csv", row.names = FALSE)
