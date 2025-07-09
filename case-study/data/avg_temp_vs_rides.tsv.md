### avg_temp_vs_rides.tsv

**Description:**  
Tab-separated summary table aggregating the *average* hourly ride counts by temperature bin and user type.

**Provenance:**

- **Source Tables:**
  - `rides_per_hour_tbl` (pre-aggregated hourly ride counts)
  - `hourly_weather` (hourly temperature observations)

- **Process:**
  1. For each hour:
     - Joined ride counts with weather by epoch timestamp.
     - Binned temperatures into 2 °C intervals (e.g., –10, –8, …, 34).
  2. For each bin and user type, summed hourly rides.
  3. Calculated the *average* hourly rides in each bin, yielding:
     - `total`: average rides from all users
     - `subs`: average subscriber rides
     - `cust`: average customer rides
  4. Wrote results to a tab-separated file with columns:
     ```
     temp_bin  total  subs  cust
     ```

**SQL Snippet:**
```sql
.headers off
.mode tabs
.output avg_temp_vs_rides.tsv

WITH binned AS (
    SELECT
        CAST(temp / 2.0 AS INT) * 2 AS temp_bin,
        r.user_type,
        SUM(r.rides) AS rides
    FROM rides_per_hour_tbl r
    JOIN hourly_weather w ON w.epoch = r.epoch
    GROUP BY temp_bin, r.user_type
), pivot AS (
    SELECT
        temp_bin,
        AVG(rides) AS total,
        AVG(CASE WHEN user_type='subscriber' THEN rides END) AS subs,
        AVG(CASE WHEN user_type='customer' THEN rides END) AS cust
    FROM binned
    GROUP BY temp_bin
    ORDER BY temp_bin
)
SELECT temp_bin, total, subs, cust
FROM pivot;

.output stdout

