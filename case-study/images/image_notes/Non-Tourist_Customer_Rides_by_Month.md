## TITLE

<figure class="float-right">
  <a href="../Non-Tourist_Customer_Rides_by_Month.png" target="_blank" title="Select image to open full sized chart">
  <img src="../Non-Tourist_Customer_Rides_by_Month.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>




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
