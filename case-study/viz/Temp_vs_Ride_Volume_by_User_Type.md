#### Temperature vs Ride Volume by User Type

<figure class="float-right">
  <a href="../images/Temp_vs_Ride_Volume_by_User_Type.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Temp_vs_Ride_Volume_by_User_Type.png" alt=" Line chart with two panels comparing hourly ride volume versus temperature for customers and subscribers. Both show a strong positive correlation with temperature, with ride volume increasing sharply as temperatures rise above freezing.">
  </a>
  <figcaption>
   Hourly ride volume by temperature, faceted by user type. Warmer temperatures correlate strongly with increased ride volume for both customers and subscribers, with subscriber volume remaining higher across all temperatures.
  </figcaption>
</figure>

##### Overview

This dual-panel line plot compares **hourly ride volume** to **temperature (°C)** for each user type separately. It illustrates how customers and subscribers respond differently to temperature changes.

##### Chart Details

- **X-Axis:** Temperature in °C.
- **Y-Axis:** Hourly ride count.
- **Facets:**
  - Left: Customers.
  - Right: Subscribers.
- **Line:** LOESS smooth showing trend across all hourly observations.

##### Observations

- Ride volume is **lowest below freezing**, rising quickly as temperatures warm.
- **Subscribers** consistently have higher hourly volume across the entire temperature range.
- Both user types show a **smooth, nonlinear increase**, with no clear plateau in the observed temperatures.
- The upward trend becomes especially pronounced above ~20°C.

##### Interpretation

These patterns suggest that temperature strongly influences ridership among both groups, but subscribers are more resilient to cold and maintain more consistent usage. The continuous rise highlights that moderate and warm weather significantly increase demand.

##### Data Sources

- **Trip Data:** Divvy trip records from:
  - 2013–2019 (S3 archive)
  - 2023–2025 (City of Chicago Data Portal)
- **Weather Data:** Chicago Midway Airport hourly observations via Meteostat.

###### Data Preparation

- Rides aggregated per hour and user type (`COUNT(*) AS rides`).
- Weather joined on hourly epoch timestamp (`start_time / 3600 * 3600`).
- No filtering by precipitation.
- LOESS smoothing applied within each user type facet.

###### R Code Used to Generate Chart:

```R
ggplot(rides_weather_df, aes(x = temp, y = rides)) +
     geom_smooth(method = "loess", se = FALSE, color = "darkgreen") +
     scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
     facet_wrap(~ user_type) +
     labs(
         title = "Temperature vs Ride Volume by User Type",
         x = "Temperature (°C)",
         y = "Hourly Ride Volume"
     ) +
     theme_minimal()
```
