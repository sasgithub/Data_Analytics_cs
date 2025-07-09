### `attractions.csv`

**Description:**  
A CSV file containing the list of tourist attractions in Chicago, each with name and geographic coordinates.

**Origin:**
- Created manually as an initial reference list of attractions for proximity analysis.
- Coordinates were collected via Google Maps.
- Columns:
  - `Name`: Name of the attraction.
  - `lat`: Latitude.
  - `long`: Longitude.

**Notes:**
- This was the earlier, simpler version of the attractions dataset.
- Compared to `tourist_attractions.csv`, this file:
  - Uses lower precision coordinates.

**Purpose:**
- Served as the primary input to generate `attractions_df`.
- Used to identify stations within 600 meters of known tourist sites to help isolate commuter-focused stations.

Conveniently available as [attractions_csv](attractions_csv) for your importing pleasure.
