### `duration_by_type`

**Description:**  
Summarized ride duration statistics by user type and bike type.

**Source & Processing:**  
- Derived from [`post_electric_rides_df`](post_electric_rides_df.md), which contains daily ride counts and average durations for rides since the introduction of e-bikes (January 1, 2023).
- Grouped by `user_type` and `bike_type`.
- For each group, calculated:
  - `avg_duration`: Mean of average ride durations (minutes).
  - `sd_duration`: Standard deviation of average ride durations.
- User type labels were recoded to human-readable form ("Subscriber" and "Customer").

**Purpose:**  
Provides a concise summary of ride duration behavior across different rider categories and bike types to support descriptive analysis and visualization.

**Commands Used**:

```r
duration_by_type <- post_electric_rides_df %>%
    group_by(user_type, bike_type) %>%
    summarise(
        avg_duration = mean(avg_duration_minutes, na.rm = TRUE),
        sd_duration = sd(avg_duration_minutes, na.rm = TRUE),
        .groups = "drop"
    )

duration_by_type$user_type <- fct_recode(as.factor(duration_by_type$user_type),
                                         "Subscriber" = "0",
                                         "Customer" = "1")
```


