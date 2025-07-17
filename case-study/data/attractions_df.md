#### `attractions_df`

**Type:** R Data Frame

**Provenance:**

This data frame contains the list of tourist attractions in Chicago used to identify nearby Divvy stations likely to serve visitors rather than commuters.

**Source Data:**

- Imported from the [`attractions.csv`](attractions.csv.md) file.

**Generation Steps:**

1. Loaded via `read.csv()` specifying `stringsAsFactors = FALSE`.
2. Column names: 
 
   - `Name` (attraction name)  
   - `lat` (latitude in decimal degrees)  
   - `long` (longitude in decimal degrees)

**Purpose:**

Provides the reference points for:

- Generating `nearby_stations_df` (stations within a defined proximity to attractions).
- Supporting spatial filtering to improve focus on commuter-oriented usage patterns.

**Key Columns:**

- `Name`
- `lat`
- `long`

**Note:**

Compared to [`tourist_attractions.csv`](archive/tourist_attractions_csv), this file:

- May have slightly less precise coordinates.
- Was retained for reproducibility and consistency in the final analysis.

**Command Used**

```r
attractions_df <- read.csv("/home/sas/classes/Google/data-analytics/data/tourist_attractions.csv", stringsAsFactors = FALSE)
```
