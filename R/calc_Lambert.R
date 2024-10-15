
#' Lambert
#'
#' @param x
#'
#' @return numeric
#' @export
#'
calc_Lambert <- function(x){
  # use lower-bound x=W(xe^x) > W(x+x^2) for x > 0 and solve y = x + x^2
  # and x=W(xe^x) > W(ex^2) for x> 0 and solve y = e x^2

  e <- exp(1)
  A <- sqrt(x/e)
  B <- (sqrt(4*x +1) - 1 )/2

  L <- min(A,B)
  if (x>e){
    D <- log(x) - log(log(x) - log(log(x)))
    D <- log((2*x+1)/(1+log(x+1)))
    L = min(L,D)
  }

  return(L)
}
