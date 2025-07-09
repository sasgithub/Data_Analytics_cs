### Provenance: `top_non_tourist_stations`

This data frame was created by querying the SQLite `rides` table to identify stations with the highest number of **customer** rides that **started or ended** at non-tourist stations post Covid.  

- **Source tables:** `rides`  
- **Filtering criteria:**
  - `user_type = 1` (customer)
  - `start_station_id` or `end_station_id` in the set of non-tourist stations (`station_ids_sql`)
  - `start_time >= '2023-01-01'` (rides starting on or after January 1, 2023)
- **Aggregation:**
  - Grouped by `start_station_id` (renamed to `station_id`)
  - Counted rides per station

**SQL Summary:**
```sql
SELECT
  start_station_id AS station_id,
  COUNT(*) AS customer_ride_count
FROM rides
WHERE user_type = 1
  AND (start_station_id IN (<non-tourist station IDs>) OR end_station_id IN (<same IDs>))
  AND start_time >= strftime('%s', '2023-01-01')
GROUP BY station_id
```

The resulting table `top_non_tourist_stations` lists each station along with the total number of customer rides associated with it, sorted in descending order (if subsequently sorted in R).

