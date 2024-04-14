# import historical and current congress members
hist_reps <- read_delim("data/original/representatives/hist_reps.csv", show_col_types = FALSE)
curr_reps <- read_delim("data/original/representatives/curr_reps.csv", show_col_types = FALSE)
reps_113_117 <- read_delim("data/original/representatives/rep_113-117_bioguide.csv", show_col_types = FALSE)
rep_113 <- read_delim("data/original/representatives/rep_113.csv", show_col_types = FALSE)
# view(rep_113)
rep_114 <- read_delim("data/original/representatives/rep_114.csv", show_col_types = FALSE)
# view(rep_114)
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
    gender, type, state, district, bioguide_id, opensecrets_id
)
reps_113_117 <- reps_113_117 %>% select(id)

full_reps <- right_join(full_reps, reps_113_117, by = c("bioguide_id" = "id"))

# DRY! DO THIS BETTER
# 113th congress
rep_113 <- rep_113 %>% select(id)
rep_113 <- right_join(full_reps, rep_113, by = c("bioguide_id" = "id"))
# before writing to csv, remove NA matches, those are reps who became senators
rep_113 <- rep_113 %>% filter(!is.na(opensecrets_id))
# 114th congress
rep_114 <- rep_114 %>% select(id)
rep_114 <- right_join(full_reps, rep_114, by = c("bioguide_id" = "id"))
rep_114 <- rep_114 %>% filter(!is.na(opensecrets_id))
# 115th congress
rep_115 <- rep_115 %>% select(id)
rep_115 <- right_join(full_reps, rep_115, by = c("bioguide_id" = "id"))
rep_115 <- rep_115 %>% filter(!is.na(opensecrets_id))
# 116th congress
rep_116 <- rep_116 %>% select(id)
rep_116 <- right_join(full_reps, rep_116, by = c("bioguide_id" = "id"))
rep_116 <- rep_116 %>% filter(!is.na(opensecrets_id))
# 117th congress
rep_117 <- rep_117 %>% select(id)
rep_117 <- right_join(full_reps, rep_117, by = c("bioguide_id" = "id"))
rep_117 <- rep_117 %>% filter(!is.na(opensecrets_id))



# write to csv
write.csv(full_reps, "data/cleaned/bioguide_full_reps.csv", row.names = FALSE)
write.csv(rep_113, "data/cleaned/bioguide_113_rep.csv", row.names = FALSE)
write.csv(rep_114, "data/cleaned/bioguide_114_rep.csv", row.names = FALSE)
write.csv(rep_115, "data/cleaned/bioguide_115_rep.csv", row.names = FALSE)
write.csv(rep_116, "data/cleaned/bioguide_116_rep.csv", row.names = FALSE)
write.csv(rep_117, "data/cleaned/bioguide_117_rep.csv", row.names = FALSE)
