

```R
ggplot(non_tourist_customer_rides_df, aes(x = ride_length_min)) +
     geom_histogram(binwidth = 5, fill = "darkorange", color = "white") +
     labs(
         title = "Non-Tourist Customer Ride Duration Distribution",
         x = "Ride Length (minutes)",
         y = "Number of Rides"
     ) +
     theme_minimal()
```
