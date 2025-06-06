

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

