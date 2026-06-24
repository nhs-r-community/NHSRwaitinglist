#' Plot a Waiting-list Histogram Against a Fitted Geometric Distribution
#'
#' @param fit A result from [wl_fit_geometric_hist()] or a histogram data frame
#'   that can be passed to [wl_fit_geometric_hist()].
#' @param title Plot title.
#' @param subtitle Plot subtitle.
#' @param caption Plot caption.
#'
#' @return A ggplot object.
#' @export
vis_plot_geometric_hist <- function(
  fit,
  title = "Waiting List Histogram",
  subtitle = "Observed counts vs fitted geometric distribution",
  caption = NULL
) {
  if (!inherits(fit, "wl_geometric_hist_fit")) {
    fit <- wl_fit_geometric_hist(fit)
  }
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package `ggplot2` is required to plot a fitted histogram")
  }
  if (!requireNamespace("scales", quietly = TRUE)) {
    stop("Package `scales` is required to plot a fitted histogram")
  }

  plot_data <- fit$fitted
  plot_data$observed_label <- "Observed"
  plot_data$fitted_label <- "Fitted geometric"

  ggplot2::ggplot(plot_data, ggplot2::aes(x = .data$weeks_waiting)) +
    ggplot2::geom_col(
      ggplot2::aes(y = .data$n, fill = .data$observed_label),
      width = 0.9,
      alpha = 0.82
    ) +
    ggplot2::geom_line(
      ggplot2::aes(y = .data$fitted_n, color = .data$fitted_label),
      linewidth = 1.1
    ) +
    ggplot2::geom_point(
      ggplot2::aes(y = .data$fitted_n, color = .data$fitted_label),
      size = 0.9,
      alpha = 0.7
    ) +
    ggplot2::scale_y_continuous(labels = scales::label_comma()) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, max(plot_data$weeks_waiting, na.rm = TRUE), by = 10),
      minor_breaks = seq(0, max(plot_data$weeks_waiting, na.rm = TRUE), by = 5)
    ) +
    ggplot2::scale_fill_manual(values = c("Observed" = "#2F6B9A"), name = NULL) +
    ggplot2::scale_color_manual(values = c("Fitted geometric" = "#C43C2E"), name = NULL) +
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      x = "Weeks waited",
      y = "Incomplete pathways",
      caption = caption
    ) +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = 15),
      plot.subtitle = ggplot2::element_text(color = "gray30"),
      panel.grid.minor.y = ggplot2::element_blank(),
      legend.position = "bottom",
      plot.caption = ggplot2::element_text(hjust = 0, color = "gray40")
    )
}
