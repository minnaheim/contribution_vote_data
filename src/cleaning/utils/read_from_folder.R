# read all csv files in dir and return a list of dataframes
read_from_folder <- function(folder_path) {
    # get all files in the folder
    files <- list.files(folder_path, full.names = TRUE)
    # read all files
    data <- lapply(files, read_csv)
    return(data)
}
