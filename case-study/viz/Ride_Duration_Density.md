#### Ride Duration Density

<figure class="float-right">
  <a href="../images/Ride_Duration_Density.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Ride_Duration_Density.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>

##### Overview

This density plot visualizes the **distribution of ride durations** for customers and subscribers, providing a smoothed alternative to histograms for easier comparison of patterns.

##### Chart Details

- **X-Axis:** Ride duration in minutes (0–60 min).
- **Y-Axis:** Density estimate of ride frequency.
- **Lines/Areas:**
  - **Blue (Subscribers):** High, narrow peak at short durations.
  - **Orange (Customers):** Flatter, broader distribution extending to longer rides.
- **Smoothing:** Kernel density estimation applied with default bandwidth.

##### Observations

- **Subscribers:**
  - Strong peak centered around ~10–15 minutes.
  - Rapid decline beyond ~20 minutes.
  - Indicates trips optimized for commuting or quick errands.
- **Customers:**
  - Less pronounced peak.
  - Long tail extending to ~60 minutes.
  - Reflects more recreational or exploratory rides.

##### Interpretation

The contrasting shapes highlight different usage patterns:
- **Subscribers** prioritize efficiency and short trips, likely influenced by pricing incentives and commute needs.
- **Customers** are more likely to take longer rides with varied trip purposes.

##### Data Sources

- **Trip Data:** Divvy ride records from:
  - 2013–2019 (S3 archive)
  - 2023–2025 (City of Chicago Data Portal)

##### Data Preparation

- Selected rides where:
  - `user_type` is 0 (subscriber) or 1 (customer).
  - `end_time > start_time`.
  - Duration < 200 minutes.
- Duration computed as `(end_time - start_time) / 60`.
- No filtering by station type.

###### R Code Used to Generate Chart:

```R
ggplot(ride_durations, aes(x = duration_min, color = user_type, fill = user_type)) +
     geom_density(alpha = 0.3) +
     labs(title = "Ride Duration Density", x = "Duration (minutes)", y = "Density") +
     scale_color_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
     scale_fill_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
     theme_minimal()
```
