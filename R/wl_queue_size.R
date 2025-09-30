#' @title Queue size calculator
#'
#' @description Calculates queue sizes from a waiting list

#'
#' @param waiting_list data.frame consisting addition and removal dates
#' @param start_date Date or character (in format 'YYYY-MM-DD'); start of
#'   calculation period
#' @param end_date Date or character (in format 'YYYY-MM-DD'); end of
#'   calculation period
#' @param referral_index the index of referrals in waiting_list
#' @param removal_index the index of removals in waiting_list
#'
#' @return A data.frame containing the size of the waiting list for each day in
#'   the specified date range. If \code{start_date} and/or \code{end_date} are
#'   \code{NULL}, the function uses the earliest and latest referral dates in
#'   the input data.frame. The returned data.frame has the following columns:
#'
#' \describe{
#'   \item{dates}{Date. Each date within the computed range, starting from the
#'     first referral.}
#'   \item{queue_size}{Numeric. Number of patients on the waiting list
#'     on that date.}
#' }
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' wl_queue_size(waiting_list)
wl_queue_size <- function(waiting_list,
                          start_date = NULL,
                          end_date = NULL,
                          referral_index = 1,
                          removal_index = 2) {
  check_wl(waiting_list, referral_index, removal_index)
  check_date(start_date, end_date, .allow_null = TRUE)

  wl <- waiting_list

  if (is.null(start_date)) {
    start_date <- min(wl[, referral_index])
  }
  if (is.null(end_date)) {
    end_date <- max(wl[, referral_index])
  }

  wl[wl[, referral_index] < start_date, referral_index] <- start_date
  arrival_counts <- data.frame(table(wl[, referral_index]))
  arrival_counts[, 1] <- as.Date(arrival_counts[, 1])

  dates <- seq(as.Date(start_date), as.Date(end_date), by = "day")
  queues <- data.frame(dates, rep(0, length(dates)))

  queues[which(queues[, 1] %in% arrival_counts[, 1]), 2] <- arrival_counts[, 2]
  queues$cummul_arrivals <- cumsum(queues[, 2])

  departures <-
    wl[which((start_date <= wl[, removal_index]) &
               (wl[, removal_index] <= end_date)), removal_index]
  if (length(departures > 0)) {
    departure_counts <-
      data.frame(
        table(wl[which((start_date <= wl[, removal_index]) &
                         (wl[, removal_index] <= end_date)), removal_index])
      )

    departure_counts[, 1] <- as.Date(departure_counts[, 1])

    queues$departures <- rep(0, length(dates))
    queues[which(queues[, 1] %in% departure_counts[, 1]), 4] <-
      departure_counts[, 2]
    queues$cummul_departures <- cumsum(queues[, 4])

    queues$queue_size <- queues$cummul_arrivals - queues$cummul_departures
  } else {
    queues$departures <- rep(0, length(dates))
    queues$cummul_departures <- rep(0, length(dates))
    queues$queue_size <- queues$cummul_arrivals
  }

  return(queues[, c(1, 6)])
}
