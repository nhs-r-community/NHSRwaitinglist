% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/relief_capacity.R
\name{relief_capacity}
\alias{relief_capacity}
\title{Calculate Relief Capacity}
\usage{
relief_capacity(demand, queue_size, target_queue_size, weeks_to_target)
}
\arguments{
\item{demand}{Numeric value of rate of demand in same units as target wait -
e.g. if target wait is weeks, then demand in units of patients/week.}

\item{queue_size}{Numeric value of  current number of patients in queue.}

\item{target_queue_size}{Numeric value of desired number of patients in
queue.}

\item{weeks_to_target}{Numeric value of desired number of time-steps to reach
the target queue size by.}
}
\value{
A numeric value of the required rate of capacity to achieve a target
queue size in a given period of time.
}
\description{
Calculates required relief capacity to achieve target queue size
in a given period of time as a function of demand, queue size, target queue
size and time period.

Relief Capacity is required if Queue Size > 2 * Target Queue Size.

Relief Capacity = Current Demand + (Queue Size - Target Queue Size) / Time
Steps.
}
\examples{
# If demand is 30 patients per week, the current queue size is 1200 and the
# target is to achieve a queue size of 390 in 26 weeks, then
# Relief Capacity = 30 + (1200 - 390) / 26 = 61.15 patients per week.

relief_capacity(30, 1200, 390, 26)
}
