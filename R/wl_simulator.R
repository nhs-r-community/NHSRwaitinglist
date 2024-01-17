# PARAMS
# addition rate (average additions per week)
demand <- 3.
# remove rate (average removals per week)
capacity <- 2.

# start date (YYYY/MM/DD)
start_date <- as.Date("2024/01/01")

# end date (YYYY/MM/DD)
end_date <- as.Date("2024/02/01")
number_of_days <- as.numeric(end_date)-as.numeric(start_date)

total_demand <- demand*number_of_days/7
daily_capacity <- capacity/7

# allowing for fluctuations in predicted demand give a arrival list
realized_demand <- rpois(1,total_demand)
referral <- sample(seq(as.Date(start_date), as.Date(end_date), by="day"), realized_demand, replace=TRUE)

referral <- referral[order(referral)]
removal <- rep(as.Date(NA), length(referral))
waiting_list = data.frame(referral,removal)

# create an operating schedule
schedule <- as.Date(as.numeric(start_date)+ceiling(seq(0,number_of_days-1,1/daily_capacity)),origin="1970-01-01")


