#### nearby_stations_df.rds

**Type:** RDS File

**Description**

This RDS file contains the [nearby_stations_df](nearby_stations_df.md) data frame. It was derived by identifying all Divvy stations located within a 600-meter radius of any point in attractions_df (which was read from attractions.csv). The filtering was performed using geodesic distance calculations applied across all station coordinates. Stations meeting this proximity threshold were included to facilitate analyses that distinguish tourist-adjacent station activity.

Conveniently available as [nearby_stations_df.rds](nearby_stations_df.rds.md) for you importing pleasure.
