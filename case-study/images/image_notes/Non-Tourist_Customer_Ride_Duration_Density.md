## Non-Tourist Customer Ride Duration Density

<figure class="float-right">
  <a href="../Non-Tourist_Customer_Ride_Duration_Density.png" target="_blank" title="Select image to open full sized chart">
  <img src="../thumbnail/Non-Tourist_Customer_Ride_Duration_Density.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>




```R
ggplot(non_tourist_customer_rides_df, aes(x = ride_length_min)) +
     geom_density(fill = "darkorange") +
     labs(
         title = "Non-Tourist Customer Ride Duration Density",
         x = "Ride Length (minutes)",
         y = "Density"
     ) +
     theme_minimal()
```
