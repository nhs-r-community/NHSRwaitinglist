#' @title A Demo 'data.frame' Object
#'
#' @description A pre-created data.frame ready to be used to test the
#' create_bulk_synthetic_data and create_waiting_list functions. Each row of
#' the data.frame represents an individual waiting list for which the site,
#' specialty, OPCS code(s) and respective mean wait, arrival rate, start_date,
#' sd and rott can be specified. It allows the user to see an example of the
#' structure of the data.frame required by the create_bulk_synthetic_data
#' function to create your synthetic dataset.
#'
#' @format A dataframe with 5 rows and 9 columns:
#' \describe{
#'\item{hospital_site}{Character. Hospital site code of the waiting list.}
#'\item{main_spec_code}{Numeric. Main specialty code of the waiting list.}
#'\item{opcs4_code}{Character. OPCS4 code(s) of the procedure(s) on the waiting
#' list.}
#'\item{n}{Numeric. Number of days for which to create synthetic waiting
#'   list data.}
#'\item{mean_arrival_rate}{Numeric. Mean number of arrivals per day.}
#'\item{mean_wait}{Numeric. Mean wait time for treatment/on waiting list.}
#'\item{start_date}{Character. Date from which to start generated waiting
#'   list in format yyyy-mm-dd.}
#'\item{sd}{Numeric. Standard deviation.}
#'\item{rott}{Numeric. Proportion of referrals to be randomly flagged as ROTT}
#' }
"demo_df"
