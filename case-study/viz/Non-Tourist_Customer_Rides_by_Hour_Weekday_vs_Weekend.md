#### Customer Rides by Hour: Weekday vs Weekend (Non-Tourist Stations)

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Rides_by_Hour_Weekday_vs_Weekend.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Rides_by_Hour_Weekday_vs_Weekend.png" alt="Grouped bar chart comparing hourly customer rides on weekdays and weekends at non-tourist stations. Weekday rides peak sharply at 5 PM while weekend rides are more evenly distributed across the midday hours.">
  </a>
  <figcaption>
  Hourly comparison of customer rides by day type (weekday vs weekend) at non-tourist stations, highlighting differences in temporal riding behavior.
  </figcaption>
</figure>

##### Overview

This grouped bar chart compares **customer ride activity** across hours of the day, split by **weekday** and **weekend**, limited to **non-tourist stations**. It highlights behavioral shifts in usage patterns between workdays and leisure days.

##### Chart Details

- **X-Axis**: Hour of day (0–23 in 24-hour format).
- **Y-Axis**: Number of rides initiated during that hour.
- **Bars**:
  - **Blue**: Weekday ride counts.
  - **Orange**: Weekend ride counts.
- Bars are grouped by hour to allow direct visual comparison between the two day types.

##### Purpose

This visualization is designed to isolate potential **commuting or habitual usage patterns** by removing the influence of tourist-heavy areas and separating ride behavior by the type of day.

##### Observations

- **Weekday Trends**:
  - Strong late afternoon peak at **17:00 (5 PM)** suggests post-work or school riding.
  - Moderate increase starting around **7–8 AM**, possibly indicating morning commutes.
  - Subdued activity in the early morning and late evening.

- **Weekend Trends**:
  - More even distribution throughout the **midday and early afternoon**.
  - No sharp peak, but elevated ridership between **10:00 and 16:00**.
  - Morning and evening ride counts are lower than weekday equivalents.

##### Interpretation

- The sharp peak at 5 PM on weekdays strongly suggests **commuter behavior**, even among casual (non-subscriber) users.
- The flatter weekend profile indicates a **more recreational or errand-driven pattern**, with rides spread across daylight hours.
- Filtering out tourist stations helps reinforce the interpretation that these behaviors stem from **local usage**, not tourism.

##### Technical Notes

- Ride records are filtered to include only those starting at **non-tourist stations**.
- Users included are labeled as `customer` (i.e., non-subscribers).
- “Weekday” includes Monday through Friday; “Weekend” includes Saturday and Sunday.
- Time is derived from the local timestamp of the ride start.

##### Data & Methods
**Data Sources**
- Data Frame: rides_by_hour_weekpart
   - Filters Applied:
     - Only customer rides (casual users)
     - Rides originating from non-tourist stations
     - Grouped by hour of day and week_part (Weekday vs Weekend)

**R Code Used to Generate Plot:**
```r
ggplot(rides_by_hour_weekpart, aes(x = hour, y = ride_count, fill = week_part)) +
geom_col(position = "dodge") +
labs(
title = "Customer Rides by Hour: Weekday vs Weekend (Non-Tourist Stations)",
x = "Hour of Day",
y = "Number of Rides",
fill = "Day Type"
) +
scale_x_continuous(breaks = 0:23) +
scale_fill_manual(values = c("Weekday" = "darkblue", "Weekend" = "darkorange")) +
theme_minimal()
```

<br style="clear: both;"></br>

