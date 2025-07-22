#### `ride_counts_by_distance`

**Type:** R Data Frame

**Description**
Summarizes the number of rides grouped into distance bins by non-loop rides by customers starting and ending at non-tourist stations on or after 2023-01-01, binned by distan 

**Data Origin:**  
Derived from `non_loop_rides_df`, which includes only non-loop rides by customer riders starting and ending at non-tourist stations on or after 2023-01-01. This dataframe also contains a `distance_km` column representing the calculated ride distance in kilometers.

**Transformation Details:**  
This data frame was created to analyze the distribution of ride distances:

1. **Filter:**  
   - Only includes rides with `distance_km ≤ 10` to focus on short to moderate trips.

2. **Binning:**  
   - Distances are binned in 0.1 km increments:
     ```r
     round(distance_km / 0.1) * 0.1
     ```
     This bins values like 1.04 km and 1.06 km into 1.0 km and 1.1 km respectively.

3. **Aggregation:**  
   - Rides are then counted per distance bin using `count(distance_bin)`.

**Purpose:**  
This summary enables visualization or statistical analysis of how ride frequency varies with distance, and is useful for understanding behavioral patterns like the most common trip lengths among casual non-tourist users.

**Code Used**

```r
ride_counts_by_distance <- non_loop_rides_df %>%
  filter(distance_km <= 10) %>%
  mutate(distance_bin = round(distance_km / 0.1) * 0.1) %>%
  count(distance_bin)
```
