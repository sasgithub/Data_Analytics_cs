

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

