library(tidyverse)
library(conflicted)
source("src/cleaning/utils/combine_columns.R")
source("src/cleaning/utils/bulk_cleaning_functions.R")

# read in test data (contributions are read in, in the cleaning function file)
rep_117 <- read_csv("data/cleaned/bioguide_117_rep.csv", show_col_types = FALSE)
rep_116 <- read_csv("data/cleaned/bioguide_116_rep.csv", show_col_types = FALSE)
rep_115 <- read_csv("data/cleaned/bioguide_115_rep.csv", show_col_types = FALSE)
rep_114 <- read_csv("data/cleaned/bioguide_114_rep.csv", show_col_types = FALSE)
rep_113 <- read_csv("data/cleaned/bioguide_113_rep.csv", show_col_types = FALSE)

# clean contributions for vote
contribs20 <- clean_contribs_for_vote(rep_117, "12-25-2020")
contribs18 <- clean_contribs_for_vote(rep_116, "12-19-2018")
contribs16_2 <- clean_contribs_for_vote(rep_115, "01-17-2018")
contribs16 <- clean_contribs_for_vote(rep_115, "12-02-2017")
contribs14 <- clean_contribs_for_vote(rep_114, "01-12-2016")
contribs12 <- clean_contribs_for_vote(rep_113, "03-19-2013")


# clean industry, keep only relevant and determine which are good energy, and which are bad
determine_industry <- function(contributions) {
    industry_type <- rep(NA, nrow(contributions)) # initialize Industry_Type vector

    for (i in 1:nrow(contributions)) {
        if (contributions$RealCode[i] %in% c("E0000", "E1500", "E2000")) {
            industry_type[i] <- "+"
        } else {
            industry_type[i] <- "-"
        }
    }
    # Add the Industry_Type column to the filtered dataframe
    contributions$Industry_Type <- industry_type
    # Filter out rows with RealCode in ("E4000", "E5000", "E4100", "E4200")
    contributions <- contributions[!(contributions$RealCode %in% c("E4000", "E5000", "E4100", "E4200")), ]
    return(contributions)
}
contribs20 <- determine_industry(contribs20)
contribs18 <- determine_industry(contribs18)
contribs16_2 <- determine_industry(contribs16_2)
contribs16 <- determine_industry(contribs16)
contribs14 <- determine_industry(contribs14)
contribs12 <- determine_industry(contribs12)
view(contribs12)
# view(contribs20)

# summarise the contributions by type per representative (use summarize to
# keep only relevant rows, but add original data back to keep the other cols)

# create function which summarises the contributions by type
summarise_contribs <- function(contributions) {
    contributions_summarized <- contributions %>%
        group_by(last_name, first_name, state, opensecrets_id, bioguide_id, Industry_Type, district) %>%
        summarise(total = sum(Amount)) %>%
        ungroup() %>%
        group_by(last_name, first_name, state, opensecrets_id, bioguide_id, district) %>%
        complete(Industry_Type = c("-", "+"), fill = list(total = 0)) %>%
        ungroup()
    return(contributions_summarized)
}
contribs12_summarized <- summarise_contribs(contribs12)
contribs14_summarized <- summarise_contribs(contribs14)
contribs16_summarized <- summarise_contribs(contribs16)
contribs16_2_summarized <- summarise_contribs(contribs16_2)
contribs18_summarized <- summarise_contribs(contribs18)
contribs20_summarized <- summarise_contribs(contribs20)

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

write.csv(contribs12_summarized, "data/cleaned/contribs12_summarized.csv", row.names = FALSE)
write.csv(contribs14_summarized, "data/cleaned/contribs14_summarized.csv", row.names = FALSE)
write.csv(contribs16_summarized, "data/cleaned/contribs16_summarized.csv", row.names = FALSE)
write.csv(contribs16_2_summarized, "data/cleaned/contribs16_2_summarized.csv", row.names = FALSE)
write.csv(contribs18_summarized, "data/cleaned/contribs18_summarized.csv", row.names = FALSE)
write.csv(contribs20_summarized, "data/cleaned/contribs20_summarized.csv", row.names = FALSE)
write.csv(contribs_wide, "data/cleaned/contribs_wide.csv", row.names = FALSE)
write.csv(contribs_long, "data/cleaned/contribs_long.csv", row.names = FALSE)

# determine number of appearance of each cycle
# contribs20 %>%
#     group_by(Cycle) %>%
#     summarise(n = n()) %>%
#     arrange(desc(n))

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
