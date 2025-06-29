#### Station-to-Station Distance Distribution (Non-Tourist Customers)

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" alt="Density plot showing distribution of distances between start and end stations for non-tourist customer rides. The curve peaks around 1–2 km and tapers off rapidly above 5 km.">
  </a>
  <figcaption>
    Distribution of station-to-station distances for non-tourist customer rides. Most trips are under 5 km, confirming primarily short-distance usage.
  </figcaption>
</figure>

##### Overview

This density plot visualizes the distribution of **station-to-station distances** for rides taken by **customer (non-subscriber) riders** that do not involve tourist stations. The x-axis represents the distance in kilometers, and the y-axis shows the relative density of rides occurring at each distance.

##### Chart Details

- **X-Axis:** Distance Between Stations (km), ranging from 0 to ~30 km  
- **Y-Axis:** Relative probability density of rides at each distance  
- **Plot Style:** Smoothed density plot (not a histogram), area under the curve normalized to 1  

##### Purpose

This chart highlights the typical distance casual riders travel between stations when tourist hotspots are excluded, revealing patterns in local, everyday bike-share use.

##### Observations

- **Peak around 1 km:** Most rides are short hops between closely spaced stations.
- **Steep decline:** Density drops quickly after ~5 km.
- **Long tail:** A small number of rides extend past 10 km.
- **Very few extreme values:** Rides over 20 km are rare outliers.

##### Interpretation

- The pronounced twin peaks around 1 km suggests **short-distance, utility-oriented trips**, like errands or first-/last-mile commuting.
- The long but thin tail implies that while occasional longer rides occur, they are uncommon among non-tourist customer riders.
- The lack of a multiple wide spaced peaks differentiates this distribution from tourist-heavy patterns, which often show multiple modes due to popular routes.

##### Technical Notes

- **Distance Calculation:** Great-circle distance (Haversine formula) computed between station coordinates.
- **Filtering:** Tourist stations excluded via station ID filtering.
- **Density Scaling:** The y-axis shows density, not raw counts. The area under the curve sums to 1.

##### R Code Used to Generate Chart:

```r
ggplot(non_loop_rides_df, aes(x = distance_km)) +
  geom_density(fill = "darkorange", alpha = 0.6) +
  labs(
    title = "Non-Tourist Customer Distribution of Station-to-Station Distances",
    x = "Distance Between Stations (km)",
    y = "Density"
  ) +
  theme_minimal()
```

