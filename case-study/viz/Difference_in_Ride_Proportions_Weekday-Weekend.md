#### Difference in Ride Proportions Weekday to Weekend

<figure class="float-right">
  <a href="../images/Difference_in_Ride_Proportions_Weekday-Weekend.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Difference_in_Ride_Proportions_Weekday-Weekend.png" alt="Heatmap showing the difference in ride proportions between weekdays and weekends across each hour of the day. Red indicates hours with higher weekday proportions; blue indicates higher weekend proportions.">
  </a>
  <figcaption>
  Hourly difference in ride proportions: Weekday minus Weekend. Red tones highlight hours where weekday rides are more frequent proportionally; blue tones highlight hours dominated by weekend activity.
  </figcaption>
</figure>

##### Overview

This heatmap shows the **proportional difference in ride volume** by hour of the day between **weekdays** and **weekends**. It normalizes each group separately so the visualization highlights **relative time-of-day preference**, independent of the total ride volume.

##### Chart Details

- **X-Axis:** Hour of Day (0–23)
- **Y-Axis:** Dummy axis to create a horizontal heatmap band (no intrinsic meaning)
- **Color Scale:**
  - **Red:** Hours with proportionally higher weekday usage
  - **Blue:** Hours with proportionally higher weekend usage
  - **White:** No significant difference

##### Observations

- **Weekday-dominant hours:**
  - Strong peaks in the **morning (7–9 AM)** and **late afternoon (4–6 PM)**.
  - Consistent with commuter patterns among customers using non-tourist stations.

- **Weekend-dominant hours:**
  - Midday and early afternoon (**10 AM–3 PM**) show higher weekend share, likely indicating recreational or leisure use.

- **Evenings:**
  - Some residual weekday preference persists into the evening, but less pronounced.

##### Interpretation

- This chart highlights the **behavioral shift** between weekdays and weekends.
- Even when weekends have high total ride volume, customers distribute their rides more evenly across midday hours.
- Weekdays concentrate ridership in commute-related time blocks.

##### Data Sources

- **rides** table filtered for:
  - `user_type = 1` (customer)
  - Non-tourist stations (start and end)
  - Rides after `2023-01-01`
- Derived tables:
  - `rides_by_hour_weekpart`: Hourly counts by weekday/weekend
  - `ride_props`: Proportions normalized within each week part
  - `prop_wide`: Wide-format table for computing differences


##### R Code Used to Generate Chart:

```r
ggplot(prop_wide, aes(x = hour, y = 1, fill = diff)) +
     geom_tile() +
     scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
     labs(
         title = "Difference in Ride Proportions: Weekday - Weekend",
         x = "Hour of Day",
         y = NULL,
         fill = "Weekday > Weekend"
     ) +
     theme_minimal()
```
