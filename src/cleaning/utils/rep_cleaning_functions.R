rep_cleaning <- function(dataset) {
    trimws(dataset)
    colnames(dataset) <- c("LastName", "FirstName", "State", "Party", "Chamber")
    dataset <- dataset %>% dplyr::filter(Chamber != "Senate")
    return(dataset)
}

# clean term-117
# create a function that deletes the row if it starts with "Picture of"
# del_picture_of <- function(dataset) {
#     dataset <- dataset %>% dplyr::filter(!grepl("Picture of", Representative))
#     return(dataset)
# }

# sep_cols <- function(dataset) {
#     dataset <- dataset %>% separate(Representative, into = c("Name", "Chamber", "Party-State-District"), sep = ",", extra = "merge")
#     return(dataset)
# }


# split_names <- function(dataset) {
#     dataset["Alias"] <- NA
#     dataset <- dataset %>% separate("Name", into = c("FirstName", "LastName"), sep = "\\s+(?=[^\\s]*$)", extra = "merge")
#     for (i in 1:nrow(dataset)) {
#         if (nchar(dataset$LastName[i]) <= 2) {
#             new_last_name <- strsplit(dataset$FirstName[i], " ")[[1]]
#             # remove new_last_name from FirstName
#             dataset$FirstName[i] <- paste(new_last_name[-length(new_last_name)], collapse = " ")
#             Alias <- dataset$LastName[i]
#             dataset$LastName[i] <- new_last_name[length(new_last_name)]
#             dataset$Alias[i] <- Alias
#         }
#     }
#     dataset$LastName <- ifelse(nchar(dataset$LastName) <= 2, dataset$FirstName, dataset$LastName)
#     dataset$FirstName <- ifelse(nchar(dataset$LastName) <= 2, dataset$Alias, dataset$FirstName)
#     return(dataset)
# }

# md_as_alias <- function(dataset) {
#     for (i in 1:nrow(dataset)) {
#         if (dataset$LastName[i] == "M.D.") {
#             new_last_name <- strsplit(dataset$FirstName[i], " ")[[1]]
#             # remove new_last_name from FirstName
#             dataset$FirstName[i] <- paste(new_last_name[-length(new_last_name)], collapse = " ")
#             dataset$Alias[i] <- dataset$LastName[i]
#             dataset$LastName[i] <- new_last_name[length(new_last_name)]
#         }
#     }
#     return(dataset)
# }

# jr_as_alias <- function(dataset) {
#     for (i in 1:nrow(dataset)) {
#         if (dataset$LastName[i] == "Jr.") {
#             new_last_name <- strsplit(dataset$FirstName[i], " ")[[1]]
#             # remove new_last_name from FirstName
#             dataset$FirstName[i] <- paste(new_last_name[-length(new_last_name)], collapse = " ")
#             dataset$Alias[i] <- dataset$LastName[i]
#             dataset$LastName[i] <- new_last_name[length(new_last_name)]
#         }
#     }
#     return(dataset)
# }

# nr_as_alias <- function(dataset) {
#     for (i in 1:nrow(dataset)) {
#         if (dataset$LastName[i] == "III") {
#             new_last_name <- strsplit(dataset$FirstName[i], " ")[[1]]
#             # remove new_last_name from FirstName
#             dataset$FirstName[i] <- paste(new_last_name[-length(new_last_name)], collapse = " ")
#             dataset$Alias[i] <- dataset$LastName[i]
#             dataset$LastName[i] <- new_last_name[length(new_last_name)]
#         }
#     }
#     return(dataset)
# }

# sep_party_cols <- function(dataset) {
#     dataset <- dataset %>%
#         separate("Party-State-District", into = c("PartyState", "District"), sep = "\\s+", extra = "merge") %>%
#         mutate(PartyState = ifelse(grepl("Representative", PartyState), gsub("Representative", "", PartyState), PartyState))
#     # for (i in 1:nrow(dataset)) {
#     #     if ("Representative" %in% (dataset$"Party-State"[i])) {
#     #         dataset$"Party-State"[i] <- gsub("Representative", "", dataset$"Party-State"[i])
#     #     }
#     # }
#     return(dataset)
# }

# clean_117 <- function(dataset) {
#     dataset <- del_picture_of(dataset)
#     dataset <- sep_cols(dataset)
#     dataset <- split_names(dataset)
#     dataset <- md_as_alias(dataset)
#     dataset <- jr_as_alias(dataset)
#     dataset <- nr_as_alias(dataset)
#     return(dataset)
# }

# cleaning 113th reps
remove_cols <- function(dataset) {
    dataset <- dataset %>% select(sort_name, group, area_id)
    return(dataset)
}

sep_cols_rename <- function(dataset) {
    dataset <- separate(dataset, "sort_name", into = c("LastName", "FirstName"), sep = ", ")
    dataset <- separate(dataset, "area_id", into = c("State", "District"), sep = "-")
    dataset <- dataset %>% rename("Party" = "group")
    return(dataset)
}
