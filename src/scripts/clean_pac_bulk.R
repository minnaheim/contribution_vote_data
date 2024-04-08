#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
library(tidyverse)
source("src/cleaning/utils/bulk_cleaning_functions.R")

if (length(args) != 1) {
    stop("Usage: clean_pac_bulk.R <input_file>")
}

input_file <- args[1]


print("Input file:")
print(input_file)

df <- read_delim(
    input_file,
    delim = ",",
    col_names = c(
        "Cycle", "FECRecNo", "PACID", "CID", "Amount", "Date", "RealCode", "Type", "DI", "FECCandID"
    ),
    quote = "|",
    show_col_types = FALSE,
    lazy = TRUE
) |>
    select(c(Cycle, CID, RealCode, Date, Amount, Type)) |>
    filter(str_detect(RealCode, "^E"))

# get the file name from path without extension
file_name <- basename(input_file) |>
    str_remove("\\.txt")

file_out_name <- glue("./data/cleaned/semi_clean/{file_name}.csv")

print("Output file:")
print(file_out_name)

write.csv(df, file_out_name, row.names = FALSE)
