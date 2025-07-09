### `ride_props`

**Description:**  
Calculates the proportion of rides occurring in each hour relative to the total rides for that week part (Weekday or Weekend).

**Provenance Details:**

- **Source Data Frame:**  
  [`rides_by_hour_weekpart`](rides_by_hour_weekpart.md)

- **Transformations:**
  - Grouped by `week_part`.
  - Computed the proportion of rides within each hour by dividing `ride_count` by the sum of `ride_count` in that week part.

- **Code:**

  ```r
  ride_props <- rides_by_hour_weekpart %>%
      group_by(week_part) %>%
      mutate(
          prop = ride_count / sum(ride_count)
      )
```
**Purpose:**

  -  To facilitate comparison of hourly ride distribution between weekdays and weekends by normalizing counts into proportions.


