#### `top_stations_df`

**Type:** R Data Frame

##### Data Origin
- **Source Tables:**  

  - `rides` table (trip records)  
  - `stations` table (station metadata)  

##### Query Details
This query identified the 50 most-used start stations for each user type.

**Steps:**

1. **Join:**  

   - Joined `rides.start_station_id` to `stations.station_id`.

2. **Aggregation:**  

   - Counted the number of rides starting at each station, grouped by `station_id` and `user_type`.

3. **Ranking:**  

   - Applied `ROW_NUMBER()` partitioned by `user_type`, ordered by descending `COUNT(*)`.

4. **Filter:**  

   - Selected only rows where the rank (`rn`) was ≤ 50.

##### Selected Fields
- `station_id`: Unique ID of the station.
- `name`: Station name.
- `lat`, `long`: Latitude and longitude of the station.
- `user_type`: `subscriber` or `customer`.
- `ride_count`: Total number of rides starting at this station for the user type.
- `rn`: Rank within the top 50 for the user type.

##### Purpose and Use
This dataset was used to:

- Highlight the highest-volume stations by user segment.
- Generate maps and visualizations of popular start locations.
- Support station targeting strategies and user behavior analysis.


##### Command Used

```r
query <- "
WITH ranked_stations AS (
  SELECT
    s.station_id,
    s.name,
    s.lat,
    s.long,
    CASE user_type
      WHEN 0 THEN 'subscriber'
      WHEN 1 THEN 'customer'
    END AS user_type,
    COUNT(*) AS ride_count,
    ROW_NUMBER() OVER (PARTITION BY user_type ORDER BY COUNT(*) DESC) AS rn
  FROM rides
  JOIN stations AS s ON rides.start_station_id = s.station_id
  GROUP BY s.station_id, user_type
)
SELECT * FROM ranked_stations WHERE rn <= 50;
"

top_stations_df <- dbGetQuery(con, query)
```

