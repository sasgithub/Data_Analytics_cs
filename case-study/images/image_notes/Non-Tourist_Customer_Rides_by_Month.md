

```R
ggplot(non_tourist_customer_rides_df, aes(x = month)) +
     geom_bar(fill = "darkorange") +
     labs(
         title = "Non-Tourist Customer Rides by Month",
         x = "Month",
         y = "Number of Rides"
     ) +
     theme_minimal()
```
