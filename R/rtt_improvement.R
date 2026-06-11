#' Create a ggplot of an RTT improvement journey
#'
#' @param referral_rate numeric. A weekly referral rate to plot
#' @param rtt_performance numeric vector. A vector of performance thresholds,
#' as proportion e.g. 0.65 = 65%.
#' Default values are: c(0.5, 0.60, 0.70, 0.80, 0.92)
#' @param n_bins numeric.  Number of bins for histogram.
#' Default is 1 - 64 weeks.
#' @returns ggplot object
#'
#' @importFrom stats pexp dexp
#' @export
#'
plot_rtt_journey <- function(referral_rate,
                             rtt_performance = c(0.5, 0.60, 0.70, 0.80, 0.92),
                             n_bins = 64) {
  stopifnot(all(rtt_performance > 0 & rtt_performance < 1))
  stopifnot(referral_rate > 0)

  # the NHS referral to treatment standard is 92% treated by 18 weeks
  target_weeks <- 18 # weeks

  # get the exponential lambda values for each rtt performance level
  lambda_values <- -log(1 - rtt_performance) / target_weeks

  params <- data.frame(
    lambda = lambda_values,

    # ensures lambda * population = referral_rate
    total_population = referral_rate / lambda_values,
    percent_within_target = 100 * pexp(target_weeks, rate = lambda_values)
  )

  # we want a weekly histogram from 1 to 64 weeks
  # n_bins <- 64

  # expand out a dataset with sufficient resolution (100 data points per bin)
  df <- expand.grid(
    x = seq(0, n_bins, length.out = n_bins * 100),
    lambda = lambda_values
  ) |>
    dplyr::left_join(params, by = "lambda") |>
    dplyr::mutate(
      density = dexp(.data$x, rate = .data$lambda),
      population_y = .data$density * .data$total_population
    )

  # create a binned data summary ready for histogram plotting
  df_binned <- df |>
    dplyr::mutate(bin = ggplot2::cut_number(.data$x, n_bins)) |>
    dplyr::group_by(
      .data$lambda,
      .data$total_population,
      .data$percent_within_target,
      .data$bin
    ) |>
    dplyr::summarise(
      height = mean(.data$population_y),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      # get the first digit from the bin factor
      x_min = as.numeric(stringr::str_extract(.data$bin, "\\d+(?=,)")),
      label = forcats::fct_reorder(
        paste0(
          format(round(.data$total_population, 0), big.mark = ","),
          " patients = ",
          .data$percent_within_target,
          "% RTT"
        ),
        dplyr::desc(.data$total_population)
      )
    )

  # build a dataframe to drive a plot annotation
  annotation_df <- df_binned |>
    dplyr::select("label") |>
    dplyr::distinct()

  # define the colours needed
  colours <- c("#DEEBF7", "#9ECAE1", "#6BAED6", "#4292C6", "#2171B5")

  # build the plot
  p <- ggplot2::ggplot(
    df_binned,
    ggplot2::aes(x = .data$x_min, y = .data$height, fill = .data$label)
  ) +
    ggplot2::scale_fill_manual(values = colours) +
    # overlaid semi-transparent bars
    ggplot2::geom_col(position = "identity", just = 0) +
    ggplot2::geom_vline(
      xintercept = target_weeks,
      colour = "red",
      linetype = "dashed"
    ) +

    # red target box
    ggplot2::annotate("rect",
      xmin = target_weeks, xmax = target_weeks + 30, # box position on x-axis
      ymin = referral_rate * 0.9, ymax = referral_rate, # box position on y-axis
      fill = "white",
      colour = "red"
    ) +

    # red target text
    ggplot2::annotate("text",
      x = target_weeks + 15, # centre of the text
      y = referral_rate * 0.95, # centre of the box
      label = "Target 92% by 18 weeks",
      colour = "red",
      # size = ggplot2::rel(5)
    ) +
    ggplot2::labs(
      title = "Waiting List Size and Corresponding RTT Performance Levels",
      subtitle = paste0(
        "For referral rate of ",
        referral_rate,
        " patients/wk \n",
        "Assuming a typical exponential",
        " waiting time distribution"
      ),
      caption = "Source: {NHSRwaitinglist} R package",
      x = "Weeks waiting",
      y = "Number of patients (or pathways)",
      fill = "Waiting List & \nRTT Performance"
    ) +
    ggplot2::theme_minimal(base_size = 12)

  return(p)
}

#' Make an RTT improvement report
#'
#' @param referral_rates numeric. A numeric vector of referral rates. Each rate
#' will produce a plot in the finished report
#'
#' @returns character. The path to a produced report
#' @export
#'
rep_rtt_improvement <- function(referral_rates) {
  # ---- staging area ----
  stage_dir <- tempfile("quarto-report-")
  dir.create(stage_dir, recursive = TRUE)

  # copy template into staging (helps with relative paths, resources, etc.)
  template_qmd <- system.file(
    "quarto",
    "rtt_improvement_report.qmd",
    package = "NHSRwaitinglist"
  )

  stage_qmd <- file.path(stage_dir, basename(template_qmd))
  file.copy(template_qmd, stage_qmd, overwrite = TRUE)

  # ---- render ----
  # we render into stage_dir, then copy final artifact to here::here()
  quarto::quarto_render(
    input = stage_qmd,
    execute_params = list(
      referral_rates = referral_rates
    )
  )

  # path to the rendered file
  rendered_file <- file.path(
    stage_dir,
    paste0(tools::file_path_sans_ext(basename(stage_qmd)), ".html")
  )

  # copy to user destination
  ok <- file.copy(rendered_file, here::here(), overwrite = TRUE)
  if (!ok) {
    stop(
      "Failed to copy rendered report to user_filepath.",
      call. = FALSE
    )
  }

  return(
    file.path(here::here(), basename(rendered_file))
  )
}
