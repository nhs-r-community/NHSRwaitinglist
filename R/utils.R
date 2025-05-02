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

  # remove NULL from user facing output
  # as intended for using default values only
  .expected_class = .expected_class[.expected_class != "NULL"]

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

#' Check format of input date arguments
#'
#' First calls [check_class()] to error if not `Date` or `character`.
#'
#' Then tries to coerce to `Date`, reporting if a provided string is not in
#' an unambiguous format.
#'
#' @param ... Date arguments to check
#' @param .call The environment in which this function is to be
#'     called.
#' @param .allow_null Logical whether to include `NULL` in allowed classes, for
#'   when it is used as a default value.
#'
#' @return Returns `NULL` invisibly if no errors
#'
#' @noRd
check_date <- function(...,
                      .call = rlang::caller_env(),
                      .allow_null = FALSE) {
  args <- rlang::dots_list(..., .named = TRUE)

  date_classes <- c("Date", "character")

  if (.allow_null) {
    date_classes <- c(date_classes , "NULL")
  }

  rlang::exec(check_class,
              !!!args,
              .expected_class = date_classes,
              .call = .call)

  # attempt to coerce to date
  # NAs returned incorrect/ambiguous
  coerced_dates <- lapply(args,
                          \(arg) as.Date(arg, format = "%Y-%m-%d"))

  are_not_dates <- lapply(coerced_dates, \(x) any(is.na(x)))
  are_not_dates <- unlist(are_not_dates)
  fails_names <- names(coerced_dates)[are_not_dates]

  if (length(fails_names) > 0) {
    cli::cli_abort(
      message =
        paste(
          "{.var {fails_names}} must be in an unambiguous Date format",
          "e.g., 'YYYY-MM-DD'"
        ),
      call = .call
    )
  }
}
