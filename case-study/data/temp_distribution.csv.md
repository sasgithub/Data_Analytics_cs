#### temp_distribution.csv

**Type:** CSV File

**Description:**  
CSV file summarizing the number of hourly observations per 2 °C temperature bin across the entire weather dataset.

**Provenance:**

- **Source Data:**
  - `hourly_weather` table in SQLite (specifically the `temp` column, representing degrees Celsius).

- **Likely Process:**
  1. Rounded or floored each `temp` value to the nearest even integer using a binning rule such as:
     ```sql
     CAST(temp / 2.0 AS INT) * 2
     ```
  2. Counted the number of hourly weather records falling into each bin.
  3. Output written as a CSV with two columns:
     ```
     temp_bin,count
     ```

**Sample SQL (reconstructed):**
```sql
.headers on
.mode csv
.output temp_distribution.csv

SELECT
  CAST(temp / 2.0 AS INT) * 2 AS temp_bin,
  COUNT(*) AS count
FROM hourly_weather
GROUP BY temp_bin
ORDER BY temp_bin;

.output stdout
```

**Usage Notes:**

  -  Useful for visualizing or validating the distribution of temperature observations in your weather data.
  - Commonly referenced alongside avg_temp_vs_rides.tsv or temp_vs_rides_avg.csv to contextualize ride volume against sample sizes in each temperature bin.
