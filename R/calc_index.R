#' @title Calculate Column Indices
#'
#' @description Help function to get column indicies
#'
#' @param colname string giving the column name
#' @param type if colname null write referal, withdrawal, removal to guess the index
#'
#' @return index
#' @export
#'
#' @examples
#'
#'


calc_index <- function(waiting_list,
                       colname = NULL,
                        type = NULL){

  if( !is.null(colname) ){
    index <-  which(colnames(waiting_list)==colname)
    return(index)
  } else {

    if (is.null(type)) {
      index <- 1
      return(index)
    } else if ( type == "referral") {
      guesses <- c("referral","Referral",1)
    } else if ( type == "removal" ) {
      guesses <- c("removal","Removal",2)
    } else if ( type == "withdrawal") {
      guesses <- c("withdrawal","Withdrawal",3)
    } else if ( type == "target") {
      guesses <- c("target","Target_wait",NULL)
    }else {
      index <- 1
      return(index)
    }

    for ( guess in guesses ) {

      if ( is.character(guess) ){
        index <-  which(colnames(waiting_list)==guess)
      } else {
        index <- guess
      }
      if (!identical(index,integer(0)) ){
        break
      }
    }
    return(index)
  }
}