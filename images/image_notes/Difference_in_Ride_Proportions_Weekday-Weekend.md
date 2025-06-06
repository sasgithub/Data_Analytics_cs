

```R
ggplot(prop_wide, aes(x = hour, y = 1, fill = diff)) +
     geom_tile() +
     scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0) +
     labs(
         title = "Difference in Ride Proportions: Weekday - Weekend",
         x = "Hour of Day",
         y = NULL,
         fill = "Weekday > Weekend"
     ) +
     theme_minimal()
```
