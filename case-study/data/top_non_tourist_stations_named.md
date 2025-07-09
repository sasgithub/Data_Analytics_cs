### Provenance: `top_non_tourist_stations_named`

This data frame was derived from `top_non_tourist_stations` by enriching it with station metadata and selecting the top entries.  

**Transformation Steps:**
- **Join:**
  - Performed an `inner_join()` with `stations_df` on `station_id` to append station names and coordinates.
- **Sorting:**
  - Sorted all rows by `customer_ride_count` in descending order.
- **Selection:**
  - Retained only the top 25 stations with the highest customer ride counts.

The resulting `top_non_tourist_stations_named` data frame contains the most popular non-tourist stations (by customer rides), including their names and location details.

