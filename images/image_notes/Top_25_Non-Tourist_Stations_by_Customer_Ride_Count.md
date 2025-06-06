

```R
ggplot(top_non_tourist_stations_named, aes(
   x = reorder(name, customer_ride_count),
   y = customer_ride_count
   )) +
   geom_col(fill = "steelblue") +
   coord_flip() +
   labs(
     title = "Top 25 Non-Tourist Stations by Customer Ride Count",
     x = "Station",
     y = "Customer Rides"
) +
theme_minimal()
```
