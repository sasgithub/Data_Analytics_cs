#### `rides_by_hour_season`

**Type:** R Data Frame

**Description**

This data frame was created to analyze the temporal patterns of customer rides across seasons, weekdays, and hours.  

**Transformation Steps:**

- **Source:**

  - Started from `non_tourist_customer_rides_df`, which contains rides filtered to exclude tourist stations.
- **Feature Engineering:**

  - Extracted `hour` using `lubridate::hour()` from `start_localtime`.
  - Created `week_part`:

    - `"Weekday"` if the day of week was Monday–Friday.
    - `"Weekend"` if Saturday or Sunday.
  - Derived `season` using `case_when()`:

    - December–February → `"Winter"`
    - March–May → `"Spring"`
    - June–August → `"Summer"`
    - September–November → `"Fall"`
- **Aggregation:**

  - Counted rides grouped by `season`, `week_part`, and `hour`.
  - Named the resulting count column `ride_count`.

The resulting `rides_by_hour_season` data frame shows how ride volumes vary over the year and time of week/day.

**Command Used**

```r
rides_by_hour_season <- non_tourist_customer_rides_df %>%
mutate(
hour = lubridate::hour(start_localtime),
week_part = if_else(lubridate::wday(start_localtime) %in% 2:6, "Weekday", "Weekend"),
season = case_when(
month(start_localtime) %in% c(12, 1, 2) ~ "Winter",
month(start_localtime) %in% c(3, 4, 5) ~ "Spring",
month(start_localtime) %in% c(6, 7, 8) ~ "Summer",
month(start_localtime) %in% c(9, 10, 11) ~ "Fall"
)
) %>%
count(season, week_part, hour, name = "ride_count")
```

