### stations table

**Description:**  
The canonical reference table of Divvy station locations, IDs, and metadata, stored in SQLite.

**Provenance Summary:**

- **Source Data:**
  - Multiple station datasets from the Divvy S3 Trip Archive and the City of Chicago Data Portal, covering the years 2013–2025.
  - Files included:
    - `Divvy_Bicycle_Stations_20250501.csv`
    - `Divvy_Stations_2013.csv`
    - `Divvy_Stations_2014-Q1Q2.xlsx` (converted to CSV)
    - `Divvy_Stations_2014-Q3Q4.csv`

- **Data Cleaning & Harmonization:**
  - All processing steps—field standardization, column removal, date parsing, ID reassignment, deduplication, and concatenation—are fully documented in [Section 3.1 of the Data Sources page](../data.html#3-1-divvy-station-data-cleaning-and-harmonization).

- **Loading and Storage:**
  - The cleaned records were inserted into the `stations` SQLite table via the `load_stations_table.sh` script.
  - A unique constraint was enforced on `(name, lat, long)` to prevent duplicate locations.
  - The final schema:
    ```sql
    CREATE TABLE stations (
      station_id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      short_name TEXT,
      lat REAL NOT NULL CHECK(lat BETWEEN -90 AND 90),
      long REAL NOT NULL CHECK(long BETWEEN -180 AND 180),
      dbcap INTEGER,
      online_date TEXT
    );
    ```

**Usage Notes:**
- This table is used to enrich trip records with consistent station coordinates and names.
- For reproducibility or schema change tracking, refer to [load_stations_table.sh](../src/load_stations_table.sh) and Section 3.1 of the Data Sources page.

