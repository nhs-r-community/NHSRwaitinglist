#' @title Simple simulator to create a waiting list
#'
#' @description Creates a simulated waiting list comprising referral dates,
#' and removal dates
#'
#' @param start_date Date or character (in format 'YYYY-MM-DD'); The start date
#'   to calculate from
#' @param end_date Date or character (in format 'YYYY-MM-DD'); The end date to
#'   calculate to
#' @param demand numeric. Weekly demand (i.e., typical referrals per week).
#' @param capacity numeric. Weekly capacity (i.e., typical removals per week).
#' @param waiting_list data.frame. Waiting list where each row is a
#' pathway/patient with date columns 'Referral' and 'Removal'.
#' @param withdrawal_prob numeric. Probability of a patient withdrawing.
#' @param detailed_sim logical. If TRUE, simulation provides detailed output.
#'
#' @return A \code{data.frame} simulating a waiting list, with columns:\cr
#'
#'  \item{Referral}{Date. The date each patient was added to the waiting list.}
#'  \item{Removal}{Date. The date each patient was removed from the waiting
#'     list (may be \code{NA} if unscheduled).}\cr
#'
#'
#'   \strong{If \code{detailed_sim = TRUE}}, returns a more detailed
#'   \code{data.frame} with the following additional
#'   fields:\cr
#'
#'   \item{Withdrawal}{Date. The date the patient withdrew from the
#'     waiting list.}
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
#'
#' @import dplyr
#' @importFrom stats rgeom
#' @export
#'
#' @examples
#'
#' over_capacity_simulation <-
#'   wl_simulator("2024-01-01", "2024-03-31", 100, 110)
#' under_capacity_simulation <-
#'   wl_simulator("2024-01-01", "2024-03-31", 100, 90)
#'
wl_simulator <- function(
  start_date = NULL,
  end_date = NULL,
  demand = 10,
  capacity = 11,
  waiting_list = NULL,
  withdrawal_prob = NA_real_,
  detailed_sim = FALSE
) {
  check_date(start_date, end_date, .allow_null = TRUE)
  check_class(demand, capacity, withdrawal_prob, .expected_class = "numeric")
  check_class(detailed_sim, .expected_class = "logical")
  if (!is.null(waiting_list)) check_wl(waiting_list)

  # Fix Start and End Dates
  if (is.null(start_date)) {
    start_date <- Sys.Date()
  }
  if (is.null(end_date)) {
    end_date <- start_date + 31
  }

  start_date <- as.Date(start_date)
  end_date <- as.Date(end_date)
  number_of_days <- as.numeric(end_date) - as.numeric(start_date)

  total_demand <- demand * number_of_days / 7
  daily_capacity <- capacity / 7

  # allowing for fluctuations in predicted demand give a arrival list
  realized_demand <- stats::rpois(1, total_demand)
  referral <-
    sample(
      seq(as.Date(start_date), as.Date(end_date), by = "day"),
      realized_demand,
      replace = TRUE
    )

  referral <- referral[order(referral)]
  removal <- rep(as.Date(NA), length(referral))

  if (!detailed_sim) {
    if (is.na(withdrawal_prob)) {
      wl_simulated <- data.frame(
        "Referral" = referral,
        "Removal" = removal
      )
    } else {
      withdrawal <-
        referral + rgeom(length(referral), prob = withdrawal_prob) + 1
      withdrawal[withdrawal > end_date] <- NA
      wl_simulated <- data.frame(
        "Referral" = referral,
        "Removal" = removal,
        "Withdrawal" = withdrawal
      )
    }

    if (!is.null(waiting_list)) {
      wl_simulated <- wl_join(waiting_list, wl_simulated)
    }
  }
  if (detailed_sim) {
    if (is.na(withdrawal_prob)) {
      withdrawal_prob <- 0.1
    }
    withdrawal <- referral + rgeom(length(referral), prob = withdrawal_prob) + 1
    withdrawal[withdrawal > end_date] <- NA
    wl_simulated <- sim_patients(length(referral), start_date)
    wl_simulated$Referral <- referral
    wl_simulated$Withdrawal <- withdrawal
  }

  # create an operating schedule
  if (daily_capacity > 0) {
    schedule <- sim_schedule(number_of_days, start_date, daily_capacity)

    wl_simulated <- wl_schedule(wl_simulated, schedule)
  }

  return(wl_simulated)
}
