
#' @Title  Create Bulk Dataframe Sample
#'
#' @Description
#' A function to create a bulk dataframe sample to test the
#' create_bulk_synthetic_data and create_waiting_list functions
#'
#' @return Dataframe for use with the create_waiting_list function and
#' create_bulk_synthetic_data to specify the sites and specialties and respective
#' mean wait and arrival rates. This dataframe could instead be generated outside
#' the package, using real data
#' @export
#'
#' @examples create_bulk_dataframe_sample()
#'
#'
#'
create_bulk_dataframe_sample <- function(){
bulk <- data.frame(hospital_sites=c("ABC001","DHR70","JRW20","RFW002","DHR70"),
                   specialties = c(100,110,120,130,100),
                   opcs4_code = c("A","B","C","D","A"),
                   n= 366,
                   mean_arrival_rate= c(50,25,20,40,50),
                   mean_wait = c(21,20,10,30,21),
                   start_date = c("2024-01-01","2023-04-01","2024-04-01","2023-01-01","2024-01-01"),
                   sd=10,
                   rott=c(0,0.1,0.05,0.2,0.1)
)
return(bulk)
}