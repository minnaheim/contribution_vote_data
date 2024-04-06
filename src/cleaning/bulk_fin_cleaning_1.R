library(tidyverse)
source("src/cleaning/representatives_cleaning_2.R")
source("src/cleaning/utils/bulk_cleaning_functions.R")

# read in individual contributions
indivs20 <- indiv_basic_cleaning(20)
print("20 ind done")
indivs18 <- indiv_basic_cleaning(18)
print("18 ind done")
indivs16 <- indiv_basic_cleaning(16)
print("16 ind done")
indivs14 <- indiv_basic_cleaning(14)
print("14 ind done")
indivs12 <- indiv_basic_cleaning(12)
print("12 ind done")


# read in pac to candidate contribution data
pac20 <- pac_basic_cleaning(20)
print("20 pac done")
pac18 <- pac_basic_cleaning(18)
print("18 pac done")
pac16 <- pac_basic_cleaning(16)
print("16 pac done")
pac14 <- pac_basic_cleaning(14)
print("14 pac done")
pac12 <- pac_basic_cleaning(12)
print("12 pac done")

# indivs <- list(indivs12, indivs14, indivs16, indivs18, indivs20)
# pacs <- list(pac12, pac14, pac16, pac18, pac20)

# for (i in indivs) {
#     cycle <- str_sub(i, -2, -1)
#     write.csv(i, glue("data/cleaned/semi_clean/indivs{cycle}_semi_clean.csv"), row.names = FALSE)
# }

# for (i in pacs) {
#     cycle <- str_sub(i, -2, -1)
#     write.csv(i, glue("data/cleaned/semi_clean/pacs{cycle}_semi_clean.csv"), row.names = FALSE)
# }

write.csv(indivs20, "data/cleaned/semi_clean/indivs20_semi_clean.csv", row.names = FALSE)
write.csv(indivs18, "data/cleaned/semi_clean/indivs18_semi_clean.csv", row.names = FALSE)
write.csv(indivs16, "data/cleaned/semi_clean/indivs16_semi_clean.csv", row.names = FALSE)
write.csv(indivs14, "data/cleaned/semi_clean/indivs14_semi_clean.csv", row.names = FALSE)
write.csv(indivs12, "data/cleaned/semi_clean/indivs12_semi_clean.csv", row.names = FALSE)
write.csv(pac20, "data/cleaned/semi_clean/pac20_semi_clean.csv", row.names = FALSE)
write.csv(pac18, "data/cleaned/semi_clean/pac18_semi_clean.csv", row.names = FALSE)
write.csv(pac16, "data/cleaned/semi_clean/pac16_semi_clean.csv", row.names = FALSE)
write.csv(pac14, "data/cleaned/semi_clean/pac14_semi_clean.csv", row.names = FALSE)
write.csv(pac12, "data/cleaned/semi_clean/pac12_semi_clean.csv", row.names = FALSE)
