
library(randomNames)
load(file="./data/OPCS4.Rda")


sim_patients <- function(
    n_rows = 10,
    start_date = NULL
) {

  if ( is.null(start_date) ){
    start_date = Sys.Date()
  }

  # get proceedures
  OPS <- OPCS4[(OPCS4$selectable=="Y") & (!is.na(OPCS4$name_4digit)),]
  ran <- OPS[sample(nrow(OPS),n_rows,replace=TRUE),]
  proceedures <- ran[c("code_4digit","name_4digit")]

  # get names consultants and NHS numbers (length actually too short)
  names <- randomNames(n_rows)
  consultant <- randomNames(n_rows)
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

  # referral, removal, withdrawal columns
  referral <- c(rep(NA,n_rows))
  removal <- as.Date(c(rep(NA,n_rows)))
  withdrawal <- c(rep(NA,n_rows))

  waiting_list <- data.frame(
    Referral = referral,
    Removal = removal,
    Withdrawal = withdrawal,
    Name = names,
    Birth_Date = dobs,
    NHS_number = NHS_number,
    OPCS = proceedures$code_4digit,
    Proceedure = proceedures$name_4digit,
    Consultant = consultant
  )

  return(waiting_list)

  # realized_demand = 10
  # referral <-sample(seq(as.Date(start_date),
  #                       as.Date(end_date),
  #                       by = "day"),
  #                   realized_demand,
  #                   replace = TRUE)
  #
  # referral <- referral[order(referral)]
  #
  # waiting_list$Referral <- referral
  #
  # withdrawal <- referral +
  #               rgeom(length(referral), prob = withdrawal_prob) + 1
  # withdrawal[withdrawal > end_date] <- NA
  # waiting_list$Withdrawal <- withdrawal
  #
  # schedule <-
  #   as.Date(as.numeric(start_date) +
  #             ceiling(seq(0, number_of_days - 1, 10)), origin = "1970-01-01")

}