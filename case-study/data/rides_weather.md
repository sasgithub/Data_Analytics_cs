### `rides_weather`

**Description:**  
A SQLite view combining hourly weather observations with hourly ride counts.

**Source & Processing:**  
- Created by joining `hourly_weather` (weather metrics per hour) with `rides_per_hour` (hourly aggregated ride counts by user type).
- LEFT JOIN ensures every hourly weather record is included, even if no rides occurred in that hour.
- Columns include:
  - `epoch`: Hour timestamp (Unix epoch).
  - `user_type`: User type (customer or subscriber).
  - `rides`: Count of rides during the hour (defaults to 0 if none).
  - Weather variables (`temp`, `dwpt`, `rhum`, `prcp`, `wdir`, `wspd`, `coco`).

**Purpose:**  
Supports analysis of the relationship between weather conditions and bike usage volume, enabling correlation studies and visualizations of ride behavior under varying weather.


**Command Used**

```sql
CREATE VIEW rides_weather AS
SELECT
  w.epoch                          AS epoch,        -- seconds since 1970‑01‑01 UTC
  r.user_type,
  COALESCE(r.rides, 0)             AS rides,        -- 0 if no trips that hour
  w.temp,
  w.dwpt,
  w.rhum,
  w.prcp,
  w.wdir,
  w.wspd,
  w.coco
FROM hourly_weather AS w
LEFT JOIN rides_per_hour AS r
       ON r.epoch = w.epoch
```

