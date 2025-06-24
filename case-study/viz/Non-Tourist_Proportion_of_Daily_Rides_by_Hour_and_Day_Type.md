#### Non-Tourist Proportion of Daily Rides by Hour and Day Type

<figure class="float-right">
  <a href="../images/Non-Tourist_Proportion_of_Daily_Rides_by_Hour_and_Day_Type.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Proportion_of_Daily_Rides_by_Hour_and_Day_Type.png" alt=" Heatmap showing the hourly distribution of non-tourist rides as a proportion of daily rides, separated by weekday and weekend. Weekday rides peak between 17:00 and 18:00, while weekend rides show a broader distribution from late morning through the afternoon.">
  </a>
  <figcaption>
   Proportion of daily non-tourist rides by hour of day and day type (weekday vs. weekend). Weekdays show a clear peak in the late afternoon commute hours, while weekends have a more uniform midday distribution.
  </figcaption>
</figure>

##### Non-Tourist Proportion of Daily Rides by Hour and Day Type

This heatmap visualizes the hourly share of total daily rides for non-tourist users, broken out by **Day Type** (Weekday vs. Weekend). Darker orange indicates a higher proportion of rides within that hour relative to the day’s total.

##### Key Observations:
- **Weekdays** show a pronounced peak around **17:00–18:00**, corresponding to the evening commute.
- **Weekend** ride proportions are more evenly spread from **late morning through mid-afternoon**, peaking slightly between **12:00–16:00**.
- Early morning (before 6:00) and late evening (after 21:00) show minimal ride activity for both day types.

This visualization provides insight into how ride timing differs based on routine schedules, further supporting inferences about commuter versus recreational behavior.




```R
ggplot(ride_props, aes(x = hour, y = week_part, fill = prop)) +
     geom_tile() +
     scale_fill_gradient(low = "white", high = "darkorange") +
     labs(
         title = "Non-Tourist Proportion of Daily Rides by Hour and Day Type",
         x = "Hour of Day",
         y = "Day Type",
         fill = "Ride Proportion"
     ) +
     theme_minimal()
```
