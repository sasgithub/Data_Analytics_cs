**File:** `ride_durations.rds`

This RDS file contains the [`ride_durations`](ride_durations.md) data frame, which was created by querying the `rides` table to compute the duration of each trip in minutes. The SQL query selected rides where `end_time > start_time` and excluded any rides longer than 12,000 seconds (approximately 3.3 hours) to filter out potential data errors. It also converted numeric `user_type` values into descriptive labels (`subscriber` and `customer`). The resulting data frame has one row per qualifying ride, including columns for `user_type` and `duration_min`. Saving to RDS enables efficient reuse of this pre-cleaned dataset for analysis of ride duration distributions without re-running the query each time.

Convieniently available as [ride_durations.rds](ride_durations.rds) for you importing pleasure.
