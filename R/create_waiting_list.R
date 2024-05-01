#' @title Create Waiting List
#'
#' @description
#' A function to create a waiting list using parameters
#'
#' Target Capacity = Demand + 2 * ( 1 + 4 * F ) / Target Wait
#' F defaults to 1.
#'
#' @param n Numeric value of rate of demand in same units as target wait -
#' e.g. if target wait is weeks, then demand in units of patients/week.
#' @param mean_arrival_date Numeric value of number of weeks that has been set
#'  as the target within which the patient should be seen.
#' @param mean_wait Variability coefficient, F = V/C * (D/C)^2 where C is the
#' current number of operations per week; V is the current variance in the number
#'  of operations per week; D is the observed demand. Defaults to 1.
#' @param start_date Variability coefficient, F = V/C * (D/C)^2 where C is the
#' current number of operations per week; V is the current variance in the number
#'  of operations per week; D is the observed demand. Defaults to 1.
#'
#' @return A tibble blah blah
#' @export
#'
#' @examples
#'
#' # blah b;lah
#' # blah blah
#'
#' create_waiting_list(366,50,21,"2024-01-01",10,0.1)
#'


create_waiting_list <- function(n, mean_arrival_rate, mean_wait, start_date = Sys.Date(), sd=0, rott=0,  ...){

  dots <- list(...)

  #Generate date range and number of referrals for each date (with or without
  #random variation around mean_arrival_rate)
  dates <- seq.Date(from = as.Date(start_date,format="%Y-%m-%d"),length.out = n, by = "day")
  counts <- pmax(0,rnorm(n, mean = mean_arrival_rate, sd = sd))
  referrals <- rep(dates, times = counts)

  #Set random waiting time in days for each referral received with exponential
  #distribution rate 1/mean_waiting_time
  values <- rexp(length(referrals),1/mean_wait)

  #Create dataframe of referrals and calculate removal date
  df <- data.frame(addition_date = referrals, wait_length = values)
  df$removal_date <- df$addition_date + round(df$wait_length,0)
  df$wait_length <- round(df$wait_length,0)

  #Randomly flag user defined proportion of referrals as ROTT
  df$rott <- FALSE
  sample_list <- sample(1:nrow(df),nrow(df)*rott, replace = FALSE)
  df$rott[sample_list] <- TRUE

  #Add a patient ID to each referral and prepare data for return
  df$pat_id <- 1:nrow(df)
  df <- df[order(df$addition_date),c("pat_id","addition_date","removal_date",
                                     "wait_length","rott")]

  return( dplyr::as_tibble(c(dots, df)) )
}