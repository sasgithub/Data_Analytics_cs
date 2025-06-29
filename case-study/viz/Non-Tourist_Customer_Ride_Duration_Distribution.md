#### Non-Tourist Customer Ride Duration Distribution

<figure class="float-right">
  <a href="../images/Non-Tourist_Customer_Ride_Duration_Distribution.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Non-Tourist_Customer_Ride_Duration_Distribution.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>

**R Code Used to Generate the Chart:**

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
