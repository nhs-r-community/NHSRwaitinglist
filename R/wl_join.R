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

wl_join <- function(wl_1, wl_2, referral_index = 1) {
  # combine and sort to update list
  updated_list <- rbind(wl_1,wl_2)
  updated_list <- updated_list[order(updated_list[,referral_index]),]
  return (updated_list)
}