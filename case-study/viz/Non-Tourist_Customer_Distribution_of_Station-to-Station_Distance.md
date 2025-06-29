#### Non-Tourist Customer Distribution of Station-to-Station Distances

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" alt="Density plot showing the distribution of ride distances between start and end stations for non-tourist customer rides. Labeled peaks mark commonly traveled distance ranges.">
  </a>
  <figcaption>
  Density plot of station-to-station distances for non-tourist customer rides. Distinct peaks highlight preferred trip lengths and usage patterns.
  </figcaption>
</figure>

##### Overview

This density plot shows the **distribution of ride distances** (in kilometers) for **non-tourist customer rides** where the start and end stations differ (i.e., excluding loops). Labeled peaks call attention to common trip lengths.

##### Chart Details

- **X-Axis:** Distance between stations (km).
- **Y-Axis:** Density (normalized proportion of rides).
- **Elements:**
  - **Orange Curve:** Smoothed density estimate of all rides.
  - **Gray Points:** Locations of top peaks.
  - **Text Labels:** Distance of each peak (e.g., “1.25 km”).

##### Observations

- A pronounced peak around **1.2–1.5 km**, suggesting many trips are short.
- Secondary peaks near **2.5 km** and **3.5 km** may reflect popular commuting corridors.
- The distribution tapers gradually beyond 5 km, indicating longer rides are less frequent but still occur.

##### Interpretation

- The strong concentration in the 1–2 km range likely reflects neighborhood trips, errands, and short connections.
- The presence of distinct peaks at larger distances suggests repeated use of certain longer routes.
- Planners could use this to identify popular station pairs and inform station placement or rebalancing strategies.

##### Data Sources

- **Ride Data:** Rides starting in 2023 or later, from stations not classified as tourist locations.
- **Station Locations:** Latitude and longitude of all active stations, joined to ride records for distance calculation.

##### Data Preparation

- Rides filtered to:
  - **User Type:** Customer.
  - **Start ≠ End Station.**
- Distances calculated using the Haversine formula (`geosphere::distHaversine`).
- Density estimated with `geom_density()`.

##### R Code Used to Generate Chart:

```r
ggplot(non_loop_rides_df, aes(x = distance_km)) +
  geom_density(fill = "darkorange", alpha = 0.5) +
  geom_point(data = top_peaks, aes(x = x, y = y), color = "gray", size = 2) +
  geom_text(
    data = top_peaks,
    aes(
      x = x,
      y = y,
      label = paste0(" ", round(x, 2), " km")
    ),
    angle = 25,
    vjust = 0,
    hjust = 0,
    size = 3.5,
    color = "black"
  ) +
  labs(
    title = "Non-Tourist Customer Distribution of Station-to-Station Distances",
    x = "Distance Between Stations (km)",
    y = "Density"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 1)
  )
```

##### R Code Used to Generate Chart:

```r
ggplot(non_loop_rides_df, aes(x = distance_km)) +
  geom_density(fill = "darkorange", alpha = 0.5) +
  geom_point(data = top_peaks, aes(x = x, y = y), color = "gray", size = 2) +
  geom_text(
    data = top_peaks, aes(x = x, y = y, label = paste0(" ", round(x, 2), " km")),
    angle = 25, vjust = 0, hjust = 0, size = 3.5, color = "black"
  ) +
  labs(
    title = "Non-Tourist Customer Distribution of Station-to-Station Distances",
    x = "Distance Between Stations (km)",
    y = "Density"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 1)
  )
```


<br style="clear: both;"></br>

