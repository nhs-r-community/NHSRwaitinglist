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

  args <- rlang::dots_list(..., .named = TRUE)

  # expected types included NULL for argument defaults
  supported_classes <- c("numeric", "character", "logical", "data.frame",
                         "Date", "NULL", "integer")

  .expected_class <- match.arg(.expected_class, supported_classes, several.ok = TRUE)

  # inherits() is very useful for checking multiple classes at once
  # however since integers does not "inherit" the `numeric` class
  # manually adding it to the list to match is.numeric() behaviour
  if ("numeric" %in% .expected_class) {
    .expected_class = c(.expected_class, "integer")
  }

  args_are_class <- lapply(args,
                           \(arg) inherits(arg, .expected_class))

  # clean up the integer workaround
  if ("numeric" %in% .expected_class) {
    .expected_class = .expected_class[.expected_class != "integer"]
  }

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
