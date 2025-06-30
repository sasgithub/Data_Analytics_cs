```r
post_electric_rides_df <- dbGetQuery(con, "SELECT
   DATE(start_time, 'unixepoch') AS ride_date,
   user_type,
   bike_type,
   COUNT(*) AS ride_count,
   AVG((end_time - start_time) / 60.0) AS avg_duration_minutes
FROM rides
WHERE start_time >= strftime('%s', '2023-01-01') -- first e-bike appeared
GROUP BY ride_date, user_type, bike_type;")
```
