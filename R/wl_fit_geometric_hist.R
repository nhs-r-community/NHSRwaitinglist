#' Fit a Geometric Distribution to a Waiting-list Histogram
#'
#' Fits a discrete geometric distribution to histogram counts by weeks waited.
#' If an `open_ended` column is present, rows marked `TRUE` are treated as
#' right-censored tail bins.
#'
#' @param wl_hist A data frame with `n` and either `weeks_waiting` or date
#'   columns from which weeks waited can be inferred.
#'
#' @return A list with fitted-bin data and a one-row summary table.
#' @export
wl_fit_geometric_hist <- function(wl_hist) {
  if (!is.data.frame(wl_hist)) {
    stop("`wl_hist` must be a data.frame")
  }
  if (!"n" %in% names(wl_hist)) {
    stop("`wl_hist` must contain an `n` column")
  }

  hist <- wl_hist
  if (!"weeks_waiting" %in% names(hist)) {
    arrived_before_col <- if ("arrival_before" %in% names(hist)) {
      "arrival_before"
    } else if ("arrived_before" %in% names(hist)) {
      "arrived_before"
    } else {
      NA_character_
    }
    if (is.na(arrived_before_col) || !"report_date" %in% names(hist)) {
      stop("`wl_hist` must contain `weeks_waiting`, or `report_date` and an arrival/arrived_before column")
    }
    hist$weeks_waiting <- round(as.numeric(
      as.Date(hist$report_date) - as.Date(hist[[arrived_before_col]])
    ) / 7)
  }

  if (!"open_ended" %in% names(hist)) {
    hist$open_ended <- FALSE
    if ("week_band" %in% names(hist)) {
      hist$open_ended <- grepl("plus", hist$week_band, ignore.case = TRUE)
    }
  }

  hist$n <- as.numeric(hist$n)
  hist$weeks_waiting <- as.numeric(hist$weeks_waiting)
  hist$open_ended <- as.logical(hist$open_ended)
  hist <- hist[!is.na(hist$n) & !is.na(hist$weeks_waiting), , drop = FALSE]

  if (nrow(hist) == 0 || sum(hist$n, na.rm = TRUE) <= 0) {
    stop("`wl_hist` has no positive count data to fit")
  }

  fit_bins <- stats::aggregate(
    n ~ weeks_waiting + open_ended,
    data = hist,
    FUN = sum,
    na.rm = TRUE
  )
  fit_bins <- fit_bins[order(fit_bins$weeks_waiting, fit_bins$open_ended), ]

  uncensored <- fit_bins[!fit_bins$open_ended, , drop = FALSE]
  censored <- fit_bins[fit_bins$open_ended, , drop = FALSE]
  successes <- sum(uncensored$n, na.rm = TRUE)
  exposure <- sum(uncensored$weeks_waiting * uncensored$n, na.rm = TRUE) +
    sum(censored$weeks_waiting * censored$n, na.rm = TRUE)

  if (successes <= 0 || exposure < 0) {
    stop("Cannot fit a geometric distribution with the supplied counts")
  }

  p <- successes / (successes + exposure)
  q <- 1 - p
  total <- sum(fit_bins$n, na.rm = TRUE)

  fit_bins$fitted_probability <- ifelse(
    fit_bins$open_ended,
    q ^ fit_bins$weeks_waiting,
    p * q ^ fit_bins$weeks_waiting
  )
  fit_bins$fitted_n <- total * fit_bins$fitted_probability

  summary <- data.frame(
    total_waiting = total,
    week_min = min(fit_bins$weeks_waiting, na.rm = TRUE),
    week_max = max(fit_bins$weeks_waiting, na.rm = TRUE),
    open_ended_week = if (any(fit_bins$open_ended)) {
      min(fit_bins$weeks_waiting[fit_bins$open_ended], na.rm = TRUE)
    } else {
      NA_real_
    },
    geometric_p = p,
    geometric_mean_weeks = q / p,
    equivalent_exponential_rate = -log(q),
    observed_open_ended = sum(fit_bins$n[fit_bins$open_ended], na.rm = TRUE),
    fitted_open_ended = sum(fit_bins$fitted_n[fit_bins$open_ended], na.rm = TRUE)
  )

  result <- list(
    fitted = fit_bins,
    summary = summary
  )
  class(result) <- c("wl_geometric_hist_fit", class(result))
  result
}
