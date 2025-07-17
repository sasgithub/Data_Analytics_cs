#### `temp_vs_rides_2.dat`

**Type:** Data File

**Description:**
 
Tab-separated values file used as input to `gnuplot`, showing average ride volume per 2 °C temperature bin.

**Origin:**
- Generated from the `rides_weather` view in SQLite using a SQL query that:
  - Bins temperatures into 2-degree Celsius intervals using `CAST(temp / 2.0 AS INT)*2`.
  - Computes the average number of rides per temperature bin.
- SQL output mode set to:
  - No headers (`.headers off`)
  - Tab-separated (`.mode tabs`)

**Purpose:**
- Used for visualizing how ride volume changes with temperature.
- Designed for easy use in `gnuplot` or other plotting tools that prefer delimited plain-text input.

**Query Used**

```sql
WITH t AS (
  SELECT
    CAST(temp / 2.0 AS INT)*2  AS temp_bin,   -- 2 °C Bin: …, 14, 16, 18 …
    AVG(rides)                 AS avg_rides
  FROM rides_weather
  GROUP BY temp_bin
  ORDER BY temp_bin
)
SELECT temp_bin, avg_rides
FROM t;
```

