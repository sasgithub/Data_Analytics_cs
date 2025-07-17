## Provenance: `stdres_df` R Data Frame

This data frame contains the standardized residuals from a chi-squared test of the association between hour of day and ride volume by week part (Weekday vs Weekend).

**Source Data:**
- `rides_by_hour_weekpart` - aggregated counts of rides by hour and whether the ride occurred on a weekday or weekend.

**Processing Steps:**

1. **Reshape to Wide Matrix:**
   - Pivot `rides_by_hour_weekpart` to a matrix with:
     - Rows = hours 0–23
     - Columns = Weekday and Weekend ride counts.
   - Fill any missing counts with zero.

```r
# Start with rides_by_hour_weekpart (24 rows: one per hour)
# Pivot so each hour has columns for Weekday and Weekend counts
ride_matrix <- rides_by_hour_weekpart %>%
  tidyr::pivot_wider(
    names_from = week_part,
    values_from = ride_count,
    values_fill = 0  # fill missing combinations with 0
  ) %>%
  dplyr::arrange(hour) %>%        # ensure rows are in order by hour
  dplyr::select(-hour) %>%        # remove hour column so matrix is numeric
  as.matrix()                     # convert to numeric matrix (required for chisq.test)

# Now ride_matrix looks like:
#       Weekday Weekend
# 0        123      45
# 1        100      42
# ...
# 23        89      30

# Perform the chi-squared test of independence
test_result <- chisq.test(ride_matrix)

# Extract standardized residuals (measure of deviation)
stdres_df <- as.data.frame(test_result$stdres)

# Re-attach hour labels to the residuals
stdres_df$hour <- 0:23

# The resulting stdres_df contains:
# Weekday residuals, Weekend residuals, and the hour
```

**Chi-squared Test:**

  -  Performed Pearson’s chi-squared test to check independence between hour of day and week part.
  -  Extracted standardized residuals (measure of contribution to the chi-squared statistic).

```r
test_result <- chisq.test(ride_matrix)
stdres_df <- as.data.frame(test_result$stdres)
```

**Attach Hour Labels:**

  -  Added an hour column (0–23) for clarity.

```r
       stdres_df$hour <- 0:23
```

**Columns in stdres_df:**

  -  Weekday: Standardized residuals for Weekday counts.
  -  Weekend: Standardized residuals for Weekend counts.
  -  hour: Hour of day (0–23).

**Interpretation:**

    Residuals > +2 or < –2 indicate significantly more or fewer rides than expected under independence.

