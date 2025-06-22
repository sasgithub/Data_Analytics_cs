## Non-Tourist Customer Distribution of Station-to-Station Distances

<figure class="float-right">
  <a href="../Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" target="_blank" title="Select image to open full sized chart">
  <img src="../thumbnail/Non-Tourist_Customer_Distribution_of_Station-to-Station_Distance.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>




```R
ggplot(non_loop_rides_df, aes(x = distance_km)) + 
geom_density(fill = "darkorange", alpha = 0.6) +
labs(
title = "Non-Tourist_Customer_Distribution of Station-to-Station Distances",
x = "Distance Between Stations (km)",
y = "Density"
) +
theme_minimal()
```

