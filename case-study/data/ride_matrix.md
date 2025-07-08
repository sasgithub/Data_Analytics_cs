```r
rides_by_hour_weekpart <- non_tourist_customer_rides_df %>%
    mutate(hour = lubridate::hour(start_localtime),
           week_part = ifelse(lubridate::wday(start_localtime) %in% c(1, 7), "Weekend", "Weekday")) %>%
    group_by(week_part, hour) %>%
    summarise(ride_count = n(), .groups = "drop")
```

