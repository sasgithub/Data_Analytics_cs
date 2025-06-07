

```R
ggplot(ride_durations, aes(x = duration_min, fill = user_type)) +
     geom_histogram(binwidth = 2, position = "identity", alpha = 0.6) +
     labs(title = "Ride Duration Distribution", x = "Duration (minutes)", y = "Ride Count") +
     scale_fill_manual(values = c("subscriber" = "#1f77b4", "customer" = "#ff7f0e")) +
     scale_y_continuous(labels = label_number(scale_cut = cut_short_scale())) + 
     theme_minimal()
```

