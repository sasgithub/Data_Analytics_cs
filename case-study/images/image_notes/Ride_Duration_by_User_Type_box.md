

```R
ggplot(ride_durations, aes(x = user_type, y = duration_min, fill = user_type)) +
     geom_boxplot(outlier.alpha = 0.1) +
     labs(title = "Ride Duration by User Type", x = "", y = "Duration (minutes)") +
     scale_fill_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
     theme_minimal()
```
