# SET UP
library(tidyverse)
library(ggplot2)

# IMPORT DATASETS
contribution_for_114 <- read_csv("data/oil_gas_contribution-2013-2014.csv",
    show_col_types = FALSE
)
contribution_for_115 <- read_csv("data/oil_gas_contribution-2015-2016.csv",
    show_col_types = FALSE
)
contribution_for_116 <- read_csv("data/oil_gas_contribution-2017-2018.csv",
    show_col_types = FALSE
)

# CLEAN DATA
# 114th Congress
# remove $ and transform to numeric
contribution_for_114$Amount <- as.numeric(sub("\\$", "", contribution_for_114$Amount))

# separate political affiliation, in () into new column.
contribution_for_114$Party <- gsub(".*\\((.*?)\\).*", "\\1", contribution_for_114$Representative)

contribution_for_114$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", contribution_for_114$Representative)

# split the representatives column of contribution _144 into the columns LastName and FirstName.
contribution_for_114 <- extract(contribution_for_114, Representative, c("LastName", "FirstName"), "([^ ]+) (.*)")

# split Party and state-abbreviation into separate columns.
contribution_for_114 <- separate(contribution_for_114, Party, into = c("Party", "StateAbbreviation"), sep = "-")

# relocate Party and StateAbbreviation columns to after Names
contribution_for_114 <- contribution_for_114 %>% relocate(Party, StateAbbreviation, .after = FirstName)

view(contribution_for_114)

# 115th Congress
# remove $ and transform to numeric
contribution_for_115$Amount <- as.numeric(sub("\\$", "", contribution_for_115$Amount))

# separate political affiliation, in () into new column.
contribution_for_115$Party <- gsub(".*\\((.*?)\\).*", "\\1", contribution_for_115$Representative)

contribution_for_115$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", contribution_for_115$Representative)

# split the representatives column of contribution _144 into the columns LastName and FirstName.
contribution_for_115 <- extract(contribution_for_115, Representative, c("LastName", "FirstName"), "([^ ]+) (.*)")

# split Party and state-abbreviation into separate columns.
contribution_for_115 <- separate(contribution_for_115, Party, into = c("Party", "StateAbbreviation"), sep = "-")

# relocate Party and StateAbbreviation columns to after Names
contribution_for_115 <- contribution_for_115 %>% relocate(Party, StateAbbreviation, .after = FirstName)

view(contribution_for_115)


# 116th Congress
# remove $ and transform to numeric
contribution_for_116$Amount <- as.numeric(sub("\\$", "", contribution_for_116$Amount))

# separate political affiliation, in () into new column.
contribution_for_116$Party <- gsub(".*\\((.*?)\\).*", "\\1", contribution_for_116$Representative)

contribution_for_116$Representative <- gsub("\\s*\\(.*?\\)\\s*", "", contribution_for_116$Representative)

# split the representatives column of contribution _144 into the columns LastName and FirstName.
contribution_for_116 <- extract(contribution_for_116, Representative, c("LastName", "FirstName"), "([^ ]+) (.*)")

# split Party and state-abbreviation into separate columns.
contribution_for_116 <- separate(contribution_for_116, Party, into = c("Party", "StateAbbreviation"), sep = "-")

# relocate Party and StateAbbreviation columns to after Names
contribution_for_116 <- contribution_for_116 %>% relocate(Party, StateAbbreviation, .after = FirstName)

view(contribution_for_116)


# QUICK PLOTS
# plot_114 <- plot(contribution_for_114$Amount, main = "Oil and Gas Contributions to 114th Congress", xlab = "Representative", ylab = "Amount", col = "blue", pch = 19)

# plot_115 <- plot(contribution_for_115$Amount, main = "Oil and Gas Contributions to 115th Congress", xlab = "Representative", ylab = "Amount", col = "blue", pch = 19)

# plot_116 <- plot(contribution_for_116$Amount, main = "Oil and Gas Contributions to 116th Congress", xlab = "Representative", ylab = "Amount", col = "blue", pch = 19)


# check for NAs
which(is.na(amount_114))

# COMPARE 3 CONGRESSES
amount_114 <- contribution_for_114$Amount
amount_115 <- contribution_for_115$Amount
amount_116 <- contribution_for_116$Amount

# all_plot <- ggplot() +
#     geom_line(data = amount_114, aes(x = Amount, y = id), color = "green") +
#     geom_line(data = amount_115, aes(x = Amount, y = id), color = "red") +
#     geom_line(data = amount_116, aes(x = Amount, y = id), color = "blue")

# all_plot
