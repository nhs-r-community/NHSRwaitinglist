# cumsum(x)
# X[X = .1] <- 0
# # X[X = .1] <- X[X = .1] + 0

#Count arrivals before start date

wl <- waiting_list
wl[wl$referral<start_date,1] <-start_date
table(wl[,1])

dates <- seq(as.Date(start_date), as.Date(end_date), by="day")
queues <- data.frame(dates,rep(0,length(dates)))
data[which(data$age>10 & data$age<50),]