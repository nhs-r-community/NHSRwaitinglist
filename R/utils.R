#' Check Class of Argument Inputs
#' @param ... Objects to be checked for class.
#' @param .expected_class Character. The name of the class against which objects
#'     should be checked.
#' @param .call The environment in which this function is to be
#'     called.
#' @noRd
check_class <- function(
  ...,
  .expected_class = c("numeric", "character"),
  .call = rlang::caller_env()
) {
  .expected_class <- match.arg(.expected_class)

  args <- rlang::dots_list(..., .named = TRUE)

  args_are_class <- lapply(
    args,
    function(arg) {
      switch(.expected_class,
        numeric   = is.numeric(arg),
        character = is.character(arg),
      )
    }
  )

  fails_names <- names(Filter(isFALSE, args_are_class))

  if (length(fails_names) > 0) {
    fails <- args[names(args) %in% fails_names]
    fails_classes <- sapply(fails, class)

    fails_bullets <- stats::setNames(
      paste0(
        "{.var ", names(fails_classes), "} with class {.cls ",
        fails_classes, "}"
      ),
      rep("*", length(fails_classes))
    )

    cli::cli_abort(
      message = c(
        "{.var {fails_names}} must be of class {.cls {(.expected_class)}}",
        x = "You provided:",
        fails_bullets
      ),
      call = .call
    )
  }
}
