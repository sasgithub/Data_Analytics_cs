### `nearby_stations_df`

**Type:** R Data Frame

**Provenance:**

This data frame was created to identify Divvy stations located near known tourist attractions.

**Source Data:**

- [`stations_df`](stations_df.md): List of all Divvy stations with names and coordinates (from the `stations` table in SQLite).
- [`attractions_df`](attractions.md): List of tourist attractions loaded from `attractions.csv`.

**Generation Steps:**

1. For each attraction in `attractions_df`, the `find_nearby_stations()` function was applied.
2. The function computed the Haversine distance between the attraction’s coordinates and each station.
3. All stations within a 600-meter radius were selected.
4. For each nearby station, the distance and the associated attraction name were recorded.
5. The resulting subsets for each attraction were combined with `bind_rows()` into a single data frame.

**Purpose:**

Serves as the reference set of “tourist stations,” enabling:

- Filtering of rides to exclude trips likely associated with tourist activity.
- Identifying stations requiring special consideration in analysis of commuter patterns.

**Key Columns:**

- `station_id`
- `name` (station name)
- `lat`, `long` (station coordinates)
- `distance_m` (meters to attraction)
- `attraction` (name of nearby attraction)

Conveniently available as [nearby_stations_df.rds](nearby_stations_df.rds) for your importing pleasure.
