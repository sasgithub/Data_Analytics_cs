## Non-Tourist Customer Rides by Season

<figure class="float-right">
  <a href="../Non-Tourist_Customer_Rides_by_Season.png" target="_blank" title="Select image to open full sized chart">
  <img src="../thumbnail/Non-Tourist_Customer_Rides_by_Season.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>




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
