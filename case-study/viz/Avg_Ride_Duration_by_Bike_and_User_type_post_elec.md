#### Average Ride Duration by Bike Type and User Type

<figure class="float-right">
  <a href="../images/Avg_Ride_Duration_by_Bike_and_User_type_post_elec.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Avg_Ride_Duration_by_Bike_and_User_type_post_elec.png" alt="Bar chart showing average ride duration in minutes by bike type and user type. Customers have much higher average durations on docked bikes, while subscribers show consistently shorter ride times across all bike types.">
  </a>
  <figcaption>
  Average ride duration by bike type and user type. Customers show much longer rides on docked bikes, while subscribers tend to have shorter, more consistent durations.
  </figcaption>
</figure>

##### Overview

This bar chart visualizes the **average ride duration** (in minutes) for each **bike type**, segmented by **user type** (Subscriber vs Customer), covering the period after electric bikes and scooters were introduced.

##### Axes and Groupings

- **X-Axis (Bike Type)**:
  - `classic_bike`
  - `docked_bike`
  - `electric_bike`
  - `electric_scooter`

- **Y-Axis (Average Ride Duration in Minutes)**:
  - Ranges up to 250 minutes for docked bikes.

- **Color Legend**:
  - **Red** = Subscriber
  - **Teal** = Customer

##### Observations

- **Docked Bikes**:
  - Customers have the highest average ride duration (>200 minutes).
  - Subscribers do not appear to use docked bikes (no bar present).

- **Classic Bikes**:
  - Customers average ~30–40 minutes per ride.
  - Subscribers average ~15 minutes.

- **Electric Bikes and Scooters**:
  - Both user groups show similar, shorter average durations (~10–15 minutes).
  - Customers have slightly longer rides than subscribers.

- **Variability**:
  - Docked bike rides by customers have large error bars, indicating substantial variation in trip lengths.

##### Interpretation

- **Customer Behavior**:
  - Non-subscribers take significantly longer trips on docked bikes, possibly reflecting more casual or exploratory riding.
  - For all bike types, customers tend to ride longer than subscribers.

- **Subscriber Behavior**:
  - Subscribers’ ride durations are generally shorter and more consistent, likely due to commuting or time-sensitive trips.

- **Operational Insight**:
  - The high variability of docked bike ride times suggests a need to further investigate usage patterns and pricing impacts.

##### Data Sources

- ****:
```r
duration_by_type <- post_electric_rides_df %>%
    group_by(user_type, bike_type) %>%
    summarise(
        avg_duration = mean(avg_duration_minutes, na.rm = TRUE),
        sd_duration = sd(avg_duration_minutes, na.rm = TRUE),
        .groups = "drop"
    )
```
- **Data Transformation in R:**

```r
duration_by_type$user_type <- fct_recode(as.factor(duration_by_type$user_type),
                                         "Subscriber" = "0",
                                         "Customer" = "1")
```

- **R Code Used to Generate Chart:**

```r
ggplot(duration_by_type, aes(
+     x = bike_type,
+     y = avg_duration,
+     fill = user_type
+ )) +
+     geom_bar(stat = "identity", position = position_dodge(width = 0.9)) +
+     geom_errorbar(aes(
+         ymin = avg_duration - sd_duration,
+         ymax = avg_duration + sd_duration
+     ), position = position_dodge(width = 0.9), width = 0.3) +
+     labs(
+         title = "Average Ride Duration by Bike Type and User Type",
+         x = "Bike Type",
+         y = "Avg Duration (minutes)",
+         fill = "User Type"
+     ) +
+     theme_minimal()
```

