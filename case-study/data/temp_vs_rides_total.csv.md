#### temp_vs_rides_total.csv

**Type:** CSV File

**Description:**  
CSV file containing the total number of rides observed in each 2 °C temperature bin, broken out by user type (subscriber vs. customer).

**Provenance:**

- **Source Data:**

  - `rides_weather` view in SQLite (combining hourly ride counts with weather data).

- **Process:**
  1. Bin each temperature observation to the nearest even integer using:

     ```sql
     CAST(temp / 2.0 AS INT) * 2
     ```
  2. Grouped by `temp_bin` and summed ride counts:

     - `total`: sum of all rides (subscribers + customers)
     - `subs`: rides by subscribers
     - `cust`: rides by customers
  3. Output written as a CSV with columns:

     ```
     temp_bin,total,subs,cust
     ```

**Sample SQL (reconstructed):**

```sql
.headers on
.mode csv
.output temp_vs_rides_total.csv

WITH binned AS (
  SELECT
    CAST(temp / 2.0 AS INT)*2 AS temp_bin,
    user_type,
    SUM(rides) AS rides
  FROM rides_weather
  GROUP BY temp_bin, user_type
), pivot AS (
  SELECT
    temp_bin,
    SUM(rides) AS total,
    SUM(CASE WHEN user_type = 'subscriber' THEN rides ELSE 0 END) AS subs,
    SUM(CASE WHEN user_type = 'customer' THEN rides ELSE 0 END) AS cust
  FROM binned
  GROUP BY temp_bin
  ORDER BY temp_bin
)
SELECT temp_bin, total, subs, cust
FROM pivot;

.output stdout
```

**Usage Notes:**

  -  Provides a high-level view of how ride volume varies with temperature across all available hourly observations.
  -  Can be combined with temp_distribution.csv to normalize ride counts by the number of hours observed in each bin.
  -  Frequently used to plot ride volume vs. temperature curves segmented by user type.

Conveniently available as [temp_vs_rides_total.csv](temp_vs_rides_total.csv) for you importing pleasure.

