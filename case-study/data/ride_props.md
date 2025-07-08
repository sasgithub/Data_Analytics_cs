```r
ride_props <- rides_by_hour_weekpart %>%
    group_by(week_part) %>%
    mutate(prop = ride_count / sum(ride_count))
```

