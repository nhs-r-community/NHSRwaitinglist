
create_bulk_data <- function(bulk){
result <- bulk |>
  purrr::pmap(create_waiting_list) |>
  dplyr::bind_rows()
return(result)
}