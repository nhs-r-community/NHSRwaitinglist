#' Check Class of Argument Inputs
#' @param ... Objects to be checked for class.
#' @param .expected_class Character. The name of the class against which objects
#'     should be checked.
#' @param .call The environment in which this function is to be
#'     called.
#' @noRd
check_class <- function(
    ...,
    .expected_class = "numeric",
    .call = rlang::caller_env()) {

  # expected types included NULL for argument defaults
  supported_classes <- c("numeric", "character", "logical", "data.frame",
                         "Date", "NULL")

  .expected_class <- match.arg(.expected_class, supported_classes)

  args <- rlang::dots_list(..., .named = TRUE)

  args_are_class <- lapply(args,
                           \(arg) methods::is(arg, .expected_class))

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
