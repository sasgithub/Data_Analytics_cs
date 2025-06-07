

```R
ggplot(non_tourist_customer_rides_df, aes(x = season)) +
     geom_bar(fill = "darkorange") +
     labs(
         title = "Non-Tourist Customer Rides by Season",
         x = "Season",
         y = "Number of Rides"
     ) +
     theme_minimal()
```
