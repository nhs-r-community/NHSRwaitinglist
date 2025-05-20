validate_histogram <- function(histogram){

  check_class(histogram, .expected_class = "data.frame")

  assertthat::assert_that(
    all(c("arrival_before", "arrival_since", "n")) %in% names(histogram),
    msg = "Histogram is missing a required column"
  )

  return(histogram)

}