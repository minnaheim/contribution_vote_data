library(tidyverse)
source("src/cleaning/representatives_cleaning_2.R")

# read in the cleaned rep id data
indivs20 <- read_csv("data/cleaned/semi_clean/indivs20_semi_clean.csv", show_col_types = FALSE)
indivs18 <- read_csv("data/cleaned/semi_clean/indivs18_semi_clean.csv", show_col_types = FALSE)
indivs16 <- read_csv("data/cleaned/semi_clean/indivs16_semi_clean.csv", show_col_types = FALSE)
indivs14 <- read_csv("data/cleaned/semi_clean/indivs14_semi_clean.csv", show_col_types = FALSE)
indivs12 <- read_csv("data/cleaned/semi_clean/indivs12_semi_clean.csv", show_col_types = FALSE)
pac20 <- read_csv("data/cleaned/semi_clean/pac20_semi_clean.csv", show_col_types = FALSE)
pac18 <- read_csv("data/cleaned/semi_clean/pac18_semi_clean.csv", show_col_types = FALSE)
pac16 <- read_csv("data/cleaned/semi_clean/pac16_semi_clean.csv", show_col_types = FALSE)
pac14 <- read_csv("data/cleaned/semi_clean/pac14_semi_clean.csv", show_col_types = FALSE)
pac12 <- read_csv("data/cleaned/semi_clean/pac12_semi_clean.csv", show_col_types = FALSE)
# id_full_reps <- read_csv("data/cleaned/bioguide_full_reps.csv", show_col_types = FALSE)


# execute the clean_contributions function on the individual and pac contributions
indivs20_filtered <- clean_contributions(indivs20, "06-25-2020") # election for 117th congress, vote date: 26/06/2020
pac20_filtered <- clean_contributions(pac20, "06-25-2020")
indivs18_filtered <- clean_contributions(indivs18, "06-19-2018") # election for 116th congress, vote date: 20/06/2019
pac18_filtered <- clean_contributions(pac18, "06-19-2018")
indivs16_filtered <- clean_contributions(indivs16, "06-23-2017") # election for the 115th congress, vote date: JUL 18, 2018
pac16_filtered <- clean_contributions(pac16, "06-23-2017")
indivs14_filtered <- clean_contributions(indivs14, "07-12-2015") # election for the 114th congress, vote date: JUL 13, 2016
pac14_filtered <- clean_contributions(pac14, "07-12-2015")
indivs12_filtered <- clean_contributions(indivs12, "11-19-2012") # election for the 113th congress, vote date: NOV 20, 2013
pac12_filtered <- clean_contributions(pac12, "11-19-2012")

# write to csv
write.csv(indivs20_filtered, "data/cleaned/indivs20_filtered.csv", row.names = FALSE)
write.csv(indivs18_filtered, "data/cleaned/indivs18_filtered.csv", row.names = FALSE)
write.csv(indivs16_filtered, "data/cleaned/indivs16_filtered.csv", row.names = FALSE)
write.csv(indivs14_filtered, "data/cleaned/indivs14_filtered.csv", row.names = FALSE)
write.csv(indivs12_filtered, "data/cleaned/indivs12_filtered.csv", row.names = FALSE)
write.csv(pac20_filtered, "data/cleaned/pac20_filtered.csv", row.names = FALSE)
write.csv(pac18_filtered, "data/cleaned/pac18_filtered.csv", row.names = FALSE)
write.csv(pac16_filtered, "data/cleaned/pac16_filtered.csv", row.names = FALSE)
write.csv(pac14_filtered, "data/cleaned/pac14_filtered.csv", row.names = FALSE)
write.csv(pac12_filtered, "data/cleaned/pac12_filtered.csv", row.names = FALSE)

# ADD TO PLOTS FILE
# plot the distribution of the amount of E contributions by date
indivs20_filtered_e <- indivs20 %>%
    filter(str_detect(RealCode, "^E"))


plot_E_1y_prior <- indivs20_filtered_e %>%
    ggplot(aes(x = Date, y = RealCode)) +
    geom_point() +
    geom_smooth() +
    labs(
        title = "Amount of E contributions by date - 1 year prior to vote is the line",
        x = "Date",
        y = "Amount"
    ) +
    geom_vline(xintercept = as.numeric(cutoff_date_1)) # Add a vertical line for the cutoff date

plot_E_1y_prior


plot_E_6mo_prior <- indivs20_filtered_e %>%
    ggplot(aes(x = Date, y = RealCode)) +
    geom_point() +
    geom_smooth() +
    labs(
        title = "Amount of E contributions by date - 16 months prior to vote is the line",
        x = "Date",
        y = "Amount"
    ) +
    geom_vline(xintercept = as.numeric(cutoff_date_2)) # Add a vertical line for the cutoff date

plot_E_6mo_prior
