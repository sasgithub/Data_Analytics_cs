## Non-Tourist Customer Rides by Day of the Week

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Rides_by_Day_of_the_Week.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Rides_by_Day_of_the_Week.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>



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
