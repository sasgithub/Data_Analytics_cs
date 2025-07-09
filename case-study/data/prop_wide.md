### `prop_wide`

**Description:**  
A wide-format data frame comparing the proportion of rides by hour between weekdays and weekends.

**Source & Processing:**  
- Derived from [`ride_props`](ride_props.md), which contained the proportion of hourly rides within each `week_part` (Weekday vs. Weekend).
- Transformation steps:
  - Selected `hour`, `week_part`, and `prop` columns.
  - Pivoted the data wider so each hour has separate columns for `Weekday` and `Weekend` proportions.
  - Computed a `diff` column showing the difference between weekday and weekend ride proportions.

**Purpose:**  
Enables straightforward comparison of ridership distribution by hour across weekdays and weekends, supporting visualizations and further analysis of temporal usage patterns.

**Command Used**

```r
prop_wide <- ride_props %>%
    select(hour, week_part, prop) %>%
    tidyr::pivot_wider(names_from = week_part, values_from = prop) %>%
    mutate(diff = Weekday - Weekend)
```

