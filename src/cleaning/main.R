# if you want to regenerate the initial cleaning process, run the run_build_clean.sh script
source("src/cleaning/representatives_cleaning.R")
print("Done with representatives_cleaning_2.R")
source("src/cleaning/roll_call_cleaning.R")
print("Done with roll_call_cleaning.R")
source("src/cleaning/bulk_fin_cleaning.R")
print("Done with bulk_fin_cleaning.R")
source("src/cleaning/merge.R")
