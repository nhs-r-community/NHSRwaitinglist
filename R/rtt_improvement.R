
#' Plot RTT improvement journey
#'
#' @param referral_rate numeric. A weekly referral rate to plot
#'
#' @returns ggplot object
#' @export
#'
plot_rtt_journey <- function(referral_rate){

  # rtt performance levels to include in the plot
  rtt_performance <- c(0.5, 0.60, 0.70, 0.80, 0.92)

  # the NHS referral to treatment standard is 92% treated by 18 weeks
  target_weeks <- 18 # weeks

  # get the exponential lambda values for each rtt performance level
  lambda_values <- -log(1 - rtt_performance) / target_weeks

  params <- data.frame(
    lambda = lambda_values,
    total_population = referral_rate / lambda_values, # ensures lambda * population = referral_rate
    percent_within_target = 100 * pexp(target_weeks, rate = lambda_values)
  )

  # we want a weekly histogram from 1 to 64 weeks
  n_bins <- 64

  # expand out a dataset with sufficient resolution (100 data points per bin)
  df <- expand.grid(
    x = seq(0, n_bins, length.out = n_bins * 100),
    lambda = lambda_values
  ) |>
    dplyr::left_join(params, by = "lambda") |>
    dplyr::mutate(
      density = dexp(x, rate = lambda),
      population_y = density * total_population
    )

 # create a binned data summary ready for histogram plotting
  df_binned <- df |>
    dplyr::mutate(bin = ggplot2::cut_number(x, n_bins)) |>
    dplyr::group_by(lambda, total_population, percent_within_target, bin) |>
    dplyr::summarise(
      height = mean(population_y),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      x_min = as.numeric(stringr::str_extract(bin, "\\d+(?=,)")), # get the first digit from the bin factor
      label = forcats::fct_reorder(
        paste0(format(round(total_population, 0), big.mark = ","), " patients = ", percent_within_target,"% RTT"),
        dplyr::desc(total_population)
      )
    )

  # build a dataframe to drive a plot annotation
  annotation_df <- df_binned |>
    dplyr::select(label) |>
    dplyr::distinct()

  # skip the lightest colour, and hand pick the rest
  colours <- RColorBrewer::brewer.pal(9, "Blues")[c(2, 4, 5, 6, 7)]

  # build the plot
  p <- ggplot2::ggplot(df_binned, ggplot2::aes(x = x_min, y = height, fill = label)) +
    ggplot2::scale_fill_manual(values = colours) +
    ggplot2::geom_col(position = "identity", just = 0) +   # overlaid semi-transparent bars
    ggplot2::geom_vline(xintercept = target_weeks, colour = "red", linetype = "dashed") +

    # red target box
    ggplot2::annotate("rect",
             xmin = target_weeks, xmax = target_weeks + 30,      # box position on x-axis
             ymin = referral_rate * 0.9,  ymax = referral_rate,  # box position on y-axis
             fill = "white",
             colour = "red") +

    # red target text
    ggplot2::annotate("text",
             x = target_weeks + 15, # centre of the text
             y = referral_rate * 0.95,  # centre of the box
             label = "Target 92% by 18 weeks",
             colour = "red",
             #size = ggplot2::rel(5)
             ) +

    ggplot2::labs(
      title = glue::glue("Waiting List Size and Corresponding RTT Performance Levels"),
      subtitle = glue::glue("For referral rate of {referral_rate} patients/wk \nAssuming a typical exponential waiting time distribution"),
      caption = "Source: {NHSRwaitinglist} R package",
      x = "Weeks waiting",
      y = "Number of patients (or pathways)",
      fill = "Patients Waiting & \nRTT Performance"
    ) +
    ggplot2::theme_minimal(base_size = 12)

  return(p)
}
