

```R
ggplot(non_tourist_customer_rides_df, aes(x = ride_length_min, fill = week_part)) +
     geom_density(alpha = 0.4) +
     scale_fill_manual(values = c("Weekday" = "darkblue", "Weekend" = "darkorange")) +
     labs(
         title = "Non-Tourist Customer Ride Duration by Weekday vs Weekend",
         x = "Ride Length (minutes)",
         fill = "Day Type"
     ) +
     theme_minimal()
```
