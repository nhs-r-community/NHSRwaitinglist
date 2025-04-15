#' @title A simple operation scheduler
#'
#' @description Takes a list of dates and schedules them to a waiting list,
#' by adding a removal date to the data.frame.
#' This is done in referral date order,
#' I.e. earlier referrals are scheduled first (FIFO).
#'
#' @param waiting_list data.frame. A df of referral dates and removals
#' @param schedule vector of dates. Should be formatted as year-month-date, e.g.
#' "2024-04-01".  The dates to schedule open referrals into
#'   (i.e. dates of unbooked future capacity)
#' @param referral_index integer. The column number in the waiting_list which
#'   contains the referral dates
#' @param removal_index integer. The column number in the waiting_list which
#'   contains the removal dates
#' @param unscheduled logical.
#'  If TRUE, returns a list of scheduled and unscheduled procedures
#'  If FALSE, only returns the updated waiting list
#'
#' @return The updated waiting list with removal dates assigned based on
#'   the given schedule, either as a single \code{data.frame} (default) or as
#'   part of a list (if \code{unscheduled = TRUE}).
#'
#' If \code{unscheduled = TRUE}, returns a \code{list} with two data frames:
#' 1. A \code{data.frame}. The updated waiting list with scheduled removals.
#'
#' 2. A \code{data.frame} showing which slots were used, with columns:
#'
#'    \describe{
#'      \item{schedule}{Date. The available dates from the input
#'        \code{schedule}.}
#'      \item{scheduled}{Numeric. \code{1} if the slot was used to schedule a
#'        patient, \code{0} if not.}
#'    }
#'
#' @export
#'
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' schedule <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")
#' updated_waiting_list <- wl_schedule(waiting_list, schedule)
#'
wl_schedule <- function(
  waiting_list,
  schedule,
  referral_index = 1,
  removal_index = 2,
  unscheduled = FALSE
) {


  # Error handle
  if (!methods::is(waiting_list, "data.frame")) {
    stop("waiting list should be supplied as a data.frame")
  }

  if (nrow(waiting_list) == 0) {
    stop("No data rows in waiting list")
  }

  if (missing(waiting_list)) {
    stop("No waiting list supplied")
  }

  if (!methods::is(schedule, "Date")) {
    stop("Schedule vector is not formatted as dates")
  }


  # split waiters and removed
  wl <- waiting_list[is.na(waiting_list[, removal_index]), ]
  wl_removed <- waiting_list[!(is.na(waiting_list[, removal_index])), ]
  rownames(wl) <- NULL

  # schedule
  if (!unscheduled) {
    i <- 1
    for (op in as.list(schedule)) {
      if (op > wl[i, referral_index] && i <= nrow(wl)) {
        wl[i, removal_index] <- op
        i <- i + 1
      }
    }

    # Ensure date format
    #wl$Removal <- as.Date(wl$Removal)
    wl[, removal_index] <- as.Date(wl[, removal_index])

    # recombine to update list
    updated_list <- rbind(wl_removed, wl)
    updated_list <- updated_list[order(updated_list[, referral_index]), ]
    return(updated_list)
  } else {
    scheduled <- data.frame(
      schedule = schedule,
      scheduled = rep(0, length(schedule))
    )
    i <- 1
    j <- 0
    for (op in as.list(schedule)) {
      j <- j + 1
      if (op > wl[i, referral_index] && i <= nrow(wl)) {
        wl[i, removal_index] <- op
        i <- i + 1
        scheduled[j, 2] <- 1
      }
    }



    # Ensure date format
    #wl$Removal <- as.Date(wl$Removal)
    wl[, removal_index] <- as.Date(wl[, removal_index])

    # recombine to update list
    updated_list <- rbind(wl_removed, wl)
    updated_list <- updated_list[order(updated_list[, referral_index]), ]

    # scheduled[scheduled$scheduled = 1, 1]

    return(list(updated_list, scheduled))
  }
}
