#### `weekday_rides_df`

**Type:** R Data Frame

**Description**

This data frame was derived from `non_tourist_customer_rides_df` by filtering to include only rides that took place on weekdays (`week_part == "Weekday"`).  

A new categorical variable, `commute_window`, was created by binning each ride's local start hour (`hour_local`) into five time-of-day intervals using `cut()`:

- **Night (0–5)**
- **Morning Commute (6–9)**
- **Midday (10–15)**
- **Evening Commute (16–19)**
- **Night (20–23)**

The breaks used were `c(-1, 5, 9, 15, 19, 24)`, and the bins were defined as ordered factors. This transformation enabled time-of-day analysis of ride patterns across defined commuting periods.

