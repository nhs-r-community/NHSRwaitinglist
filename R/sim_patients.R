#' @title Generator of NHS patients
#'
#' @description Generates simulated NHS patients
#'
#' @param n_rows Number of rows/patients to generate
#' @param start_date Start date (needed to generate patient ages)
#'
#'@return A data.frame representing an empty waiting list with the
#'  following columns:
#'
#' \describe{
#'   \item{Referral}{Date. Referral date; all values are \code{NA}.}
#'   \item{Removal}{Date. Removal date; all values are \code{NA}.}
#'   \item{Withdrawal}{Date. Patient withdrawal date; all values are
#'     \code{NA}}
#'   \item{Priority}{Numeric. Waiting list priority level, from 1
#'     (most urgent) to 4 (least urgent).}
#'   \item{Target_wait}{Numeric. Target number of days the patient should
#'     wait at the assigned priority level (e.g., 28 days for priority 2)}
#'   \item{Name}{Character. Patient name in the format
#'     \code{"Last, First"}.}
#'   \item{Birth_date}{Date. Date of birth.}
#'   \item{NHS_number}{Integer. Patient identifier, up to 100,000,000.}
#'   \item{Specialty_code}{Character. One-letter code representing the
#'     specialty of the procedure.}
#'   \item{Specialty}{Character. Full name of the specialty associated with
#'     the procedure.}
#'   \item{OPCS}{Character. OPCS-4 code of the selected procedure.}
#'   \item{Procedure}{Character. Name of the selected procedure.}
#'   \item{Consultant}{Character. Consultant name in the format
#'     \code{"Last, First"}.}
#'  }
#'
#' @export sim_patients
#' @import randomNames
#' @examples
#' sim_patients()
sim_patients <- function(
  n_rows = 10,
  start_date = NULL
) {

  if (n_rows == 0) {
    stop("NOTE: Please supply a positive integer for the argument n_rows.")
  }

  if (is.null(start_date)) {
    start_date <- Sys.Date()
  }
  if (!exists("opcs4")) {
    load(file = "./data/opcs4.rda")
  }
  opcs4 <- opcs4
  # get procedures
  ops <- opcs4[(opcs4$selectable == "Y") & (!is.na(opcs4$name_4digit)), ]
  ran <- ops[sample(nrow(ops), n_rows, replace = TRUE), ]
  procedures <-
    ran[c("code_1digit", "name_1digit", "code_4digit", "name_4digit")]

  # get names consultants and NHS numbers (length actually too short)
  names <- randomNames::randomNames(n_rows)
  consultant <- randomNames::randomNames(n_rows)
  nhs_number <- sample.int(1e+8, n_rows, replace = TRUE)

  # get semi-realistic ages (from gov.uk)
  ages_rounded <-
    c(0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85)
  probs <-
    c(
      5.4, 5.9, 6.0, 3.4, 8.3, 6.5, 7.0, 6.7, 6.3, 6.4, 6.9, 6.8, 5.8, 4.9
      , 5.0, 3.6, 2.5, 2.4
    )

  years <-
    365 * (sample(ages_rounded, size = n_rows, replace = TRUE, prob = probs) +
           sample.int(4, n_rows, replace = TRUE) - 1)
  days <- sample.int(365, n_rows, replace = TRUE) - 1
  dobs <- as.Date(as.numeric(start_date) - years - days)
  priority <-
    sample(c(1, 2, 3, 4), size = n_rows, replace = TRUE
           , prob = c(0.05, 0.2, 0.25, 0.5))

  target_wait <- sapply(priority, calc_priority_to_target)

  # referral, removal, withdrawal columns
  empty_date_vector <- as.Date(rep(NA, n_rows))

  waiting_list <- data.frame(
    Referral = empty_date_vector,
    Removal = empty_date_vector,
    Withdrawal = empty_date_vector,
    Priority = priority,
    Target_wait = target_wait,
    Name = names,
    Birth_date = dobs,
    NHS_number = nhs_number,
    Specialty_code = procedures$code_1digit,
    Specialty = procedures$name_1digit,
    OPCS = procedures$code_4digit,
    Procedure = procedures$name_4digit,
    Consultant = consultant
  )

  return(waiting_list)
}
