#### rides_per_hour_tbl

**Type:** SQLite Table

**Description:**
  
The `rides_per_hour_tbl` table is a materialized version of hourly ride counts by user type, optimized for repeated querying.

**Provenance:**

- **Source Data:**

  - `rides` table.

- **Process:**

  1. For each ride, computed the hour start timestamp (`epoch`) by flooring `start_time` to the nearest hour.
  2. Converted `user_type` numeric codes to labels (`subscriber`, `customer`, `unknown`).
  3. Grouped by `epoch` and `user_type` and counted total rides.
  4. Stored the results in a permanent table to avoid recomputation.

- **SQL Definition:**

  ```sql
  CREATE TABLE rides_per_hour_tbl AS
  SELECT
    CAST((start_time / 3600) * 3600 AS INTEGER) AS epoch,
    CASE user_type
         WHEN 0 THEN 'subscriber'
         WHEN 1 THEN 'customer'
         ELSE 'unknown'
    END AS user_type,
    COUNT(*) AS rides
  FROM rides
  GROUP BY epoch, user_type;
```

**Indexing:**

  -  An index was created to improve lookup performance:

    ```SQL
    CREATE INDEX idx_rides_per_hour_epoch
     ON rides_per_hour_tbl(epoch, user_type);
    ```

**Usage Notes:**

  -  Facilitates rapid joins with hourly_weather.

  -  Preferred over the view for performance when working with large time ranges or repeated analyses.

