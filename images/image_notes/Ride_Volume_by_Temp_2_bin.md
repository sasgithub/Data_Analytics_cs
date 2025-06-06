
```R
ggplot(aes(x = temp_bin, y = rides, color = user_type)) +
     geom_line(size = 1) +
     facet_wrap(~ precip_label, nrow = 1) +
     labs(
         title = "Ride Volume by Temperature and Precipitation",
         subtitle = "2°C temperature bins grouped by rain condition",
         x = "Temperature Bin (°C)",
         y = "Total Rides",
         color = "User Type"
     ) +
     scale_x_continuous(breaks = seq(-30, 40, by = 10)) +
     theme_minimal(base_size = 14)
```
