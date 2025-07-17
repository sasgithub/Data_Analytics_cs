#### max_concurrent_rides_by_year.csv

**Type:** CSV File

**Description**

This dataset was derived from the rides table in the SQLite database caseStudy.db.
It records the maximum number of rides occurring simultaneously in each calendar year.

**Extraction Process:**

  **Source Table:**

    rides

  **Filtering:**

    No explicit filtering beyond the base data in rides.

  **Transformation Steps:**

    -  Construct an events table by combining all start_time (+1) and end_time (–1) timestamps.
    -  Annotate each event with the ride’s year (strftime('%Y', ts, 'unixepoch')).
    -  Use a windowed cumulative sum (SUM(delta) OVER (...)) to track the number of rides in progress at each event timestamp.
    -  Identify the maximum concurrency per year (MAX(concurrent_rides)).

  **SQL Query:**

```sql
WITH events AS (
  SELECT start_time AS ts, +1 AS delta FROM rides
  UNION ALL
  SELECT end_time AS ts, -1 AS delta FROM rides
),
labeled AS (
  SELECT
    ts,
    delta,
    strftime('%Y', ts, 'unixepoch') AS year
  FROM events
),
scan AS (
  SELECT
    year,
    ts,
    SUM(delta) OVER (
      PARTITION BY year
      ORDER BY ts
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS concurrent_rides
  FROM labeled
)
SELECT year, MAX(concurrent_rides) AS max_simultaneous_rides
FROM scan
GROUP BY year
ORDER BY year;
```

**Output Columns:**

  -  year – Calendar year (4-digit)
  -  max_simultaneous_rides – Peak number of concurrent rides

**Notes:**

  -  The concurrency calculation assumes all timestamps are accurate to the second.
  -  Years with minimal activity (e.g., 2020) reflect pandemic-related usage drops.
  -  This file was exported directly from the query output and saved as max_concurrent_rides_by_year.csv.


