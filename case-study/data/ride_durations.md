#### `ride_durations`

**Type:** R Data Frame

**Description**
Contains ride durations in minutes for valid trips by subscribers and customers. Filters exclude records with invalid or excessively long durations (≥ 200 minutes). Used to analyze trip length distributions by user type, including summary statistics and visualizations.

##### Data Origin
- **Source Table:**  
  `rides` table in the SQLite database  

##### Query Details
This query extracted per-trip durations in minutes with the following conditions:

- **user_type:**  
  Restricted to records where `user_type` is 0 (`subscriber`) or 1 (`customer`).
- **Duration Constraints:**  

  - Excluded records where `end_time <= start_time` (negative or zero durations).
  - Excluded unusually long rides (over ~3.3 hours), specifically durations ≥ 12,000 seconds.

##### Selected Fields
- `user_type` (converted to label: subscriber or customer)
- `duration_min`: Ride duration in minutes, computed as  
  ```
  (end_time - start_time) / 60.0
  ```

##### Purpose and Use
This dataset was used to:

- Summarize ride duration distributions by user type.
- Create histograms and density plots.
- Calculate summary statistics (mean, median, percentiles) of trip durations.

##### Command Used

```r
# Connect to the SQLite database
con <- dbConnect(RSQLite::SQLite(), "caseStudy.db")

# Pull ride durations for valid subscriber/customer rides under 200 min
ride_durations <- dbGetQuery(con, "
  SELECT
    CASE user_type
      WHEN 0 THEN 'subscriber'
      WHEN 1 THEN 'customer'
    END AS user_type,
    (end_time - start_time) / 60.0 AS duration_min
  FROM rides
  WHERE user_type IN (0, 1)
    AND end_time > start_time
    AND (end_time - start_time) < 12000
")
```

