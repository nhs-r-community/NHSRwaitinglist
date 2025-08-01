# Download excel
# HERE: create a download script for the national data from the NHS England website
# TODO: 

#- Create structure
# raw_data/ -- rtt_data/ provider/ admitted \ non-admitted\ incomplete/  

getwd()



rtt_url <- "https://www.england.nhs.uk/statistics/statistical-work-areas/rtt-waiting-times/"

start_data <- "2024-04-01"
end_data <- "2025-03-31"
providered_or_commissioner <- "Provider" # or "Commissioner"