### asym_top

**Data Origin**  
Derived directly from the `asym_data` data frame, which summarizes directional ride imbalances between station pairs.

**How Created**  
Filtered and transformed in R to select the top 20 most asymmetric station pairs per user type:

```r
top_n <- 20
asym_top <- asym_data %>%
    group_by(user_type_label) %>%
    slice_max(order_by = asymmetry_ratio, n = top_n, with_ties = FALSE) %>%
    ungroup()

asym_top <- asym_top %>%
    mutate(path_label = paste(station_a_name, "→", station_b_name))
```

**Purpose and Use in Analysis**  
- Highlights the most directionally imbalanced origin–destination pairs.
- Supports visualizations and targeted exploration of asymmetric usage patterns.
- The `path_label` column provides a readable label for chart axes and tables.

**Columns**  
Same columns as `asym_data`, plus:  
- `path_label`: Combined string of station names in the format “A → B”.


