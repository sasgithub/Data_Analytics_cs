## Provenance for `stations_df`

### Data Origin
- **Source Table:**  

  - `stations` table (station metadata)

### Query Details
This query simply selected key identifying and geographic fields:

```sql
SELECT
  station_id,
  name,
  latitude AS lat,
  longitude AS long
FROM stations;
```

### Selected Fields
- `station_id`: Unique numeric station identifier.
- `name`: Station name.
- `lat`: Latitude.
- `long`: Longitude.

### Purpose and Use
This dataset was used to:
- Join station locations to ride data.
- Generate station reference lists.
- Support mapping and distance calculations (e.g., identifying stations near tourist attractions).


### Command Used

```r
stations_df <- dbGetQuery(con, "SELECT station_id, name, latitude AS lat, longitude AS long FROM stations")
```
