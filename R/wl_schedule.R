#' @title schedules removal dates on a waiting list
#'
#' @description
#'
#' @param waiting_list dataframe
#' @param schedule Numeric value
#'
#' @return updated_list
#' @export
#'
#' @examples
#'
#'

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
    if ( op > wl[i,referral_index] ) {
      wl[i,removal_index] = as.Date(op)
      i <- i+1
    }
  }

  # recombine to update list
  updated_list <- rbind(wl_removed,wl)
  updated_list <- updated_list[order(updated_list[,referral_index]),]
  return (updated_list)
}
