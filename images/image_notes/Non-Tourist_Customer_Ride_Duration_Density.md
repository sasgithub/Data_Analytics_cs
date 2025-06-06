

```R
ggplot(non_tourist_customer_rides_df, aes(x = ride_length_min)) +
     geom_density(fill = "darkorange") +
     labs(
         title = "Non-Tourist Customer Ride Duration Density",
         x = "Ride Length (minutes)",
         y = "Density"
     ) +
     theme_minimal()
```
