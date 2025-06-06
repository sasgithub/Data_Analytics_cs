

```R
ggplot(post_electric_rides_df, aes(x = bike_type, y = rides_per_day, fill = user_type)) +
  geom_bar(stat = "identity", position = "stack") +
  labs(
    title = "Average Daily Rides by Bike Type and User Type",
    x = "Bike Type",
    y = "Average Rides per Day",
    fill = "User Type"
  ) +
  theme_minimal()
```
