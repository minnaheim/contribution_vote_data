## merge fin rep document
# SET UP
library(tidyverse)
library(fuzzyjoin)
library(stringdist)

# import data cleaning pipeline:
source("src/cleaning/utils/fin_cleaning_functions.R")
source("src/cleaning/utils/roll_call_cleaning_functions.R")
source("src/cleaning/utils/read_from_folder.R")
# source("src/cleaning/utils/rep_cleaning_functions.R")
