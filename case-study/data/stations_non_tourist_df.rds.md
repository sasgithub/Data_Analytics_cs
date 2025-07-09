**File:** `stations_non_tourist_df.rds`

This RDS file contains the [`stations_non_tourist_df`](stations_non_tourist_df.md) data frame, which represents Divvy stations that are not within 600 meters of any known tourist attraction. It was created by first loading a curated list of tourist destinations from `attractions.csv`, then computing the geodesic distance between each station and every attraction using the Haversine formula. Stations were excluded if they were within 600 meters of any attraction, based on the assumption that such stations are likely to serve tourists. The resulting data frame includes only those stations deemed non-tourist-oriented, and is used as a filtering basis for analyzing local commuting behavior, particularly among casual (customer) riders.

Conveniently available as [stations_non_tourist_df.rds](stations_non_tourist_df.rds) for your importing pleasure.
