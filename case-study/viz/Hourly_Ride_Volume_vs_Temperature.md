## Hourly Ride Volume vs Temperature

<figure class="float-right">
  <a href="../images/Hourly_Ride_Volume_vs_Temperature.png" target="_blank" title="Select image to open full sized chart">
  <img src="../images/thumbnails/Hourly_Ride_Volume_vs_Temperature.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>





```R
ggplot(rides_weather_df, aes(x = temp, y = rides, color = user_type)) +
  geom_smooth(method = "loess", se = FALSE) +
  scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  scale_color_manual(values = c("subscriber" = "blue", "customer" = "red")) +
  labs(
    title = "Hourly Ride Volume vs Temperature",
    x = "Temperature (°C)",
    y = "Hourly Ride Volume",
    color = "User Type"
  ) +
  theme_minimal()
```

<br style="clear: both;"></br>
