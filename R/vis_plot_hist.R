#' Plot Actual vs Geometric Target Waiting List Histogram
#'
#' This function plots the actual waiting list histogram against a geometric target distribution.
#'
#' @param wl_hist Data frame containing waiting list history.
#' @param target Numeric. Target number of weeks for the geometric distribution (e.g., 18).
#' @param percentage Numeric. Percentile to highlight (e.g., 92).
#'
#' @return A ggplot object showing the actual and target distributions.
#' @export
vis_plot_hist <- function(wl_hist, target = 18, percentage = 92) {
    cutoff_2 <- 52
    cutoff_1 <- 18

    # reassign the waiting list history to a new variable
    wl_hist_ <- wl_hist 

    # Gather statistics required for plotting
    percentile <- wl_percentile_hist(wl_hist_, percentage)
    referral_stats <- wl_referral_stats_hist(wl_hist_, percentile$percentage)
    demand_weekly <- referral_stats$demand_weekly
    q_target <- calc_target_queue_size(
        demand = demand_weekly,
        target_wait = target,
        factor = 2.52
    )
    q_size <- wl_queue_size_hist(wl_hist_)

    wl_hist_$weeks_waiting <- round(as.numeric(difftime(wl_hist_$report_date, wl_hist_$arrival_since, units = "weeks")))
    wl_hist_ <- wl_hist_[, c("report_date", "arrival_before", "arrival_since", "weeks_waiting", "n")]

    p <- 1-exp(log(1- percentage/100) / target)

    # Add row number and geometric probabilities
    wl_hist_ <- wl_hist_ %>%
        mutate(
            row_number = row_number(),  # treat row number as "week k"
            geom_prob = round(q_target*dgeom(row_number - 1, prob = p))
        )

    actual_label <- paste0("Actual (", round(q_size), ")")
    target_label <- paste0("Target (", round(q_target), ")")

    ggplot(wl_hist_, aes(x = weeks_waiting)) +
        geom_col(aes(y = n, fill = actual_label), color = NA) +
        geom_col(aes(y = geom_prob, fill = target_label), color = NA, alpha = 0.4) +
        scale_fill_manual(
            name = "Legend",
            values = setNames(c("#4682B4", "#FFA500"), c(actual_label, target_label))
        ) +
        labs(
            title = "Waiting List: Actual vs Target",
            x = "Weeks Waiting",
            y = "Number of Patients"
        ) +
        coord_fixed(ratio = 0.15) +
        geom_vline(xintercept = as.numeric(cutoff_2), linetype = "dashed", color = "red") +
        geom_vline(xintercept = as.numeric(cutoff_1), linetype = "dashed", color = "blue") +
        geom_vline(xintercept = as.numeric(percentile$weeks), linetype = "dashed", color = "orange") +
        annotate("text", x = cutoff_2, y = max(wl_hist_$n), label = "52 weeks ago",
                angle = 90, vjust = -0.4, hjust = 1, color = "red") +
        annotate("text", x = cutoff_1, y = max(wl_hist_$n), label = "18 weeks ago",
                angle = 90, vjust = -0.4, hjust = 1, color = "blue") +
        annotate("text", x = percentile$weeks, y = max(wl_hist_$n), label = "92nd percentile",
                angle = 90, vjust = -0.4, hjust = 1, color = "orange") +
        theme_minimal() +
        theme(
            axis.text.x = element_text(angle = 0, hjust = 1),
            legend.position = c(0.98, 0.98),
            legend.justification = c("right", "top")
        )
}
