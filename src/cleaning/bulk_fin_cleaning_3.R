library(tidyverse)
source("src/cleaning/utils/combine_columns.R")
source("src/cleaning/utils/bulk_cleaning_functions.R")
print("source files done")

# read in test data
# pac22 <- read_csv("data/cleaned/semi_clean/pac22_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# pac20 <- read_csv("data/cleaned/semi_clean/pac20_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# pac18 <- read_csv("data/cleaned/semi_clean/pac18_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# pac16 <- read_csv("data/cleaned/semi_clean/pac16_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# pac14 <- read_csv("data/cleaned/semi_clean/pac14_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# pac12 <- read_csv("data/cleaned/semi_clean/pac12_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# indivs22 <- read_csv("data/cleaned/semi_clean/indivs22_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# indivs20 <- read_csv("data/cleaned/semi_clean/indivs20_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# indivs18 <- read_csv("data/cleaned/semi_clean/indivs18_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# indivs16 <- read_csv("data/cleaned/semi_clean/indivs16_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# indivs14 <- read_csv("data/cleaned/semi_clean/indivs14_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
# indivs12 <- read_csv("data/cleaned/semi_clean/indivs12_semi_clean.csv", show_col_types = FALSE, lazy = TRUE)
rep_117 <- read_csv("data/cleaned/bioguide_117_rep.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/cleaned/bioguide_116_rep.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/cleaned/bioguide_115_rep.csv", show_col_types = FALSE)
rep_114 <- read_csv("data/cleaned/bioguide_114_rep.csv", show_col_types = FALSE)
rep_113 <- read_csv("data/cleaned/bioguide_113_rep.csv", show_col_types = FALSE)
print("read in")

# clean contributions for vote
contribs20 <- clean_contribs_for_vote(rep_117, "12-25-2020")
view(contribs20)
contribs18 <- clean_contribs_for_vote(rep_116, "12-19-2018")
view(contribs18)
print("contrib18 done")
contribs16_2 <- clean_contribs_for_vote(rep_115, "01-17-2018")
view(contribs16_2)
print("halfway")
contribs16 <- clean_contribs_for_vote(rep_115, "12-02-2017")
view(contribs16)
print("contrib16 done")
contribs14 <- clean_contribs_for_vote(rep_114, "01-12-2016")
view(contribs14)
contribs12 <- clean_contribs_for_vote(rep_113, "03-19-2013")
view(contribs12)



# determine number of appearance of each cycle
contribs14 %>%
    group_by(Cycle) %>%
    summarise(n = n()) %>%
    arrange(desc(n))
# 14
#   Cycle     n
#   <dbl> <int>
# 1  2018 25293
# 2  2020 19585
# 3  2016 12830

# 12
# A tibble: 4 × 2
#   Cycle     n
#   <dbl> <int>
# 1  2014 23542
# 2  2018 21699
# 3  2016 20393
# 4  2020 17830
