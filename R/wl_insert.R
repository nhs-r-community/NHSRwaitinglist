#' @title Queue SIZE
#'
#' @description

#'
#' @param waiting_list
#' @param start_date
#' @param end_date
#'
#' @return
#' @export
#'
#' @examples
#'
#'


# TO DO: What if more columns
# Check column types

wl_insert <- function(waiting_list, additions, referral_index = 1) {

  new_rows = data.frame("referral" = additions,
                        "removal" =  rep(as.Date(NA), length(additions))
                        )

  # recombine to update list
  updated_list <- rbind(waiting_list,new_rows)
  updated_list <- updated_list[order(updated_list[,referral_index]),]
  return (updated_list)
}