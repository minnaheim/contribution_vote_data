library(tidyverse)
source("src/cleaning/utils/bulk_cleaning_functions.R")
source("src/cleaning/utils/combine_columns.R")

# read in the cleaned rep id data
indivs22 <- read_csv("data/cleaned/semi_clean/indivs22.csv", show_col_types = FALSE, lazy = TRUE)
indivs20 <- read_csv("data/cleaned/semi_clean/indivs20.csv", show_col_types = FALSE, lazy = TRUE)
indivs18 <- read_csv("data/cleaned/semi_clean/indivs18.csv", show_col_types = FALSE, lazy = TRUE)
indivs16 <- read_csv("data/cleaned/semi_clean/indivs16.csv", show_col_types = FALSE, lazy = TRUE)
indivs14 <- read_csv("data/cleaned/semi_clean/indivs14.csv", show_col_types = FALSE, lazy = TRUE)
indivs12 <- read_csv("data/cleaned/semi_clean/indivs12.csv", show_col_types = FALSE, lazy = TRUE)
pac22 <- read_csv("data/cleaned/semi_clean/pacs22.csv", show_col_types = FALSE, lazy = TRUE)
pac20 <- read_csv("data/cleaned/semi_clean/pacs20.csv", show_col_types = FALSE, lazy = TRUE)
pac18 <- read_csv("data/cleaned/semi_clean/pacs18.csv", show_col_types = FALSE, lazy = TRUE)
pac16 <- read_csv("data/cleaned/semi_clean/pacs16.csv", show_col_types = FALSE, lazy = TRUE)
pac14 <- read_csv("data/cleaned/semi_clean/pacs14.csv", show_col_types = FALSE, lazy = TRUE)
pac12 <- read_csv("data/cleaned/semi_clean/pacs12.csv", show_col_types = FALSE, lazy = TRUE)
# read in rep data
id_full_reps <- read_csv("data/cleaned/bioguide_full_reps.csv", show_col_types = FALSE)
rep_113 <- read_csv("data/cleaned/bioguide_113_rep.csv", show_col_types = FALSE)
rep_114 <- read_csv("data/cleaned/bioguide_114_rep.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/cleaned/bioguide_115_rep.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/cleaned/bioguide_116_rep.csv", show_col_types = FALSE)
rep_117 <- read_csv("data/cleaned/bioguide_117_rep.csv", show_col_types = FALSE)
print("read in")


# execute the clean_contributions function on the individual and pac contributions
indivs20_filtered <- clean_ind_contributions(indivs20, "06-25-2020") # election for 117th congress, vote date: 26/06/2020
pac20_filtered <- clean_contributions(pac20, "06-25-2020")
indivs18_filtered <- clean_ind_contributions(indivs18, "06-19-2018") # election for 116th congress, vote date: 20/06/2019
print("indivs18")
# view(indivs18_filtered)
pac18_filtered <- clean_contributions(pac18, "06-19-2018")
indivs16_filtered <- clean_ind_contributions(indivs16, "06-23-2017") # election for the 115th congress, vote date: JUL 18, 2018
pac16_filtered <- clean_contributions(pac16, "06-23-2017")
indivs14_filtered <- clean_ind_contributions(indivs14, "07-12-2015") # election for the 114th congress, vote date: JUL 13, 2016
# view(indivs14_filtered)
pac14_filtered <- clean_contributions(pac14, "07-12-2015") # JUL 13, 2016
# view(pac14_filtered)
print("pac14")
indivs12_filtered <- clean_ind_contributions(indivs12, "11-19-2012") # election for the 113th congress, vote date: NOV 20, 2013
pac12_filtered <- clean_contributions(pac12, "11-19-2012")


# combine individual and pac contributions by concatinating, combine ID cols
# keep only those contributions which belong to future  representatives of that congress
contribs12 <- combine_contributions(indivs12_filtered, pac12_filtered, rep_113)
# contribs14 <- combine_contributions(indivs14_filtered, pac14_filtered, rep_114)
# contribs16 <- combine_contributions(indivs16_filtered, pac16_filtered, rep_115)
contribs18 <- combine_contributions(indivs18_filtered, pac18_filtered, rep_116)
contribs20 <- combine_contributions(indivs20_filtered, pac20_filtered, rep_117)
# all good here, progression from 12, to 18,20 is a lot more contributions,
# i.e. from 270 to 8000. and 14,16 dont work because 0 contributions.




# write to csv
# write.csv(indivs20_filtered, "data/cleaned/indivs20_filtered.csv", row.names = FALSE)
# write.csv(indivs18_filtered, "data/cleaned/indivs18_filtered.csv", row.names = FALSE)
# write.csv(indivs16_filtered, "data/cleaned/indivs16_filtered.csv", row.names = FALSE)
# write.csv(indivs14_filtered, "data/cleaned/indivs14_filtered.csv", row.names = FALSE)
# write.csv(indivs12_filtered, "data/cleaned/indivs12_filtered.csv", row.names = FALSE)
# write.csv(pac20_filtered, "data/cleaned/pac20_filtered.csv", row.names = FALSE)
# write.csv(pac18_filtered, "data/cleaned/pac18_filtered.csv", row.names = FALSE)
# write.csv(pac16_filtered, "data/cleaned/pac16_filtered.csv", row.names = FALSE)
# write.csv(pac14_filtered, "data/cleaned/pac14_filtered.csv", row.names = FALSE)
# write.csv(pac12_filtered, "data/cleaned/pac12_filtered.csv", row.names = FALSE)



# ADD TO PLOTS FILE
# plot the distribution of the amount of E contributions by date
indivs20_filtered_e <- indivs20 %>%
    filter(str_detect(RealCode, "^E"))
cutoff_date_1 <- "06-25-2020"

# plot_E_1y_prior <- indivs20_filtered_e %>%
#     ggplot(aes(x = Date, y = RealCode)) +
#     geom_point() +
#     geom_smooth() +
#     labs(
#         title = "Amount of E contributions by date - 1 year prior to vote is the line",
#         x = "Date",
#         y = "Amount"
#     ) +
#     geom_vline(xintercept = as.numeric(cutoff_date_1)) # Add a vertical line for the cutoff date

# plot_E_1y_prior


# cutoff_date_2 <- "12-25-2020"
# plot_E_6mo_prior <- indivs20_filtered_e %>%
#     ggplot(aes(x = Date, y = RealCode)) +
#     geom_point() +
#     geom_smooth() +
#     labs(
#         title = "Amount of E contributions by date - 16 months prior to vote is the line",
#         x = "Date",
#         y = "Amount"
#     ) +
#     geom_vline(xintercept = as.numeric(cutoff_date_2)) # Add a vertical line for the cutoff date

# plot_E_6mo_prior
