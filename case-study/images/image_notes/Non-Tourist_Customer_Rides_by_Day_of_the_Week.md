

```R
ggplot(non_tourist_customer_rides_df, aes(x = day_of_week)) +
     geom_bar(fill = "steelblue") +
     labs(
         title = "Non-Tourist Customer Rides by Day of the Week",
         x = "Day of the Week",
         y = "Number of Rides"
     ) +
     theme_minimal()
```
