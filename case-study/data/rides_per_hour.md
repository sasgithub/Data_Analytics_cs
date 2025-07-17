#### rides_per_hour

**Type:** SQLite View

**Description:**  
The `rides_per_hour` view summarizes ride counts per hour and user type, creating a time-aligned dataset comparable to hourly weather records.

**Provenance:**

- **Source Data:**

  - [`rides`](rides.md) table (master trip data).

- **Process:**

  - Each ride’s start time (Unix timestamp) was floored to the start of the hour (`CAST((start_time / 3600) * 3600 AS INTEGER)`).
  - User types were converted from numeric codes to descriptive labels (`subscriber` or `customer`).
  - Records were grouped by `epoch` and `user_type`.
  - Counts were aggregated as `rides`.

- **SQL Definition:**

  ```sql
  CREATE VIEW rides_per_hour AS
  SELECT
    CAST((start_time / 3600) * 3600 AS INTEGER) AS epoch,
    CASE user_type
         WHEN 0 THEN 'subscriber'
         WHEN 1 THEN 'customer'
    END AS user_type,
    COUNT(*) AS rides
  FROM rides
  GROUP BY epoch, user_type;
```

**Usage Notes:**

  -  Used to efficiently join hourly ride counts with hourly weather data in the rides_weather view.
  -  Provides a normalized temporal aggregation for analysis.

