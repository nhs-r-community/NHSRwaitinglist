#' @title Calculate Column Indices
#'
#' @description Internal Helper function to get column indices for referrals,
#'  removals, and withdrawals
#'
#' @param waiting_list a data.frame containing the waiting list
#' @param colname string giving the column name
#' @param type if colname, write referral, withdrawal,
#' removal to guess the index
#'
#' @return index
#' @noRd

calc_index <- function(waiting_list,
                       colname = NULL,
                       type = NULL) {
  # get column index if name given
  if (!is.null(colname)) {
    index <- which(colnames(waiting_list) == colname)
    return(index)
  } else {
    # if name not give guess the name or index based on type
    if (is.null(type)) {
      index <- 1
      return(index)
    } else if (type == "referral") {
      guesses <- c("referral", "Referral", 1)
    } else if (type == "removal") {
      guesses <- c("removal", "Removal", 2)
    } else if (type == "withdrawal") {
      guesses <- c("withdrawal", "Withdrawal", 3)
    } else if (type == "target") {
      guesses <- c("target", "Target_wait", NULL)
    } else {
      warning("Waiting list index not found")
      index <- 1
      return(index)
    }

    # implement guess and return index given
    for (guess in guesses) {
      if (is.character(guess)) {
        index <- which(colnames(waiting_list) == guess)
      } else {
        index <- guess
      }
      if (!identical(index, integer(0))) {
        break
      }
    }
    return(index)
  }
}
