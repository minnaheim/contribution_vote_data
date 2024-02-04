library(tidyverse)
library(dplyr)

# inspecting DIME database bills
setwd("/Users/minna/Desktop/HSG/Economics/BA_Thesis/code/data")
bills <- read.csv("bills_db.csv")
view(bills)

# looking for bills concerning energy & environmental aspects
# bills_env_eng <- bills %>% filter(bills$tw.environment != 0 & bills$tw.energy != 0)
# view(bills_env_eng)

# looking for bills which have pos. effects on energy & environment

# good_bills_env <- bills %>% filter(bills$tw.environment > 0.1)
# view(good_bills_env)

# inspecting the dataset on votes
# votes <- read.csv("vote_db.csv")
# view(votes)

# import congressional texts
# text <- read.csv("text_db.csv")
# view(text)

# import new dataset with contribution data from dime in 2010
contributions <- read.csv("contribDB_2010.csv")
head(contributions)
