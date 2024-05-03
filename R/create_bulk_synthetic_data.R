
#' @title Create Bulk Synthetic Data
#'
#' @description
#' Creates a series of waiting lists, one for each row in the dataframe
#' parameter and joins them together into one dataframe with relevant creation
#' criteria
#'
#' @param bulk_data A dataframe object, each row being a waiting list with
#'  parameters to generate the synthetic data. A sample data.frame is available
#'  as demo-data
#'
#' @return Dataframe of waiting lists for each specified site and specialty,
#' opcs etc
#' @export
#'
#' @examples create_bulk_synthetic_data(demo_df)

create_bulk_synthetic_data <- function(bulk_data) {
  result <- bulk_data |>
    purrr::pmap(create_waiting_list) |>
    dplyr::bind_rows()
  return(result)
}