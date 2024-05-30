library(tidyverse)
library(conflicted)
library(stats)
source("src/cleaning/utils/combine_columns.R")
source("src/cleaning/utils/bulk_cleaning_functions.R")

# read in test data (contributions are read in, in the cleaning function file)
rep_117 <- read_csv("data/cleaned/bioguide_117_rep.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/cleaned/bioguide_116_rep.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/cleaned/bioguide_115_rep.csv", show_col_types = FALSE)
rep_114 <- read_csv("data/cleaned/bioguide_114_rep.csv", show_col_types = FALSE)
rep_113 <- read_csv("data/cleaned/bioguide_113_rep.csv", show_col_types = FALSE)
# view(rep_113)

# clean contributions for vote
contribs20 <- clean_contribs_for_vote(rep_117, "12-25-2020")
contribs18 <- clean_contribs_for_vote(rep_116, "12-19-2018")
contribs16_2 <- clean_contribs_for_vote(rep_115, "01-17-2018")
contribs16 <- clean_contribs_for_vote(rep_115, "12-02-2017")
contribs14 <- clean_contribs_for_vote(rep_114, "01-12-2016")
contribs12 <- clean_contribs_for_vote(rep_113, "03-19-2013")


# before determining whether the industry is pro environmental or anti environmental,
# use k-means to associate contributions without my biases.
# view(contribs12)
# contribs12 <- contribs12 %>%
#     select(c("RealCode", "total")) %>%
#     mutate_all(as.numeric) %>%
#     na.omit()
# df <- df %>%
#     kmeans(contribs12$total, centers = 2) # 1 = pro, 2 = anti

contribs20 <- determine_industry(contribs20)
contribs18 <- determine_industry(contribs18)
contribs16_2 <- determine_industry(contribs16_2)
contribs16 <- determine_industry(contribs16)
contribs14 <- determine_industry(contribs14)
contribs12 <- determine_industry(contribs12)
view(contribs12)


contribs12_summarized <- summarise_contribs(contribs12)
contribs14_summarized <- summarise_contribs(contribs14)
contribs16_summarized <- summarise_contribs(contribs16)
contribs16_2_summarized <- summarise_contribs(contribs16_2)
contribs18_summarized <- summarise_contribs(contribs18)
contribs20_summarized <- summarise_contribs(contribs20)
# view(contribs12_summarized)

# merge together wide format, to merge with rollcall data
contribs_long <- bind_rows(list(
    "3" = contribs12_summarized, "4" = contribs14_summarized,
    "51" = contribs16_summarized, "52" = contribs16_2_summarized,
    "6" = contribs18_summarized, "7" = contribs20_summarized
), .id = "corresponding_vote")
# view(contribs_long)

# pivot to wide format
contribs_wide <- contribs_long %>%
    pivot_wider(
        names_from = c(corresponding_vote, Industry_Type), # -> in case you want to pivot by 2 cols
        # names_from = corresponding_vote,
        values_from = total, names_prefix = "Contribution_"
    )
# view(contribs_wide)

# rename cols from + and - to _plus and _minus
contribs_wide <- contribs_wide %>% rename_with(~ str_replace(., "\\+", "plus"))
contribs_wide <- contribs_wide %>% rename_with(~ str_replace(., "-", "minus"))

# relocate ID cols
contribs_wide <- contribs_wide %>% relocate(bioguide_id, opensecrets_id)
view(contribs_wide)


write.csv(contribs_wide, "data/cleaned/contribs_wide.csv", row.names = FALSE)
write.csv(contribs_long, "data/cleaned/contribs_long.csv", row.names = FALSE)

view(contribs16_2)
# determine number of appearance of each cycle
contribs16_2 %>%
    group_by(Cycle) %>%
    summarise(n = n()) %>%
    arrange(desc(n))

# 20
#   Cycle     n
#   <dbl> <int>
# 1  2022  4965
# 2  2020    34

# 18
#   Cycle     n
#   <dbl> <int>
# 1  2020  5191
# 2  2018    30

# 16_2
# A tibble: 2 × 2
#   Cycle     n
#   <dbl> <int>
# 1  2018  7749
# 2    NA    44

# 16
#   Cycle     n
#   <dbl> <int>
# 1  2018  7148

# 14
#   Cycle     n
#   <dbl> <int>
# 1  2016  7142
# 2  2018     1

# 12
# A tibble: 1 × 2
#   Cycle     n
#   <dbl> <int>
# 1  2014  7085
