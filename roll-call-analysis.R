library(tidyverse)
# install.packages("conflicted")
library(conflicted)

# import roll call data of the 3 "offshore drilling subsidies" bills:
methane_114 <- read_csv("data/methane-pollution-safeguards-114.csv",
    show_col_types = FALSE
)
methane_115 <- read_csv("data/methane-pollution-safeguards-115.csv",
    show_col_types = FALSE
)
methane_116 <- read_csv("data/methane-pollution-safeguards-116.csv",
    show_col_types = FALSE
)

# inspect datasets

# view(methane_114)
# view(methane_115)
# view(methane_116)

# create merged dataset - merge based on representative (votes)

# try with sample dataset
sample_114 <- methane_114[1:10, ]
view(sample_114)



methane <- full_join(methane_114, methane_115)
# view(methane)

# determine mind changers
