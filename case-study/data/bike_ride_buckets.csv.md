#### `bike_ride_buckets.csv`

**Type:** CSV File

**Description:**  
A summary CSV showing how many bikes fall into each range of total rides taken.

**Source & Processing:**
- Data source: `rides` table.
- Steps performed in SQLite:
  1. Counted the total rides per `bike_id` (`GROUP BY bike_id`).
  2. Divided each bike’s ride count into buckets in increments of 100:
     - For example, rides 0–99, 100–199, etc.
     - Used `(ride_count / 100) * 100` to define the start of each bucket.
  3. Counted how many bikes fell into each bucket.
  4. Added `bucket_end` as `bucket_start + 99` to label the ranges.
- Exported with `.mode csv` and `.headers on`.

**Purpose:**  
- Provides an aggregated view of bike usage distribution.
- Helps analyze fleet utilization patterns (e.g., how many bikes are heavily vs. lightly used).

**Commands Used**

```sql
.headers on
.mode csv
.output bike_ride_buckets.csv
WITH bucketed AS (
  SELECT
    (ride_count / 100) * 100 AS bucket_start,
    COUNT(*) AS bike_count
  FROM (
    SELECT bike_id, COUNT(*) AS ride_count
    FROM rides
    WHERE bike_id IS NOT NULL
    GROUP BY bike_id
  )
  GROUP BY bucket_start
  ORDER BY bucket_start
)
SELECT
  bucket_start,
  bucket_start + 99 AS bucket_end,
  bike_count
FROM bucketed;
.output stdout
```
