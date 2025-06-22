## Non-Tourist Proportion of Daily Rides by Hour and Day Type

<figure class="float-right">
  <a href="../Non-Tourist_Proportion_of_Daily_Rides_by_Hour_and_Day_Type.png" target="_blank" title="Select image to open full sized chart">
  <img src="../thumbnail/Non-Tourist_Proportion_of_Daily_Rides_by_Hour_and_Day_Type.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>




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
