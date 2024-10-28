#' @title Generator of NHS patients
#'
#' @description Generates simulated NHS patients
#'
#' @param n_rows Number of rows/patients to generate
#' @param start_date Start date (needed to generate patient ages)
#'
#' @return dataframe. Empty waiting list.
#' @export
#' @import randomNames
#' @examples
#' sim_patients(100,"2024-09-21")
sim_patients <- function(
    n_rows = 10,
    start_date = NULL
) {

  if ( is.null(start_date) ){
    start_date = Sys.Date()
  }
  if (!exists("OPCS4")){
    load(file='./data/OPCS4.rda')
  }

  # get proceedures
  OPS <- OPCS4[(OPCS4$selectable=="Y") & (!is.na(OPCS4$name_4digit)),]
  ran <- OPS[sample(nrow(OPS),n_rows,replace=TRUE),]
  proceedures <- ran[c("code_1digit","name_1digit","code_4digit","name_4digit")]

  # get names consultants and NHS numbers (length actually too short)
  names <- randomNames::randomNames(n_rows)
  consultant <- randomNames::randomNames(n_rows)
  NHS_number <- sample.int(1e+8,n_rows, replace=TRUE)

  # get semi-realistic ages (from gov.uk)
  ages_rounded <-c(0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85)
  probs <- c(
    5.4,5.9,6.0,3.4,8.3,6.5,7.0,6.7,6.3,6.4,6.9,6.8,5.8,4.9,5.0,3.6,2.5,2.4
  )
  years <- 365*(sample(ages_rounded,size=n_rows,replace=TRUE,prob=probs) +
                  sample.int(4,n_rows, replace = TRUE) -1)
  days <- sample.int(365,n_rows, replace = TRUE) -1
  dobs <- as.Date(as.numeric(start_date)-years-days)
  target_wait <- sample(c(7,28,84,365),size=n_rows,replace=TRUE,prob=c(0.05,0.2,0.25,0.5))

  # referral, removal, withdrawal columns
  referral <- c(rep(NA,n_rows))
  removal <- as.Date(c(rep(NA,n_rows)))
  withdrawal <- c(rep(NA,n_rows))

  waiting_list <- data.frame(
    Referral = referral,
    Removal = removal,
    Withdrawal = withdrawal,
    Target_wait = target_wait,
    Name = names,
    Birth_Date = dobs,
    NHS_number = NHS_number,
    Specialty_code = proceedures$code_1digit,
    Specialty = proceedures$name_1digit,
    OPCS = proceedures$code_4digit,
    Proceedure = proceedures$name_4digit,
    Consultant = consultant
  )

  return(waiting_list)


}