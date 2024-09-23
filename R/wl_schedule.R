#' @title A simple operation scheduler
#'
#' @description Takes a list of dates and schedules them to a waiting list,
#' by adding a removal date to the dataframe.
#' This is done in referral date order,
#' I.e. earlier referrals are scheduled first (FIFO).
#'
#' @param waiting_list dataframe. A df of referral dates and removals
#' @param schedule vector of dates. The dates to schedule open referrals into
#'   (ie. dates of unbooked future capacity)
#' @param referral_index integer. The column number in the waiting_list which
#'   contains the referral dates
#' @param removal_index integer. The column number in the waiting_list which
#'   contains the removal dates
#'
#' @return dataframe. A df of the updated waiting list with removal dates added
#'   according to the schedule
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals)
#' schedule <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")
#' updated_waiting_list <- wl_schedule(waiting_list, schedule)
#'
#' # Or if there are withdrawals from the list too:
#' referrals <- c.Date("2024-01-01", "2024-01-04", "2024-01-10", "2024-01-16")
#' removals <- c.Date("2024-01-08", NA, NA, NA)
#' withdrawal <- c.Date(NA,NA,"2024-01-14",NA)
#' waiting_list <- data.frame("referral" = referrals, "removal" = removals, "withdrawal" = withdrawal)
#' schedule <- c.Date("2024-01-03", "2024-01-05", "2024-01-18")
#' updated_waiting_list <- wl_schedule(waiting_list, schedule)
#'
#' # TODO ALLOW:
#' # schedule to be a dataframe or vector
wl_schedule <- function(
    waiting_list,
    schedule,
    referral_index = NA,
    removal_index = NA,
    withdrawal_index = NA) {

  # guess withdraw, referral and removal index if not given
  if( is.na(withdrawal_index)
     && "Withdrawal" %in% colnames(waiting_list) ){
    withdrawals = TRUE
    withdrawal_index <- which(colnames(waiting_list) == "Withdrawal")
  } else {
    withdrawals = FALSE
  }

  if( is.na(referral_index)
      && "Referral" %in% colnames(waiting_list) ){
    referral_index <- which(colnames(waiting_list) == "Referral")
  }

  if( is.na(removal_index)
      && "Removal" %in% colnames(waiting_list) ){
    removal_index <- which(colnames(waiting_list) == "Removal")
  }

  # split waiters and removed
  wl <- waiting_list[is.na(waiting_list[, removal_index]), ]
  wl_removed <- waiting_list[!(is.na(waiting_list[, removal_index])), ]
  rownames(wl) <- NULL

  # schedule
  if (!withdrawals){
    i <- 1
    for (op in as.list(schedule)) {
      if (op > wl[i, referral_index] && i <= nrow(wl)) {
        wl[i, removal_index] <- as.Date(op)
        i <- i + 1
      }
    }
  }

  # schedule checking for withdrawals
  if(withdrawals){
    for ( i in 1:length(schedule) ){
      for ( j in 1:nrow(wl) ){
        if ( schedule[i] > wl[j, referral_index]
             && is.na(wl[j,removal_index]) ){
          if ( !is.na(wl[j,withdrawal_index])){
            if ( schedule[i] < wl[j, withdrawal_index]) {
                wl[j,removal_index] <- as.Date(schedule[i])
              break
            }
          } else {
            wl[j,removal_index] <- as.Date(schedule[i])
            break
          }
        }
      }
    }

    # update removals that were because withdrawn
    for ( j in 1:nrow(wl) ){
      if(!is.na(wl[j,removal_index])) {
        wl[j,withdrawal_index] <- NA
      }
    }
  }


  # recombine to update list
  updated_list <- rbind(wl_removed, wl)
  updated_list <- updated_list[order(updated_list[, referral_index]), ]
  return(updated_list)
}
