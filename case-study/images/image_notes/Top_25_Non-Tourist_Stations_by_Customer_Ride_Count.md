## Top 25 Non-Tourist Stations by Customer Ride Count

<figure class="float-right">
  <a href="../Top_25_Non-Tourist_Stations_by_Customer_Ride_Count.png" target="_blank" title="Select image to open full sized chart">
  <img src="../thumbnail/Top_25_Non-Tourist_Stations_by_Customer_Ride_Count.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>




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
