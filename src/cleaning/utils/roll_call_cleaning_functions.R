# create function to clean the representatives dataset,
# clean rep dataset, split sort_name by ,
rep_name_split_keep_imp_cols <- function(rep) {
    # split sort_name by ,
    rep[c("Last", "First")] <- str_split_fixed(rep$sort_name, ",", 2)

    # select only important cols
    rep <- rep %>% select(Last, First, group_id, area_id, )

    return(rep)
}
