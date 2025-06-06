

```R
ggplot(loop_rides_non_tourist, aes(x = ride_length_min, fill = interaction(week_part, hour_local))) 
+
geom_histogram(binwidth = 1, position = "identity", alpha = 0.5) +
facet_wrap(~ hour_local, ncol = 4) +
labs(title = "Loop Ride Length Distribution by Week Part and Time of Day",
x = "Ride Length (minutes)",
y = "Ride Count",
fill = "Week/Time") +
theme_minimal()
```

