```r
top_n <- 20
asym_top <- asym_data %>%
    group_by(user_type_label) %>%
    slice_max(order_by = asymmetry_ratio, n = top_n, with_ties = FALSE) %>%
    ungroup()
asym_top <- asym_top %>%
    mutate(path_label = paste(station_a_name, "→", station_b_name))
```

