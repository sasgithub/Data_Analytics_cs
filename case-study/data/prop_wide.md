```r
prop_wide <- ride_props %>%
    select(hour, week_part, prop) %>%
    tidyr::pivot_wider(names_from = week_part, values_from = prop) %>%
    mutate(diff = Weekday - Weekend)
```

