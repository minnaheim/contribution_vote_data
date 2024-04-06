# try importing historical congress members
hist_reps <- read_delim("data/original/representatives/hist_reps.csv", show_col_types = FALSE)
# view(hist_reps)
# no ID column which contains people sessions which these people participated in, so i will just incl. all born


# import current congress members
curr_reps <- read_delim("data/original/representatives/curr_reps.csv", show_col_types = FALSE)
# view(curr_reps)


full_reps <- bind_rows(hist_reps, curr_reps)
# view(full_reps)

# now that we have the full representatives, we need to remove senators and only keep those, which were in sessions 113-117.
full_reps <- full_reps %>% dplyr::filter(type == "rep")
# view(full_reps)

# now we need to remove all representatives which were not in sessions 113-117
# use bioguide_id to merge, those are most complete.
# import sessions

reps_113_117 <- read_delim("data/original/representatives/rep_113-117_bioguide.csv", show_col_types = FALSE)
# reps_113_117 is the clean df of all reps who appeared/were in the 113, 114, 115,116,117th session (not only all, but also one).
#  = 739 members
# view(reps_113_117)



# keep only cols of full_rep, whose bioguide_id or id is in the reps_113_117.
# DO THIS THE CORRECT WAY, INSIDE JOIN!
full_reps <- full_reps %>% select(
    last_name, first_name, birthday,
    gender, type, state, district, bioguide_id, opensecrets_id
)
reps_113_117 <- reps_113_117 %>% select(id)

full_reps <- right_join(full_reps, reps_113_117, by = c("bioguide_id" = "id"))
# view(full_reps)

# write to csv
write.csv(full_reps, "data/cleaned/bioguide_full_reps.csv", row.names = FALSE)
