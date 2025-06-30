

> rides_weather_df %>%
+     mutate(
+         temp_bin = floor(temp / 2) * 2,
+         precip_label = case_when(
+             is.na(prcp)      ~ "No data",
+             prcp == 0        ~ "Dry",
+             prcp > 0         ~ "Wet"
+         )
+     ) %>%
+     group_by(temp_bin, user_type, precip_label) %>%
+     summarise(rides = sum(rides), .groups = "drop") %>%
+     ggplot(aes(x = temp_bin, y = rides, color = user_type)) +
+     geom_line(size = 1) +
+     facet_wrap(~ precip_label, nrow = 1) +
+     labs(
+         title = "Ride Volume by Temperature and Precipitation",
+         subtitle = "2°C temperature bins grouped by rain condition",
+         x = "Temperature Bin (°C)",
+         y = "Total Rides",
+         color = "User Type"
+     ) +
+     scale_x_continuous(breaks = seq(-30, 40, by = 10)) +
+     theme_minimal(base_size = 14)

