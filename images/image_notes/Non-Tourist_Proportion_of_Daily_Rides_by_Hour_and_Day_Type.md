

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
