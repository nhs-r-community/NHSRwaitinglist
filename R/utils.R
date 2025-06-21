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

  .expected_class <- match.arg(.expected_class,
                               supported_classes,
                               several.ok = TRUE)

  # inherits() is very useful for checking multiple classes at once
  # however since integers does not "inherit" the `numeric` class
  # manually adding it to the list to match is.numeric() behaviour
  if ("numeric" %in% .expected_class) {
    .expected_class <- c(.expected_class, "integer")
  }

  args_are_class <- lapply(args,
                           \(arg) inherits(arg, .expected_class))

  # clean up the integer workaround
  if ("numeric" %in% .expected_class) {
    .expected_class <- .expected_class[.expected_class != "integer"]
  }

  # remove NULL from user facing output
  # as intended for using default values only
  if (length(.expected_class) > 1) {
    .expected_class <- .expected_class[.expected_class != "NULL"]
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
    date_classes <- c(date_classes, "NULL")
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

#' Check format of input waiting list and indexed columns
#'
#' - Checks the `waiting_list` is a data.frame.
#' - Checks the `waiting_list` is not empty (doesn't have 0 rows).
#' - Checks the indices passed to `...` are numerical, character or logical.
#' - Checks the indices passed to `...` are not `NA`.
#' - Checks the columns specified by the indices do exist in `waiting_list`
#'
#' Uses check_class and check_date for the class and date checks.
#'
#' @param waiting_list Object expected to be a data.frame waiting list
#'
#' @param ... Indices for date columns in `waiting_list`, can be positional
#'   like `1`, named like `"referrals"`, or logical like `c(TRUE, FALSE)`
#'
#' @param .empty_wl String strategy for handling 0 row data frames. One of:
#'   "error" - Throw an error (default);
#'   "warn" - Throw a warning;
#'   "allow" - Do nothing.
#'
#' @param wl_name The waiting list arg name from the calling environment.
#'   Recommended to leave as default.
#'
#' @param .call The environment in which this function is to be
#'   called. Recommended to leave as default.
#'
#' @return Returns `NULL` invisibly if no errors
#'
#' @noRd
check_wl <- function(
  waiting_list,
  ...,
  .empty_wl = c("error", "warn", "allow"),
  .allow_null = NULL,
  .wl_name = rlang::caller_arg(waiting_list),
  .call = rlang::caller_env()
) {
  .empty_wl <- rlang::arg_match(.empty_wl)

  # Checks the `waiting_list` is a data.frame ----

  # check_class expects args passed to `...`
  # so for the single waiting list argument:
  #   wrap in a named list,
  #   then splice `!!!` the list when passing as an arg to "dot-dot-dotify" it
  wl_list <- stats::setNames(list(waiting_list), .wl_name)
  check_class(!!!wl_list, .expected_class = "data.frame")

  # Checks the `waiting_list` is not empty (doesn't have 0 rows) ----

  if (.empty_wl != "allow") {
    wl_is_empty <- NROW(waiting_list) == 0

    empty_wl_handler <- switch(
      .empty_wl,
      "error" = cli::cli_abort,
      "warn" = cli::cli_warn
    )

    if (wl_is_empty) {
      msg <- paste0("{.arg ", .wl_name, "} has 0 rows of data")

      empty_wl_handler(message = c("!" = msg), call = .call)
    }
  }

  indices <- rlang::dots_list(..., .named = TRUE)

  # exit if no indices to check
  if (length(indices) == 0) {
    return(invisible())
  }

  # Checks the indices passed to `...` are numerical, character or logical ----

  check_class(
    ..., # we can just pass the dots directly here
    .expected_class = c("numeric", "character", "logical"),
    .call = .call
  )

  # Checks the indices passed to `...` are not `NA` ----

  is_na_index <- vapply(
    indices,
    function(index) length(index) == 1 && is.na(index),
    logical(1)
  )

  na_indices <- indices[is_na_index]

  if (sum(is_na_index) > 0) {
    fails_bullets <- stats::setNames(
      paste0(
        "{.var ", names(na_indices), "} with value {.val ",
        na_indices, "}"
      ),
      rep("*", length(na_indices))
    )

    cli::cli_abort(
      message = c(
        "x" = "Column indices must not be {.val NA}",
        "You provided:",
        fails_bullets
      ),
      .call = .call
    )
  }

  # Checks the columns specified by the indices do exist in `waiting_list` ----

  for (i in seq_along(indices)) {
    check_column_exists(
      indices[[i]],
      waiting_list,
      index_name = names(indices)[[i]],
      df_name = .wl_name,
      .call = .call
    )
  }
}

#' Assess validity of column index based on its data type
#'
#' Helper function to check_wl.
#'
#' A numerical index must be of length 1,
#'   and have a value between 1 and NCOL(df).
#'
#' A character index must be of length 1,
#'   and must be %in% names(df).
#'
#' A logical index must be of length NCOL(df),
#'  and have a sum of 1 (one TRUE for one column).
#'
#' The error message has structure
#' Column `{index_name}` not find in `{df_name}`
#' You provided:
#' * Index `{index_name}` with value "{index}"
#'
#' Could be improved with more specific messages, for example specifying that
#' the length is wrong.
#'
#' @param index index to check for validity
#'
#' @param df data.frame to check for column validity against
#'
#' @param index_name arg name for `index` from parent function
#'
#' @param df_name arg name for `df` from parent function
#'
#' @return Returns `NULL` invisibly if no errors found
#'
#' @noRd
check_column_exists <- function(
  index,
  df,
  index_name = rlang::caller_arg(index),
  df_name = rlang::caller_arg(df),
  .call = rlang::caller_env()
) {
  stopifnot(is.data.frame(df))
  stopifnot(is.numeric(index) || is.character(index) || is.logical(index))

  index_is_valid <- FALSE
  ncols <- NCOL(df)

  if (is.numeric(index)) {
    if (length(index) == 1) {
      # is in valid range
      index_is_valid <- index >= 1 && index <= ncols
    }
  } else if (is.character(index)) {
    if (length(index) == 1) {
      index_is_valid <- index %in% colnames(df)
    }
  } else if (is.logical(index)) {
    if (length(index) == ncols) {
      # is correct size
      index_is_valid <- sum(index) == 1
    }
  }

  if (!index_is_valid) {
    err_msg <- paste0(
      "Column specified by {.var ",
      index_name,
      "} not found in {.var ",
      df_name,
      "}"
    )

    # collapse in case longer than length 1
    val <- paste0(index, collapse = ", ")

    provided_msg <- paste0(
      "Index {.var ", index_name, "} with value {.val ", val, "}"
    )

    cli::cli_abort(
      message = c(
        "x" = err_msg,
        "You provided:",
        "*" = provided_msg
      ),
      call = .call
    )
  }
}
