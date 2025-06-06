

```R
ggplot(daily_avg_df, aes(
     x = bike_type,
     y = avg_rides_per_day,
     fill = fct_recode(as.factor(user_type),
                       "Subscriber" = "0",
                       "Customer" = "1")
 )) +
     geom_bar(stat = "identity", position = "dodge") +
     labs(
         title = "Average Daily Rides by Bike Type and User Type (Post-Electric Launch)",
         x = "Bike Type",
         y = "Average Rides per Day",
         fill = "User Type"
     ) +
     theme_minimal()
```
