% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/wl_join.R
\name{wl_join}
\alias{wl_join}
\title{Join two waiting list}
\usage{
wl_join(wl_1, wl_2, referral_index = 1)
}
\arguments{
\item{wl_1}{a waiting list: dataframe consisting addition and removal dates}

\item{wl_2}{a waiting list: dataframe consisting addition and removal dates}

\item{referral_index}{the column index where referrals are listed}
}
\value{
updated_list a new waiting list
}
\description{
Take two waiting list and sorting in date order
}
\examples{

referrals <- c.Date("2024-01-01","2024-01-04","2024-01-10","2024-01-16")
removals <- c.Date("2024-01-08",NA,NA,NA)
wl_1 <- data.frame("referral" = referrals ,"removal" = removals )

referrals <- c.Date("2024-01-04","2024-01-05","2024-01-16","2024-01-25")
removals <- c.Date("2024-01-09",NA,"2024-01-19",NA)
wl_2 <- data.frame("referral" = referrals ,"removal" = removals )
wl_join(wl_1,wl_2)

}
