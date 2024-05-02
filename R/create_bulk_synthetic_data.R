
#' @Title Create Bulk Synthetic Data
#'
#' @description
#' Creates a series of waiting lists, one for each row in the dataframe
#' parameter and joins them together into one dataframe with relevant creation
#' criteria
#'
#' @param bulk
#'
#' @return Dataframe of waiting lists for each specified site and specialty,
#' opcs etc
#' @export
#'
#' @examples create_bulk_synthetic_data(bulk)

create_bulk_synthetic_data <- function(bulk){
result <- bulk |>
  purrr::pmap(create_waiting_list) |>
  dplyr::bind_rows()
return(result)
}