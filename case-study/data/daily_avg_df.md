#### **Data Frame:** `daily_avg_df`

Average number of rides per day since January 2023, grouped by user type and bike type.

```r
daily_avg_df <- post_electric_rides_df %>%
    group_by(user_type, bike_type) %>%
    summarise(
        avg_rides_per_day = mean(ride_count),
        .groups = "drop"
    )
```

**Rationale for January 2023 Start Date**

Electric bikes (e-bikes) were introduced into the Divvy fleet starting in January 2023. Because the adoption of e-bikes significantly affected ride patterns, trip frequency, duration, and user preferences, the analysis of post-2023 ride data was separated from earlier periods to ensure clear attribution of trends.

The post_electric_rides_df and daily_avg_df data frames were derived exclusively from rides after this introduction date. This separation allows for:

 -  Focused analysis of e-bike utilization compared to traditional bikes.
 -  Comparison of subscriber and casual user behaviors in the e-bike era.
 -  Avoidance of bias from mixing fundamentally different vehicle types in aggregate metrics.

