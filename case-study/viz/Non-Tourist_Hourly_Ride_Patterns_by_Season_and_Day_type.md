#### Hourly Ride Patterns by Season and Day Type (Non-Tourist Stations)

<figure class="float-right">
  <a href="../images/Non-Tourist_Hourly_Ride_Patterns_by_Season_and_Day_type.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Hourly_Ride_Patterns_by_Season_and_Day_type.png" alt="Grouped bar charts showing hourly ride counts split by season (Fall, Spring, Summer, Winter) and further divided into Weekday and Weekend rides. Strong afternoon peaks on weekdays in Summer and Fall, flatter distributions on weekends and in Winter.">
  </a>
  <figcaption>
    Hourly ride counts at non-tourist stations, grouped by season and separated by weekday versus weekend, illustrating clear seasonal and temporal ridership patterns.
  </figcaption>
</figure>

##### Overview

This multi-panel grouped bar chart compares **hourly ride activity** across the four seasons, separated into **weekday** and **weekend** usage, restricted to non-tourist stations. It provides a clear view of how both **time of day** and **seasonality** influence ridership behavior among casual users.

##### Chart Details

- **X-Axis:** Hour of Day (0–23 in 24-hour format).
- **Y-Axis:** Number of Rides.
- **Bars:**
  - **Dark Blue:** Weekday rides.
  - **Dark Orange:** Weekend rides.
- **Facets:**
  - One panel per season: Fall, Spring, Summer, and Winter.
- **Position:** Bars are grouped side by side within each hour for comparison.

##### Purpose

The visualization aims to:
- Quantify the impact of **seasonal changes** on ridership volume.
- Identify **daily commute-like patterns** even among non-subscribers.
- Highlight how weekends differ from weekdays in temporal distribution.

##### Observations

- **Summer and Fall:**
  - Pronounced **weekday peaks around 17:00**, likely related to commuting or end-of-day activities.
  - Weekend ridership is elevated but spread more evenly across midday hours.
- **Spring:**
  - Similar but slightly lower weekday afternoon peaks.
- **Winter:**
  - Overall volume sharply reduced.
  - Flatter distribution throughout the day with only a mild afternoon increase on weekdays.

##### Interpretation

- Strong **weekday afternoon peaks** in warm months support the idea of commuting or routine trips by casual riders.
- Weekend rides remain relatively stable across seasons, indicating recreation and errands.
- Winter conditions significantly suppress all ride activity.

##### Technical Notes

- All rides are filtered to **exclude tourist stations**.
- Only rides by `customer` (non-subscriber) users are included.
- Local Chicago time used for hourly binning.
- Season assigned based on ride start date.

##### Data & Methods

Data source:
- `non_tourist_customer_rides_df`
  - Filtered for user_type = 1.
  - Filtered to non-tourist station IDs.

**R Code Used to Generate the Chart:**

```R
ggplot(rides_by_hour_season, aes(x = hour, y = ride_count, fill = week_part)) +
  geom_col(position = "dodge") +
  facet_wrap(~season, ncol = 2) +
  scale_x_continuous(breaks = 0:23) +
  scale_fill_manual(values = c("Weekday" = "darkblue", "Weekend" = "darkorange")) +
  labs(
    title = "Hourly Ride Patterns by Season and Day Type (Non-Tourist Stations)",
    x = "Hour of Day",
    y = "Number of Rides",
    fill = "Day Type"
  ) +
  theme_minimal()
```

<br style="clear: both;"></br>

