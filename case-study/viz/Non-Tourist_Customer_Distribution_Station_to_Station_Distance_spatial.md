#### Station-to-Station Distance Distribution (Non-Tourist Customers)

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  Distribution of station-to-station distances for non-tourist customer rides. Most rides are short-distance trips, suggesting local, utility-based bike use.
  </figcaption>
</figure>

##### Overview

This density plot visualizes the distribution of distances between starting and ending stations for rides taken by casual (non-subscriber) users that do not involve tourist stations. The x-axis represents the distance in kilometers between two stations, and the y-axis represents the relative density of those ride distances.

##### Chart Details

-   X-Axis: Distance Between Stations (km), ranging from 0 to just over 30 km

-   Y-Axis: Relative density of rides occurring at each distance

-   Plot Style: Area-under-curve density plot (not a histogram), with a smooth curve and filled region

##### Purpose

This visualization illustrates the spatial extent of trips, showing how far non-tourist customers typically travel between stations across the system.

##### Observations

-   Peak around 1–2 km: The majority of rides occur between stations that are 1–2 km apart.

-   Steep decline: Ride density drops rapidly for distances above 5 km.

-   Long tail: A small number of rides extend beyond 10 km, with rare outliers over 20 km.

-   Very few extreme values: This confirms most rides are short-distance, utility-based.

##### Interpretation

-   The shape of the distribution suggests a strong preference for short-distance urban travel, which aligns with errand-running, last-mile commuting, or intra-neighborhood trips.

-   The sharp tapering suggests little casual use for long-distance travel, at least outside of tourist-heavy areas.

##### Technical Notes

-   Ride distances were calculated using the great-circle distance (Haversine formula) between station coordinates.

-   Tourist stations were excluded using a station filter based on known landmarks and locations.

-   Density plots normalize the area under the curve to 1, so the y-axis values represent probability density, not raw ride counts.


```R
ggplot(non_loop_rides_df, aes(x = distance_km)) + 
geom_density(fill = "darkorange", alpha = 0.6) +
labs(
title = "Non-Tourist_Customer_Distribution of Station-to-Station Distances",
x = "Distance Between Stations (km)",
y = "Density"
) +
theme_minimal()
```

