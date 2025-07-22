#### `hourly_weather`

**Type:** SQLite Table 

**Description**

The hourly_weather table stores hourly weather conditions recorded at Chicago Midway Airport from 2013 through 2025, aligning with the time range of the Divvy bike data. It provides weather context that can be joined to bike ride data for time-aware analysis.

**Schema Highlights**

  -  time — UTC timestamp of the observation (stored in ISO 8601 or Unix epoch format depending on import settings).
  -  temp — Air temperature in degrees Celsius.
  -  dwpt — Dew point in °C.
  -  rhum — Relative humidity (%).
  -  prcp — Precipitation in mm.
  -  wspd — Wind speed in km/h.
  -  pres — Atmospheric pressure in hPa.
  -  coco — Weather condition code (e.g., clear, cloudy, rain).

**Origin & Ingestion**

  -  Extracted from the Metostat bulk hourly archive for station KMDW (Chicago Midway).
  -  Parsed and cleaned in R using load_clean_write_weather_data.R, then written to SQLite with appropriate data typing and indexing on the time field.

**Purpose**

  -  Supports correlation of ride volume and user behavior with weather factors.
  -  Enables time-based joins with ride start or end times for enriched analysis.


**How this fits into the flow**

This table was used as the authoritative hourly weather reference for

- Joining with hourly aggregated ride counts (`rides_per_hour` view).
- Creating the `rides_weather` view combining weather and ridership patterns.
- Supporting time series and correlation analyses of temperature, precipitation, and ride volume.


**Table Creation Command**

```r
con <- dbConnect(RSQLite::SQLite(), "/home/sas/classes/Google/data-analytics/data/caseStudy.db")
> dbExecute(con, "
+    CREATE TABLE hourly_weather (
+      epoch INTEGER PRIMARY KEY,
+      temp REAL,
+      dwpt REAL,
+      rhum INTEGER,
+      prcp REAL,
+      wdir INTEGER,
+      wspd REAL,
+      coco INTEGER
+   )
+ ")
> dbWriteTable(con, "hourly_weather", df, append = TRUE)
```
