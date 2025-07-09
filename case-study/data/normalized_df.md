## Provenance of normalized_df

### `normalized_df`

**Description:**  
A normalized version of average ride counts across temperature bins, prepared for comparative visualization.

**Provenance Details:**

- **Source File:**  
  [`temp_vs_rides_avg.csv`](temp_vs_rides_avg.csv.md)

- **Intermediate Object:**  
  `avg_df` — loaded from CSV using `readr::read_csv()`

- **Transformations:**
  - Applied min-max normalization (0–1 scale) to three columns: `subs`, `cust`, and `avg`.
  - Reshaped the data from wide to long format using `pivot_longer`, producing a unified `user_type` column and corresponding `normalized_rides` values.

- **Code:**

  ```r
  avg_df  <- readr::read_csv("/data/temp_vs_rides_avg.csv")
  normalized_df <- avg_df %>%
    mutate(across(c(subs, cust, avg), ~ (. - min(.)) / (max(.) - min(.)))) %>%
    pivot_longer(cols = c(subs, cust, avg), names_to = "user_type", values_to = "normalized_rides")
```

**Purpose:**

  - To enable fair visual comparison of ride volume trends across user types regardless of absolute scale.

