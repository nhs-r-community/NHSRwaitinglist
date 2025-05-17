process_hist <- function(df) {
  df2 <- df %>%
    mutate(arrival_since = as.Date(arrival_since)) %>%
    arrange(desc(arrival_since)) %>%
    mutate(arrival_before = lead(arrival_since) - 1) %>%
    select(-n, everything(), n)

  return(df2)
}