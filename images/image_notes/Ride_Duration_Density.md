

```R
ggplot(ride_durations, aes(x = duration_min, color = user_type, fill = user_type)) +
     geom_density(alpha = 0.3) +
     labs(title = "Ride Duration Density", x = "Duration (minutes)", y = "Density") +
     scale_color_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
     scale_fill_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
     theme_minimal()
```
