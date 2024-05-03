## code to prepare `demo-data` dataset goes here
demo_df <- data.frame(hospital_site=c("ABC001","DHR70","JRW20","RFW002","DHR70"),
                     main_spec_code = c(100,110,120,130,100),
                     opcs4_code = c("T202","W401","F344","C866","T272"),
                     n= 366,
                     mean_arrival_rate= c(50,25,20,40,50),
                     mean_wait = c(21,20,10,30,21),
                     start_date = c("2024-01-01","2023-04-01","2024-04-01","2023-01-01","2024-01-01"),
                     sd=10,
                     rott=c(0,0.1,0.05,0.2,0.1)
  )

usethis::use_data(demo_df, overwrite = TRUE)
