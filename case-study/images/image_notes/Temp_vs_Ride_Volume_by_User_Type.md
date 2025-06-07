

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
