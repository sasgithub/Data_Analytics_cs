## Non-Tourist Customer Rides by Hour of Day

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Rides_by_Hour_of_Day.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Rides_by_Hour_of_Day.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>



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

