#' @title A simple operation scheduler
#'
#' @description Takes a list of dates and schedules them to a waiting list.
#' This is done in date order. I.e. earlier referrals are scheduled first.
#'
#' @param waiting_list dataframe consisting addition and removal dates
#' @param schedule a list of dates
#'
#' @return updated waiting list with feasible dates schedule
#' @export
#'
#' @examples
#' referrals <- c.Date("2024-01-01","2024-01-04","2024-01-10","2024-01-16")
#' removals <- c.Date("2024-01-08",NA,NA,NA)
#' waiting_list <- data.frame("referral" = referrals ,"removal" = removals )
#' schedule <- c.Date("2024-01-03","2024-01-05","2024-01-18")
#' updated_list <- queue_scheduler(waiting_list,schedule)

# TO DO ALLOW:
# schedule to be a dataframe or vector

wl_schedule <- function(waiting_list, schedule, referral_index = 1, removal_index = 2) {
  # split waiters and removed
  wl <- waiting_list[is.na(waiting_list[,removal_index]),]
  wl_removed <- waiting_list[!(is.na(waiting_list[,removal_index])),]
  rownames(wl) <- NULL

  # schedule
  i<-1
  for (op in as.list(schedule)) {
    if ( op > wl[i,referral_index] & i <= nrow(wl)) {
      wl[i,removal_index] = as.Date(op)
      i <- i+1
    }
  }

  # recombine to update list
  updated_list <- rbind(wl_removed,wl)
  updated_list <- updated_list[order(updated_list[,referral_index]),]
  return (updated_list)
}
