```R
> avg_df  <- readr::read_csv("/data/temp_vs_rides_avg.csv")
> # Normalize each column to 0-1
> normalized_df <- avg_df %>%
+     mutate(across(c(subs, cust, avg), ~ (. - min(.)) / (max(.) - min(.)))) %>%
+     pivot_longer(cols = c(subs, cust, avg), names_to = "user_type", values_to = "normalized_rides")
```

