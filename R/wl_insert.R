


# TO DO: What if more columns
# Check column types

wl_insert <- function(waiting_list, additions, referral_index = 1) {
  # split waiters and removed


  new_rows = rbind(waiting_list,
                   matrix(NA,
                          nrow = length(additions),
                          ncol = NCOL(waiting_list),
                          dimnames = list(NULL, colnames(waiting_list))
                          )
                   )
  new_rows[,referral_index] <- additions

  # recombine to update list
  updated_list <- rbind(waiting_list,new_rows)
  updated_list <- updated_list[order(updated_list[,referral_index]),]
  return (updated_list)
}