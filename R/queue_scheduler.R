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

queue_scheduler <- function(waiting_list, schedule) {
  # split waiters and removed
  wl <- waiting_list[is.na(waiting_list[,2]),]
  wl_removed <- waiting_list[!(is.na(waiting_list[,2])),]
  rownames(wl) <- NULL

  # schedule
  i<-1
  for (op in as.list(schedule)) {
    if ( op > wl[i,1] ) {
      wl[i,2] = as.Date(op)
      i <- i+1
    }
  }

  # recombine to update list
  updated_list <- rbind(wl_removed,wl)
  updated_list <- updated_list[order(updated_list[,2]),]
  return (updated_list)
}