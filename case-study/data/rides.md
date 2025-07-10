### rides Table

**Description:**  
The `rides` table is the master record of all individual bike trips included in the project. Each record corresponds to a single ride, capturing details about trip timing, station locations, user type, and computed metrics (such as distance).

**Provenance:**

- **Source Data:**
  - Divvy Trip Data archive (monthly and yearly CSV files), downloaded from:
    - [Divvy Trip Archive](https://divvy-tripdata.s3.amazonaws.com/index.html)
    - [City of Chicago Data Portal](https://data.cityofchicago.org/Transportation/Divvy-Trips/fg6s-gzvg)

- **Processing Steps:**
  1. **Raw Import:**
     - All CSV files were imported into a staging SQLite table (`rides_raw`), preserving the original column names.
  2. **Column Standardization:**
     - Renamed fields to a consistent schema (e.g., `ride_id`, `start_time`, `end_time`, `start_station_id`, `end_station_id`, `user_type`).
     - Converted date-time strings to Unix epoch seconds (`start_epoch`, `end_epoch`).
  3. **User Type Encoding:**
     - Transformed user type labels (`Subscriber`, `Customer`, `Casual`, `Member`) into a numeric encoding (`user_type`) to ensure uniformity:
       - `0` = Subscriber/Member
       - `1` = Customer/Casual
  4. **Duration and Distance Computation:**
     - Computed ride duration in seconds and minutes.
     - Calculated ride distance in kilometers using the haversine formula between station coordinates.
  5. **Filtering:**
     - Removed records with negative or zero duration.
     - Excluded rides shorter than 60 seconds or longer than 24 hours.
  6. **Joining Station Data:**
     - Merged with the cleaned `stations` table to link station IDs to coordinates.
  7. **Indexing:**
     - Added indexes on `start_time`, `user_type`, and `start_station_id` to improve query performance.

- **Loading and Automation:**
  - All transformations were scripted via `load_rides.sh` (bash) and accompanying R scripts.
  - Final data loaded into the `rides` table in SQLite.

**Usage Notes:**
  - This table underpins nearly all downstream datasets (e.g., ride duration analysis, temporal aggregations, distance distributions).
  - Records are filtered further in analysis scripts (e.g., non-tourist rides, loop rides).
  - The `user_type` numeric code simplifies grouping and pivoting.

**See Also:**
  - [Section 2.2 of the Data Sources page](../data.html#2-2-divvy-trip-data) for more detail on the raw files and schema.
  - [Section 3.2](../data.html#3-2-divvy-trip-data-cleaning-and-harmonization) for full cleaning and harmonization process.

