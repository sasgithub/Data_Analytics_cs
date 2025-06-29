#### Station-to-Station Distance Distribution (Non-Tourist Customers, ≤10 km)

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" alt="Density plot showing distribution of station-to-station distances under 10 km for non-tourist customer rides, with peaks labeled around 1 km and 2.5 km.">
  </a>
  <figcaption>
    Distribution of station-to-station distances for non-tourist customer rides under 10 km. Distinct peaks highlight preferred trip lengths for local travel.
  </figcaption>
</figure>

##### Overview

This density plot visualizes the distribution of **station-to-station distances under 10 km** for rides taken by **customer (non-subscriber) riders** that did not involve tourist stations. The focus on shorter trips reveals finer patterns in local travel behavior.

##### Chart Details

- **X-Axis:** Distance Between Stations (km), ranging from 0 to 10 km  
- **Y-Axis:** Relative probability density of rides occurring at each distance  
- **Plot Style:** Smoothed density plot with area normalized to 1  
- **Annotations:** Peaks labeled to highlight the most common trip lengths  

##### Purpose

By excluding longer trips (>10 km), this chart provides a clearer view of the most typical ride distances, supporting planning and operational decisions about station placement and bike redistribution.

##### Observations

- **Primary Peak (0.86 km):** The most common ride length, suggesting very short intra-neighborhood trips.
- **Secondary Peak (1.29 km):** Another frequently observed trip length, likely representing local errands or commutes between adjacent districts.
- **Steep Decline:** Density decreases sharply beyond 4–5 km.
- **Absence of Long Tail:** Filtering out longer rides eliminates noise from infrequent long-distance trips.

##### Interpretation

- **Short-Distance Focus:** The dual peaks reinforce that casual users primarily rely on the system for short urban journeys.
- **Potential Trip Typologies:**
  - ~1 km: Last-mile or neighborhood-scale trips.
  - ~2–3 km: Short errands or transit connections.
- The low density beyond 5 km indicates that even non-tourist customers rarely use the bikes for longer travel.

##### Technical Notes

- **Distance Calculation:** Computed with the Haversine formula between station coordinates.
- **Filtering:** Only trips with distance ≤10 km are included.
- **Annotations:** Peaks were identified programmatically and labeled on the chart.
- **Density Scaling:** Y-axis reflects probability density, not counts.

##### R Code Used to Generate Chart:

```r
ggplot(non_loop_rides_df %>% filter(distance_km <= 10), aes(x = distance_km)) +
  geom_density(fill = "darkorange", alpha = 0.6) +
  geom_point(data = top_peaks, aes(x = x, y = y), color = "gray", size = 2) +
  geom_text(
    data = top_peaks,
    aes(x = x, y = y, label = paste0(" ", round(x, 2), " km")),
    angle = 25,
    vjust = 0,
    hjust = 0,
    size = 3.5,
    color = "black"
  ) +
  labs(
    title = "Non-Tourist Customer Distribution of Station-to-Station Distances (≤10 km)",
    x = "Distance Between Stations (km)",
    y = "Density"
  ) +
  theme_minimal()
```
