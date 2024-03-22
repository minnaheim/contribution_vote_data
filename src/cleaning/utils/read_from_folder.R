# library("tuple")

# read all csv files in dir and return a list of dataframes
read_from_folder <- function(folder_path) {
    # get all files in the folder
    files <- list.files(folder_path, full.names = TRUE)
    # view(files)
    # read all files (use show_col_types = FALSE)
    data <- suppressMessages(lapply(files, read_csv, show_col_types = FALSE))
    # view(data)

    return(data)
}
