Data Sources

**Data Source**:
```r
duration_by_type <- post_electric_rides_df %>%
    group_by(user_type, bike_type) %>%
    summarise(
        avg_duration = mean(avg_duration_minutes, na.rm = TRUE),
        sd_duration = sd(avg_duration_minutes, na.rm = TRUE),
        .groups = "drop"
    )
```
- **Data Transformation in R:**

```r
duration_by_type$user_type <- fct_recode(as.factor(duration_by_type$user_type),
                                         "Subscriber" = "0",
                                         "Customer" = "1")
```


