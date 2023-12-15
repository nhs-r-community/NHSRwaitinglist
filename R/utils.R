#' Check Class of Argument Inputs
#' @param ... Objects to be checked for class.
#' @param .expected_class Character. The name of the class against which objects
#'     will be checked.
#' @noRd
check_class <- function(..., .expected_class = "numeric", .call = rlang::caller_env()) {

  args <- rlang::dots_list(..., .named = TRUE)

  args_class_lgl <- lapply(
    args,
    function(arg) inherits(arg, .expected_class)
  )

  failing_arg_names <- names(Filter(isFALSE, args_class_lgl))

  if (length(failing_arg_names) > 0) {

    failing_args <- args[names(args) %in% failing_arg_names]
    failing_args_classes <- sapply(failing_args, class)

    cli::cli_abort(
      message = c(
        "{.var {failing_arg_names}} must be of class {.cls {(.expected_class)}}",
        x = "You provided input of class {.cls {failing_args_classes}}."
      ),
      call = .call
    )
  }

}

#' Check that Lengths of Argument Inputs Match
#' @param ... Objects to be compared for length.
#' @noRd
check_lengths_match <- function(..., .call = rlang::caller_env()) {

  args <- rlang::dots_list(..., .named = TRUE)

  arg_lengths <- lengths(args)

  lengths_are_equal <- length(unique(arg_lengths)) == 1

  if (!lengths_are_equal) {
    cli::cli_abort(
      message = c(
        "{.arg {names(args)}} must be the same length.",
        x = "You provided inputs with lengths of {paste(arg_lengths)}."
      ),
      call = .call
    )
  }

}
