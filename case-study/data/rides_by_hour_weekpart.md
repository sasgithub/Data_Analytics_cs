### `rides_by_hour_weekpart`

**Description:**  
Hourly ride counts for non-tourist customer trips, separated into weekday and weekend buckets.

**Source & Processing:**
- Input data: [`non_tourist_customer_rides_df`](non_tourist_customer_rides_df.md)
- Transformation steps in R:
  - Computed `hour` (0–23) using `lubridate::hour(start_localtime)`.
  - Created `week_part` as:
    - `"Weekend"` if the ride started on Saturday or Sunday (`wday` in {1,7})
    - `"Weekday"` otherwise.
  - Grouped by `week_part` and `hour`.
  - Summarised to count total rides in each combination.

**Purpose:**  
This dataset is used to:
- Analyze temporal riding patterns by day type.
- Support visualization of hourly ride distributions.
- Form the basis for calculating ride proportions (`ride_props`) and difference metrics (`prop_wide`).

** Command Used**

```r
rides_by_hour_weekpart <- non_tourist_customer_rides_df %>%
    mutate(hour = lubridate::hour(start_localtime),
           week_part = ifelse(lubridate::wday(start_localtime) %in% c(1, 7), "Weekend", "Weekday")) %>%
    group_by(week_part, hour) %>%
    summarise(ride_count = n(), .groups = "drop")
```

