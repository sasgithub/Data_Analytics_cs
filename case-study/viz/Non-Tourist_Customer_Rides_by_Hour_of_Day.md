### Customer Rides by Hour of the Day (Non-Tourist Stations)

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Rides_by_Hour_of_Day.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Rides_by_Hour_of_Day.png" alt="Bar chart showing the distribution of Divvy customer rides by hour of the day at non-tourist stations. Ride volume starts low in the early morning, builds steadily through the day, and peaks sharply at 17:00 (5 PM).">
  </a>
  <figcaption>
  Hourly distribution of customer rides originating from non-tourist stations, showing peak activity in the late afternoon.
  </figcaption>
</figure>

#### Overview

This bar chart displays the number of rides taken by **customers** at **non-tourist stations**, broken down by hour of the day (0–23 in 24-hour time).

#### Chart Details

- **X-Axis**: Hour of day (0 = midnight, 12 = noon, 23 = 11 PM).
- **Y-Axis**: Number of rides initiated during that hour.
- **Bars**: Represent hourly ride counts for all customer rides at stations not flagged as tourist destinations.

#### Purpose

The chart focuses on identifying usage patterns for casual riders outside of high-tourism areas. This helps differentiate recreational behavior from possible commuting or errand-related riding.

#### Observations

- **Early morning (0–5 AM)**: Very low ride activity.
- **Morning buildup (6–11 AM)**: Steady increase as the day begins.
- **Midday plateau (12–15 PM)**: Moderate and stable ride volume.
- **Peak hours (16–18 PM)**: Sharp rise to the highest point at 17:00, then a slight drop by 18:00.
- **Evening taper (19–23 PM)**: Gradual decline in ride volume, but still substantial.

#### Interpretation

- The late afternoon peak around **5 PM** is notable and may reflect:
  - Post-work or post-school recreational usage.
  - Casual commuters avoiding rush hour traffic.
- Morning and midday usage suggests a blend of leisure, errands, or part-time commuting.
- The exclusion of tourist stations implies these rides are more likely by residents or local users rather than out-of-town visitors.

#### Technical Notes

- Tourist stations were filtered out based on a predefined list of station IDs.
- Only rides by users marked as `customer` were included.
- Time is based on ride start timestamps, converted to local time.
- Bin width is 1 hour per bar, covering a full 24-hour period.


```R
ggplot(rides_by_hour_weekpart, aes(x = hour, y = ride_count, fill = week_part)) +
     geom_col(position = "dodge") +
     labs(
         title = "Non-Tourist Customer Rides by Hour of Day",
         subtitle = "Adjusted to Chicago Local Time",
         x = "Hour of Day",
         y = "Ride Count",
         fill = "Day Type"
     ) +
     scale_x_continuous(breaks = 0:23) +
     theme_minimal()
```

<br style="clear: both;"></br>

