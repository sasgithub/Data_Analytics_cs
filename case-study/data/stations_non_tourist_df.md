#### `stations_non_tourist_df`

**Type:** R Data Frame

**Description**

This dataset contains all Divvy stations **not** within 600 m of a tourist attractions as defined in [attractions_df](attractions_df.md).  

**Generation Steps:**

1. Started from `stations_df`, which lists all Divvy stations with IDs, names, and coordinates.
2. Generated `nearby_stations_df` by computing which stations were within **600 meters** of attractions defined in `attractions_df`.
3. Filtered `stations_df` to exclude any station whose `name` appeared in `nearby_stations_df`.

**Purpose:**

This table defines the “non-tourist” stations to enable analysis focused on commuter-oriented activity.  
It serves as the basis for filtering rides and identifying top stations less likely to be dominated by tourist traffic.

**Key Columns:**

- `station_id`
- `name`
- `lat`
- `long`

Conveniently available as [stations_non_tourist_df.rds](stations_non_tourist_df.rds) for your importing pleasures.
