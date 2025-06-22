## Temperature vs Ride Volume by User Type

<figure class="float-right">
  <a href="../Temp_vs_Ride_Volume_by_User_Type.png" target="_blank" title="Select image to open full sized chart">
  <img src="../thumbnail/Temp_vs_Ride_Volume_by_User_Type.png" alt="ALT_TEXT">
  </a>
  <figcaption>
  FIGCAPTION
  </figcaption>
</figure>




```R
ggplot(rides_weather_df, aes(x = temp, y = rides)) +
     geom_smooth(method = "loess", se = FALSE, color = "darkgreen") +
     scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) +
     facet_wrap(~ user_type) +
     labs(
         title = "Temperature vs Ride Volume by User Type",
         x = "Temperature (°C)",
         y = "Hourly Ride Volume"
     ) +
     theme_minimal()
```
