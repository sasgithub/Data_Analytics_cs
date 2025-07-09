### `rider_readable`

**Description:**  
A human-friendly view of ride records with timestamps converted to readable formats and categorical fields labeled.

**Source & Processing:**

- Base table: `rides`
- Transformations applied:

  - Converted `start_time` and `end_time` from Unix epoch integers to ISO-formatted datetime strings (`datetime(..., 'unixepoch')`).
  - Mapped `user_type` codes to labels:

    - `0` → `subscriber`
    - `1` → `customer`
    - all others → `unknown`
  - Mapped `gender` codes to labels:

    - `0` → `male`
    - `1` → `female`
    - all others → `unknown`

**Purpose:**  

- Simplifies inspection and validation of ride data.
- Provides easily interpretable records for ad hoc querying, debugging, and export.

**Command Used**

```sql
CREATE VIEW rider_readable AS
SELECT
  ride_id,
  bike_type,
  bike_id,
  datetime(start_time, 'unixepoch') AS start_time,
  datetime(end_time, 'unixepoch') AS end_time,
  start_station_id,
  end_station_id,
  CASE user_type
    WHEN 0 THEN 'subscriber'
    WHEN 1 THEN 'customer'
    ELSE 'unknown'
  END AS user_type,
  CASE gender
    WHEN 0 THEN 'male'
    WHEN 1 THEN 'female'
    ELSE 'unknown'
  END AS gender,
  birth_year
FROM rides
```
