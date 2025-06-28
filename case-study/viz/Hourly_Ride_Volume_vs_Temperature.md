#### Hourly Ride Volume vs Temperature

<figure class="float-right">
  <a href="../images/Hourly_Ride_Volume_vs_Temperature.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Hourly_Ride_Volume_vs_Temperature.png" alt="Line chart showing hourly ride volume by temperature in Celsius. Subscribers (blue line) maintain higher ride volumes across all temperatures compared to customers (red line). Ride volume increases steadily from below freezing to 35°C.">
  </a>
  <figcaption>
    Smoothed hourly ride volume as a function of temperature, by user type. Subscriber activity increases steadily as temperatures warm, while customer rides also rise but remain lower overall.
  </figcaption>
</figure>

##### Overview

This chart shows how **average hourly ride volume** varies with **ambient temperature**, comparing **subscribers** and **customers**. The data was smoothed using LOESS to reveal overall trends.

##### Axes

- **X-Axis (Temperature °C)**:
  - Ranges from -25°C to ~38°C.
  - Divided into evenly spaced bins.

- **Y-Axis (Hourly Ride Volume)**:
  - Number of rides per hour.
  - Scaled with abbreviated labels (e.g., 500, 1K).

##### Visual Elements

- **Blue Line**: Subscribers.
- **Red Line**: Customers.
- LOESS smoothing without confidence intervals.

##### Observations

- **Cold Weather (-20°C to 0°C)**:
  - Both user types ride infrequently, though subscribers maintain higher relative volume.
  - Customer volume dips to a shallow trough around -10°C.

- **Warming Trend (0–20°C)**:
  - Steady increase in rides for both groups.
  - Subscriber volume roughly doubles between freezing and 20°C.

- **Hot Weather (25–35°C)**:
  - No visible decline in ride volume at the highest temperatures.
  - Unlike some systems that show tapering during heat waves, this dataset suggests continued strong usage as it warms.
  - This may reflect:
    - High recreational demand in summer.
    - Longer daylight hours encouraging extended riding.
    - Possibly the relatively moderate humidity or urban heat adaptation.

- **Relative Usage**:
  - Subscribers consistently ride more than customers across the entire temperature range.

##### Interpretation

- Unlike expectations of a heat penalty, Divvy usage here shows **continual positive correlation between temperature and ridership**.
- This pattern may be specific to Chicago’s climate, where even hot days are preferred over cold ones for biking.
- Subscribers are more resilient to temperature extremes compared to customers.

##### R Code Used to Generate Chart:




```R
ggplot(rides_weather_df, aes(x = temp, y = rides, color = user_type)) +
  geom_smooth(method = "loess", se = FALSE) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  scale_color_manual(values = c("subscriber" = "blue", "customer" = "red")) +
  labs(
    title = "Hourly Ride Volume vs Temperature",
    x = "Temperature (°C)",
    y = "Hourly Ride Volume",
    color = "User Type"
  ) +
  theme_minimal()
```

<br style="clear: both;"></br>
